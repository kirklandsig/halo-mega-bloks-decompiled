import struct

import pytest

import paths
import switch_tables as st

BASE = 0x82000000


def asm(*words):
    return b''.join(struct.pack('>I', w) for w in words)


# encoders for the few instructions the tests need
def cmplwi(cr, ra, imm): return (10 << 26) | (cr << 23) | (ra << 16) | imm
def bgt(cr, rel): return (16 << 26) | (12 << 21) | ((cr * 4 + 1) << 16) | (rel & 0xFFFC)
def lis(rd, imm): return (15 << 26) | (rd << 21) | (imm & 0xFFFF)
def addi(rd, ra, imm): return (14 << 26) | (rd << 21) | (ra << 16) | (imm & 0xFFFF)
def slwi(ra, rs, n): return (21 << 26) | (rs << 21) | (ra << 16) | (n << 11) | (0 << 6) | ((31 - n) << 1)
def lwzx(rd, ra, rb): return (31 << 26) | (rd << 21) | (ra << 16) | (rb << 11) | (23 << 1)
def lwz(rd, d, ra): return (32 << 26) | (rd << 21) | (ra << 16) | (d & 0xFFFF)
def mtctr(rs): return (31 << 26) | (rs << 21) | (9 << 16) | (467 << 1)
BCTR = 0x4E800420
BLR = 0x4E800020


def build(order, n=4, table_off=0x100, labels=None, func_size=0x200):
    """A function at BASE with a switch on r11; the table at BASE + table_off."""
    table = BASE + table_off
    hi, lo = (table + 0x8000) >> 16, table & 0xFFFF
    head = [cmplwi(6, 11, n - 1), None]
    if order == 'slwi':
        body = [lis(12, hi), slwi(11, 11, 2), addi(12, 12, lo), lwzx(0, 12, 11), mtctr(0), BCTR]
    else:
        body = [lis(12, hi), addi(12, 12, lo), slwi(0, 11, 2), lwzx(0, 12, 0), mtctr(0), BCTR]
    code = head + body
    default = BASE + 4 * len(code)
    code[1] = bgt(6, default - (BASE + 4))
    code += [BLR] * ((table_off - 4 * len(code)) // 4)
    labels = labels or [default + 4 * (i % 4) for i in range(n)]
    image = asm(*code) + asm(*labels)
    image += bytes(func_size - len(image))
    return image, default, labels


def test_slwi_absolute_table():
    image, default, labels = build('slwi')
    found = st.find(image, [(BASE, 0x200)])
    assert len(found) == 1
    s = found[0]
    assert s.r == 11 and s.default == default and s.labels == labels
    assert s.base == BASE + 4 * 7


def test_upstream_order_still_found():
    image, default, labels = build('upstream')
    found = st.find(image, [(BASE, 0x200)])
    assert [(s.r, s.default, s.labels) for s in found] == [(11, default, labels)]


def test_function_pointer_bctr_rejected():
    image = asm(lwz(11, 0, 3), mtctr(11), BCTR) + bytes(0x10)
    assert st.find(image, [(BASE, 0x1C)]) == []


def test_label_outside_function_rejected():
    image, default, labels = build('slwi', labels=[BASE + 0x40, BASE + 0x44, BASE + 0x48, BASE + 0x1000])
    assert st.find(image, [(BASE, 0x200)]) == []


def test_render():
    s = st.Switch(base=0x82000010, r=11, default=0x82000040, labels=[0x82000044, 0x82000048])
    text = st.render([s])
    assert '[[switch_tables]]' in text
    assert 'address = 0x82000010' in text
    assert 'register = 11' in text
    assert 'labels = [0x82000044, 0x82000048]' in text


@pytest.mark.orig
def test_every_bctr_classified():
    if not paths.basefile().exists():
        pytest.skip(f'{paths.basefile()} not present')
    image = paths.basefile().read_bytes()
    counts = st.survey(image, st.functions())
    assert counts['unexplained'] == 0
    assert counts['table'] >= 300
