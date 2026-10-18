"""Replaces the symlink stubs git leaves on Windows without symlink rights
(core.symlinks=false: a symlink is checked out as a small text file holding
its target) with copies of their targets, in a repository and all its
submodules. Needed for third_party/rexglue (libmspack, MoltenVK and others
use symlinks); not needed on Linux or with Developer Mode enabled.

    python tools/fix_symlinks.py third_party/rexglue
"""
import argparse
import shutil
import subprocess
import sys
from pathlib import Path


def symlink_paths(repo):
    """Paths git records as symlinks (mode 120000) in `repo`."""
    out = subprocess.run(['git', 'ls-files', '-s'], cwd=repo, capture_output=True, text=True, check=True).stdout
    return [line.split('\t', 1)[1] for line in out.splitlines() if line.startswith('120000 ')]


def fix(repo):
    fixed = missing = 0
    for rel in symlink_paths(repo):
        stub = Path(repo) / rel
        if stub.is_symlink() or not stub.is_file() or stub.stat().st_size > 1024:
            continue  # a real symlink, a directory, or already replaced
        target = (stub.parent / stub.read_text().strip()).resolve()
        if not target.exists():
            missing += 1
            continue
        stub.unlink()
        if target.is_dir():
            shutil.copytree(target, stub)
        else:
            shutil.copy2(target, stub)
        fixed += 1
    return fixed, missing


def main(argv=None):
    ap = argparse.ArgumentParser(description='Replace git symlink stubs with copies of their targets.')
    ap.add_argument('repo')
    args = ap.parse_args(argv)
    repos = [Path(args.repo)]
    subs = subprocess.run(['git', 'submodule', 'foreach', '--quiet', '--recursive', 'echo $displaypath'],
                          cwd=args.repo, capture_output=True, text=True, check=True).stdout.split()
    repos += [Path(args.repo) / s for s in subs]
    total_fixed = total_missing = 0
    for r in repos:
        f, m = fix(r)
        total_fixed += f
        total_missing += m
    print(f'{total_fixed} symlink stubs replaced, {total_missing} with no target (unused on this platform)')


if __name__ == '__main__':
    sys.exit(main())
