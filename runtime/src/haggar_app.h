// haggar: the ReXApp subclass. The SDK's ReXApp owns the window, the runtime
// (Xenia's kernel, XAM, xbdm, GPU and audio) and the main guest thread.
//
//   haggar --game <folder holding the build's XEX, MegaHaloGame\ and Engine\>
//          [--capture_every=<seconds> --capture_dir=<folder>] [--press=<script>]

#pragma once

#include <atomic>
#include <chrono>
#include <condition_variable>
#include <filesystem>
#include <fstream>
#include <mutex>
#include <string>
#include <thread>

#include <rex/cvar.h>
#include <rex/filesystem/devices/host_path_device.h>
#include <rex/filesystem/vfs.h>
#include <rex/logging.h>
#include <rex/rex_app.h>
#include <rex/runtime.h>
#include <rex/system/interfaces/graphics.h>
#include <rex/input/input_system.h>
#include <rex/ui/presenter.h>

#include "scripted_pad.h"

REXCVAR_DEFINE_STRING(game, "", "haggar",
                      "Folder holding the build's XEX and its content (same as --game_data_root)");
REXCVAR_DEFINE_INT32(capture_every, 0, "haggar",
                     "Write the guest frame as a PPM every N seconds (0: off)");
REXCVAR_DEFINE_STRING(capture_dir, "", "haggar", "Folder for --capture_every (default: user data)");
REXCVAR_DEFINE_STRING(press, "", "haggar",
                      "Scripted controller for unattended runs, e.g. \"A@40,LS_UP@60-70\" (scripted_pad.h)");
REXCVAR_DECLARE(std::string, gpu_plugin);

class HaggarApp : public rex::ReXApp {
 public:
  using rex::ReXApp::ReXApp;

  static std::unique_ptr<rex::ui::WindowedApp> Create(rex::ui::WindowedAppContext& ctx) {
    return std::unique_ptr<HaggarApp>(new HaggarApp(ctx, "haggar", PPCImageConfig));
  }

  void OnConfigurePaths(rex::PathConfig& paths) override {
    if (!REXCVAR_GET(game).empty())
      paths.game_data_root = REXCVAR_GET(game);
    // The Xenos GPU emulation; ReXApp leaves the GPU off unless a plugin is named.
    if (REXCVAR_GET(gpu_plugin).empty())
      REXCVAR_SET(gpu_plugin, "xenos");
    game_root_ = paths.game_data_root;
  }

  // The build's XEX keeps its own name (MegaHaloGame.xex, or the release
  // name it shipped with); load whichever is in the game folder.
  void OnLoadXexImage(std::string& xex_image) override {
    for (const char* name : {"default.xex", "MegaHaloGame.xex", "MegaHaloGame-Xbox360-Release.MProfP1.xex"}) {
      if (std::filesystem::is_regular_file(game_root_ / name)) {
        xex_image = std::string("game:\\") + name;
        return;
      }
    }
  }

  // DmMapDevkitDrive succeeds, and the game then writes its profiling and log
  // files under DEVKIT:\ (it asserts if it can't). Xenia maps that drive to a
  // writable host folder; this maps it to <user data>/devkit.
  void OnPostSetup() override {
    auto host = std::filesystem::absolute(user_data_root() / "devkit");
    std::filesystem::create_directories(host);
    constexpr const char* kMount = "\\DEVKIT";
    auto device = std::make_unique<rex::filesystem::HostPathDevice>(kMount, host, false);
    auto* fs = runtime()->file_system();
    if (!device->Initialize() || !fs->RegisterDevice(std::move(device))) {
      REXLOG_ERROR("haggar: could not map DEVKIT: to {}", host.string());
      return;
    }
    fs->RegisterSymbolicLink("DEVKIT:", kMount);
    fs->RegisterSymbolicLink("e:", kMount);

    if (!REXCVAR_GET(press).empty()) {
      auto pad = std::make_unique<ScriptedPad>(window(), ScriptedPad::Parse(REXCVAR_GET(press)));
      scripted_pad_ = pad.get();
      auto* input = static_cast<rex::input::InputSystem*>(runtime()->input_system());
      input->AddDriver(std::move(pad));  // GetState re-enumerates the drivers
    }
  }

  // --capture_every: the guest's output, read back from the GPU, so it works
  // whatever is on the screen.
  void OnPostLaunchModule(rex::system::XThread*) override {
    if (scripted_pad_)
      scripted_pad_->Restart();
    const int every = REXCVAR_GET(capture_every);
    if (every <= 0)
      return;
    std::filesystem::path dir = REXCVAR_GET(capture_dir).empty()
                                    ? user_data_root() / "captures"
                                    : std::filesystem::path(REXCVAR_GET(capture_dir));
    std::filesystem::create_directories(dir);
    capture_thread_ = std::thread([this, every, dir] {
      const auto t0 = std::chrono::steady_clock::now();
      for (;;) {
        std::unique_lock lock(capture_mutex_);
        if (capture_cv_.wait_for(lock, std::chrono::seconds(every), [this] { return stop_capture_.load(); }))
          return;
        const int t = static_cast<int>(
            std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count());
        auto* gpu = runtime()->graphics_system();
        rex::ui::RawImage image;
        if (!gpu || !gpu->presenter() || !gpu->presenter()->CaptureGuestOutput(image)) {
          REXLOG_INFO("haggar: capture at {} s: no guest output yet", t);
          continue;
        }
        auto path = dir / ("frame_" + std::to_string(t) + ".ppm");
        std::ofstream f(path, std::ios::binary);
        f << "P6\n" << image.width << " " << image.height << "\n255\n";
        for (uint32_t y = 0; y < image.height; ++y)
          for (uint32_t x = 0; x < image.width; ++x)
            f.write(reinterpret_cast<const char*>(&image.data[y * image.stride + x * 4]), 3);
        REXLOG_INFO("haggar: capture at {} s: {}x{} -> {}", t, image.width, image.height, path.string());
      }
    });
  }

  void OnShutdown() override {
    stop_capture_ = true;
    capture_cv_.notify_all();
    if (capture_thread_.joinable())
      capture_thread_.join();
  }

 private:
  std::filesystem::path game_root_;
  ScriptedPad* scripted_pad_ = nullptr;
  std::thread capture_thread_;
  std::mutex capture_mutex_;
  std::condition_variable capture_cv_;
  std::atomic<bool> stop_capture_{false};
};
