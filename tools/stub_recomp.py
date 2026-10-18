"""Writes a stand-in for the generated code into $HAGGAR_BUILD_DIR/recomp/
generated/ (default build/recomp/generated/): an image description with no
functions. With it, runtime/ builds without orig/ or the codegen, so CI can
catch host and Linux build breakage. The result links but doesn't run a game.

    python tools/stub_recomp.py
    cmake -S runtime -B build/runtime -DHAGGAR_SKIP_CODEGEN=ON ...
"""
import argparse

import paths

PCH = '''// Stand-in for the generated haggar_pch.h (tools/stub_recomp.py).
#pragma once
#include <rex/ppc.h>
#include <rex/image_info.h>
#include <rex/logging.h>

#define REX_IMAGE_BASE 0x82000000ull
#define REX_IMAGE_SIZE 0x24C0000ull
#define REX_CODE_BASE 0x82410000ull
#define REX_CODE_SIZE 0x1EEA1ECull
#define REXCRT_HEAP 0

extern const rex::PPCImageInfo PPCImageConfig;
extern PPCFuncMapping PPCFuncMappings[];
'''
INIT_H = '''// Stand-in for the generated haggar_init.h (tools/stub_recomp.py).
#pragma once
#include "haggar_pch.h"
'''
INIT_CPP = '''// Stand-in for the generated haggar_init.cpp (tools/stub_recomp.py): no functions.
#include "haggar_init.h"

PPCFuncMapping PPCFuncMappings[] = {
    {0, nullptr},
};

const rex::PPCImageInfo PPCImageConfig = {
    .code_base = REX_CODE_BASE,
    .code_size = REX_CODE_SIZE,
    .image_base = REX_IMAGE_BASE,
    .image_size = REX_IMAGE_SIZE,
    .func_mappings = PPCFuncMappings,
    .rexcrt_heap = REXCRT_HEAP,
};
'''
SOURCES = '''# Stand-in for the generated sources.cmake (tools/stub_recomp.py).
set(GENERATED_SOURCES
    ${CMAKE_CURRENT_LIST_DIR}/haggar_init.cpp
)
'''
FILES = {'haggar_pch.h': PCH, 'haggar_init.h': INIT_H, 'haggar_init.cpp': INIT_CPP, 'sources.cmake': SOURCES}


def write(out):
    out.mkdir(parents=True, exist_ok=True)
    for name, text in FILES.items():
        (out / name).write_text(text, encoding='utf-8', newline='\n')
    return sorted(FILES)


def main(argv=None):
    ap = argparse.ArgumentParser(description='Write a stand-in for the generated code.')
    ap.add_argument('-o', '--out', default=str(paths.BUILD / 'recomp' / 'generated'))
    args = ap.parse_args(argv)
    names = write(paths.Path(args.out))
    print(f'wrote {args.out}: {", ".join(names)}')


if __name__ == '__main__':
    main()
