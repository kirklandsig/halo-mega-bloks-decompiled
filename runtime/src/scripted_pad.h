// A scripted controller for unattended runs (--press, see haggar_app.h): it
// holds buttons or the left stick during given windows of seconds after the
// guest starts, so a test can get past the press-A screen and walk without a
// person at the pad.
//
//   --press="A@40,A@45,LS_UP@60-70"   A at 40 s and 45 s (0.3 s each), then
//                                      the left stick up from 60 s to 70 s

#pragma once

#include <chrono>
#include <cstring>
#include <mutex>
#include <sstream>
#include <string>
#include <vector>

#include <rex/input/input.h>
#include <rex/input/input_driver.h>

class ScriptedPad final : public rex::input::InputDriver {
  using X_STATUS = rex::X_STATUS;
  using X_RESULT = rex::X_RESULT;

 public:
  struct Step {
    uint16_t buttons = 0;
    int16_t ly = 0, lx = 0;
    double start = 0, end = 0;
  };

  ScriptedPad(rex::ui::Window* window, std::vector<Step> steps)
      : InputDriver(window, 0), steps_(std::move(steps)), t0_(std::chrono::steady_clock::now()) {}

  // "NAME@start" or "NAME@start-end", comma-separated.
  static std::vector<Step> Parse(const std::string& text) {
    std::vector<Step> out;
    std::stringstream ss(text);
    std::string item;
    while (std::getline(ss, item, ',')) {
      auto at = item.find('@');
      if (at == std::string::npos)
        continue;
      std::string name = item.substr(0, at), when = item.substr(at + 1);
      Step s;
      auto dash = when.find('-');
      s.start = std::stod(when.substr(0, dash));
      s.end = dash == std::string::npos ? s.start + 0.3 : std::stod(when.substr(dash + 1));
      static const struct { const char* name; uint16_t bit; } kButtons[] = {
          {"UP", 0x0001}, {"DOWN", 0x0002}, {"LEFT", 0x0004}, {"RIGHT", 0x0008},
          {"START", 0x0010}, {"BACK", 0x0020}, {"LB", 0x0100}, {"RB", 0x0200},
          {"A", 0x1000}, {"B", 0x2000}, {"X", 0x4000}, {"Y", 0x8000}};
      for (const auto& b : kButtons)
        if (name == b.name)
          s.buttons = b.bit;
      if (name == "LS_UP") s.ly = 32767;
      if (name == "LS_DOWN") s.ly = -32767;
      if (name == "LS_LEFT") s.lx = -32767;
      if (name == "LS_RIGHT") s.lx = 32767;
      out.push_back(s);
    }
    return out;
  }

  X_STATUS Setup() override { return X_STATUS_SUCCESS; }

  void EnumerateDevices(std::vector<rex::input::DeviceInfo>& out) override {
    rex::input::DeviceInfo info;
    info.id = kDevice;
    info.name = "Scripted pad";
    out.push_back(info);
  }

  X_RESULT GetDeviceCapabilities(rex::input::DeviceId id, uint32_t, rex::input::X_INPUT_CAPABILITIES* caps) override {
    if (id != kDevice)
      return X_ERROR_DEVICE_NOT_CONNECTED;
    if (caps) {
      std::memset(caps, 0, sizeof(*caps));
      caps->type = 0x01;
      caps->sub_type = 0x01;
      caps->gamepad.buttons = 0xFFFF;
      caps->gamepad.left_trigger = caps->gamepad.right_trigger = 0xFF;
      caps->gamepad.thumb_lx = caps->gamepad.thumb_ly = static_cast<int16_t>(0x7FFF);
      caps->gamepad.thumb_rx = caps->gamepad.thumb_ry = static_cast<int16_t>(0x7FFF);
    }
    return X_ERROR_SUCCESS;
  }

  X_RESULT GetDeviceState(rex::input::DeviceId id, rex::input::X_INPUT_STATE* state) override {
    if (id != kDevice)
      return X_ERROR_DEVICE_NOT_CONNECTED;
    const double t = std::chrono::duration<double>(std::chrono::steady_clock::now() - t0_).count();
    uint16_t buttons = 0;
    int16_t lx = 0, ly = 0;
    for (const auto& s : steps_) {
      if (t >= s.start && t < s.end) {
        buttons |= s.buttons;
        lx = s.lx ? s.lx : lx;
        ly = s.ly ? s.ly : ly;
      }
    }
    std::lock_guard lock(mutex_);
    if (buttons != last_buttons_ || lx != last_lx_ || ly != last_ly_) {
      ++packet_;
      last_buttons_ = buttons, last_lx_ = lx, last_ly_ = ly;
    }
    if (state) {
      std::memset(state, 0, sizeof(*state));
      state->packet_number = packet_;
      state->gamepad.buttons = buttons;
      state->gamepad.thumb_lx = lx;
      state->gamepad.thumb_ly = ly;
    }
    return X_ERROR_SUCCESS;
  }

  X_RESULT SetDeviceVibration(rex::input::DeviceId id, rex::input::X_INPUT_VIBRATION*) override {
    return id == kDevice ? X_ERROR_SUCCESS : X_ERROR_DEVICE_NOT_CONNECTED;
  }

  X_RESULT GetDeviceKeystroke(rex::input::DeviceId id, uint32_t, rex::input::X_INPUT_KEYSTROKE*) override {
    return id == kDevice ? X_ERROR_EMPTY : X_ERROR_DEVICE_NOT_CONNECTED;
  }

  // The guest's clock for the script starts when it starts running.
  void Restart() { t0_ = std::chrono::steady_clock::now(); }

 private:
  static constexpr rex::input::DeviceId kDevice = static_cast<rex::input::DeviceId>(0x48414747);  // 'HAGG'
  std::vector<Step> steps_;
  std::chrono::steady_clock::time_point t0_;
  std::mutex mutex_;
  uint32_t packet_ = 1;
  uint16_t last_buttons_ = 0;
  int16_t last_lx_ = 0, last_ly_ = 0;
};
