"""Checks the files that would be published for leaks, before anything is
pushed.

    python tools/prepublish.py

Scans `git ls-files` and exits 1 if it finds any of:
- a local user path: a Windows Users folder (either slash), a Unix home
  folder, or a WSL mount of one (this file's own text avoids the forms)
- a pointer to a download source for the game, the SDK or UDK
- an email address that isn't a no-reply address
- a regex from local/prepublish_patterns.txt (git-ignored, one per line:
  the maintainer's username and similar, never written into a tracked file)
- a file over 10 MB (config/functions.csv may be up to 50 MB)
- a file of a type .gitignore excludes (*.xex, *.pdb, ...), or any tracked
  file that .gitignore would exclude (git ls-files -ci --exclude-standard)
- a .uc file whose class config/script_classes.csv marks as identical to UDK's
"""
import csv
import fnmatch
import re
import subprocess
import sys
from pathlib import Path

import paths

LOCAL_PATH = re.compile(r'[A-Za-z]:(?:\\{1,2}|/)Users[\\/]|/home/\w|/mnt/[a-z]/Users/', re.I)
DOWNLOAD_SOURCE = re.compile(r'archive\.org|xdk_\d{8}|udk[i]nstall|xdks[e]tupxenon', re.I)  # [x]: no self-match
EMAIL = re.compile(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}')
MAX_SIZE = 10 * 1024 * 1024
SIZE_ALLOWANCE = {'config/functions.csv': 50 * 1024 * 1024}
PATTERNS_FILE = paths.ROOT / 'local' / 'prepublish_patterns.txt'


def gitignore_types(path=paths.ROOT / '.gitignore'):
    """The `*.ext`-style patterns of a .gitignore."""
    return [line.strip() for line in Path(path).read_text().splitlines() if line.strip().startswith('*')]


def identical_classes(path=paths.CONFIG / 'script_classes.csv'):
    if not Path(path).exists():
        return set()
    with open(path, newline='', encoding='utf-8') as f:
        return {r['class'].lower() for r in csv.DictReader(f) if r['status'] == 'identical'}


def scan(tree_files, private_patterns, ignore_patterns=None, identical=None, root=paths.ROOT, ignored_tracked=()):
    """Problems found in `tree_files`, one line each. `ignored_tracked` are
    tracked files that .gitignore excludes."""
    ignored_tracked = {Path(p).resolve() for p in ignored_tracked}
    ignore_patterns = gitignore_types() if ignore_patterns is None else ignore_patterns
    identical = identical_classes() if identical is None else identical
    private = [re.compile(p, re.I) for p in private_patterns]
    problems = []
    for path in map(Path, tree_files):
        try:
            rel = path.resolve().relative_to(Path(root).resolve()).as_posix()
        except ValueError:
            rel = path.as_posix()
        size = path.stat().st_size
        if size > SIZE_ALLOWANCE.get(rel, MAX_SIZE):
            problems.append(f'{rel}: over {SIZE_ALLOWANCE.get(rel, MAX_SIZE) // (1024 * 1024)} MB ({size} bytes)')
        if any(fnmatch.fnmatch(path.name.lower(), p.lower()) for p in ignore_patterns if p.startswith('*')):
            problems.append(f'{rel}: ignored file type')
        if path.resolve() in ignored_tracked:
            problems.append(f'{rel}: tracked but ignored')
        if any(p.search(rel) for p in private):
            problems.append(f'{rel}: private pattern in the file name')
        if path.suffix.lower() == '.uc' and path.stem.lower() in identical:
            problems.append(f'{rel}: identical to UDK, should not be published')
        text = path.read_bytes().decode('utf-8', errors='replace')
        if LOCAL_PATH.search(text):
            problems.append(f'{rel}: local path')
        if DOWNLOAD_SOURCE.search(text):
            problems.append(f'{rel}: download source')
        bad = sorted({m for m in EMAIL.findall(text) if 'noreply' not in m.lower()})
        if bad:
            problems.append(f'{rel}: email address ({len(bad)})')
        for p in private:
            if p.search(text):
                problems.append(f'{rel}: private pattern')
                break
    return problems


def main(argv=None):
    if not PATTERNS_FILE.exists():
        print(f'missing input: {PATTERNS_FILE}', file=sys.stderr)
        return 2
    patterns = [line.strip() for line in PATTERNS_FILE.read_text().splitlines() if line.strip()]
    files = subprocess.run(['git', 'ls-files', '-z'], cwd=paths.ROOT, capture_output=True, check=True).stdout
    tree = [paths.ROOT / f for f in files.decode('utf-8').split('\0') if f]
    ignored = subprocess.run(['git', 'ls-files', '-z', '-ci', '--exclude-standard'], cwd=paths.ROOT,
                             capture_output=True, check=True).stdout
    problems = scan(tree, patterns, ignored_tracked=[paths.ROOT / f for f in ignored.decode('utf-8').split('\0') if f])
    for p in problems:
        print(p)
    print(f'{len(tree)} files, {len(problems)} problems')
    return 1 if problems else 0


if __name__ == '__main__':
    sys.exit(main())
