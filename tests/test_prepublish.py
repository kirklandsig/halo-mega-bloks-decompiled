import prepublish

AT = '@'  # planted addresses are built at run time, so this file doesn't trip the scan itself


def test_scan_flags(tmp_path):
    files = {
        'notes.md': 'built in C:' + '\\Users\\someone\\work\n',
        'mail.txt': f'write to jane.doe{AT}gmail.com\n',
        'other.txt': f'or to jdoe{AT}example.org\n',
        'ok.txt': 'Co-Authored-By: Claude <noreply@anthropic.com>\n?f@A@@QAAXXZ\n',
        'secret.txt': 'owned by zorblax\n',
        'game.xex': 'XEX2',
        'Classes/Actor.uc': 'class Actor extends Object;\n',
        'Classes/HaloPawn.uc': 'class HaloPawn extends UTPawn;\n',
    }
    paths = []
    for name, text in files.items():
        p = tmp_path / name
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(text)
        paths.append(p)
    big = tmp_path / 'big.bin'
    with open(big, 'wb') as f:
        f.truncate(10 * 1024 * 1024 + 1)
    paths.append(big)

    problems = prepublish.scan(paths, ['zorblax'], ignore_patterns=['*.xex', '/orig/'], identical={'actor'})
    text = '\n'.join(problems)
    for expected in ('notes.md: local path', 'mail.txt: email', 'other.txt: email', 'secret.txt: private pattern',
                     'big.bin: over 10 MB', 'game.xex: ignored file type', 'Actor.uc: identical to UDK'):
        assert expected in text, expected
    assert 'ok.txt' not in text and 'HaloPawn.uc' not in text
    assert len(problems) == 7


def test_scan_flags_tracked_ignored_files_and_more_paths(tmp_path):
    a = tmp_path / 'a.h'
    a.write_text('x\n')
    b = tmp_path / 'b.md'
    home, users = '/ho' + 'me/someone/y', 'C:/' + 'Users/someone/x'  # split so this file passes the scan
    b.write_text(f'see {users} and {home} and archive' + '.org/details/x\n')
    problems = prepublish.scan([a, b], [], ignore_patterns=[], identical=set(), ignored_tracked=[a])
    text = '\n'.join(problems)
    assert 'a.h: tracked but ignored' in text
    assert 'b.md: local path' in text
    assert 'b.md: download source' in text
