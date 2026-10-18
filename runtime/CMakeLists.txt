# haggar: Project Haggar recompiled with the ReXGlue SDK (third_party/rexglue).
#
# The generated C++ never lives here: tools/recomp_config.py writes the codegen
# manifest into $HAGGAR_BUILD_DIR/recomp (default build/recomp), and the
# haggar_codegen target runs `rexglue codegen` on it, into recomp/generated.
# This file follows the SDK's generated/rexglue.cmake, with that directory
# moved out of the source tree.

cmake_minimum_required(VERSION 3.25)
project(haggar LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(DEFINED ENV{HAGGAR_BUILD_DIR})
    set(_haggar_build "$ENV{HAGGAR_BUILD_DIR}")
else()
    set(_haggar_build "${CMAKE_CURRENT_SOURCE_DIR}/../build")
endif()
set(HAGGAR_RECOMP_DIR "${_haggar_build}/recomp" CACHE PATH
    "Directory holding haggar_manifest.toml (tools/recomp_config.py)")
set(HAGGAR_GENERATED "${HAGGAR_RECOMP_DIR}/generated")
# ON: build against the stand-in from tools/stub_recomp.py (CI, no orig/).
option(HAGGAR_SKIP_CODEGEN "Use the generated directory as it is; don't run rexglue codegen" OFF)
if(NOT HAGGAR_SKIP_CODEGEN AND NOT EXISTS "${HAGGAR_RECOMP_DIR}/haggar_manifest.toml")
    message(FATAL_ERROR "${HAGGAR_RECOMP_DIR}/haggar_manifest.toml not found: run python tools/recomp_config.py")
endif()

# This clone's SDK (third_party/rexglue, installed in place) comes before any
# other ReXGlue registered with CMake.
if(WIN32)
    set(_haggar_sdk_preset win-amd64)
else()
    set(_haggar_sdk_preset linux-amd64)
endif()
set(_haggar_sdk "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/rexglue/out/install/${_haggar_sdk_preset}")
if(EXISTS "${_haggar_sdk}")
    get_filename_component(_haggar_sdk "${_haggar_sdk}" ABSOLUTE)
    list(PREPEND CMAKE_PREFIX_PATH "${_haggar_sdk}")
endif()
find_package(rexglue 0.10.0 REQUIRED CONFIG)

# Guest SEH scopes emit __try/__except, which trap hardware faults only under
# asynchronous EH. Line tables keep the generated code debuggable.
set(HAGGAR_RECOMP_OPTIONS -fasync-exceptions -gline-tables-only)

# The generated list from the last codegen run (configure again after the
# first run so it is picked up). Listing the sources as outputs makes Ninja
# check them after codegen rewrites them.
set(GENERATED_SOURCES "")
if(EXISTS "${HAGGAR_GENERATED}/sources.cmake")
    include("${HAGGAR_GENERATED}/sources.cmake")
endif()

if(HAGGAR_SKIP_CODEGEN)
    add_custom_target(haggar_codegen)
else()
    add_custom_command(
        OUTPUT "${HAGGAR_GENERATED}/codegen.build.stamp" ${GENERATED_SOURCES}
        COMMAND $<TARGET_FILE:rex::rexglue> codegen "${HAGGAR_RECOMP_DIR}/haggar_manifest.toml"
        DEPFILE "${HAGGAR_GENERATED}/codegen.d"
        WORKING_DIRECTORY "${HAGGAR_RECOMP_DIR}"
        COMMENT "Generating recompiled code for haggar"
        VERBATIM)
    add_custom_target(haggar_codegen DEPENDS "${HAGGAR_GENERATED}/codegen.build.stamp")
endif()

if(WIN32)
    add_executable(haggar WIN32 src/main.cpp)
else()
    add_executable(haggar src/main.cpp)
endif()
add_dependencies(haggar haggar_codegen)
target_include_directories(haggar PRIVATE src "${HAGGAR_GENERATED}")
target_link_libraries(haggar PRIVATE rex::runtime)

# haggar_recomp: every generated haggar_recomp.*.cpp.
if(GENERATED_SOURCES)
    add_library(haggar_recomp OBJECT ${GENERATED_SOURCES})
    target_include_directories(haggar_recomp PRIVATE src "${HAGGAR_GENERATED}")
    target_link_libraries(haggar_recomp PRIVATE rex::runtime)
    target_compile_options(haggar_recomp PRIVATE ${HAGGAR_RECOMP_OPTIONS})
    target_precompile_headers(haggar_recomp PRIVATE "${HAGGAR_GENERATED}/haggar_pch.h")
    rexglue_apply_target_settings(haggar_recomp)
    add_dependencies(haggar_recomp haggar_codegen)
    target_link_libraries(haggar PRIVATE haggar_recomp)
endif()

rexglue_configure_target(haggar GPU_PLUGINS xenos)

# On Linux the host finds librexruntime.so through $ORIGIN, as the Windows
# build finds the DLLs it stages; stage the shared libraries the same way.
if(UNIX AND NOT APPLE)
    foreach(_lib rex::runtime rex::TracyClient)
        if(TARGET ${_lib})
            add_custom_command(TARGET haggar POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:${_lib}> $<TARGET_FILE_DIR:haggar>
                VERBATIM)
        endif()
    endforeach()
endif()
