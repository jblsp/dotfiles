#!/usr/bin/env python3
import configparser
import sys

MASK = (1 << 64) - 1
K0, K1, K2, K3 = 0xC3A5C85C97CB3127, 0xB492B66FBE98F273, 0x9AE16A3B2F90404F, 0xC949D7C7509E6557


def rotate(value, shift):
    value &= MASK
    return ((value >> shift) | (value << (64 - shift))) & MASK


def mix(value):
    value &= MASK
    return value ^ (value >> 47)


def hash16(u, v):
    mul = 0x9DDFEA08EB382D69
    a = mix(((u & MASK) ^ (v & MASK)) * mul)
    b = mix(((v & MASK) ^ a) * mul)
    return (b * mul) & MASK


def cityhash64(data):
    # CityHash64 v1, as used by Firefox (newer CityHash versions differ).
    n = len(data)

    def load(offset, size=8):
        return int.from_bytes(data[offset:offset + size], 'little')

    def weak(offset, a, b):
        w, x, y, z = (load(offset + i) for i in (0, 8, 16, 24))
        a = (a + w) & MASK
        b = rotate(b + a + z, 21)
        c = a
        a = (a + x + y) & MASK
        return (a + z) & MASK, (b + rotate(a, 44) + c) & MASK

    if n <= 16:
        if n >= 8:
            a, b = load(0), load(n - 8)
            return hash16(a, rotate(b + n, n)) ^ b
        if n >= 4:
            return hash16(n + (load(0, 4) << 3), load(n - 4, 4))
        if n:
            y = data[0] + (data[n >> 1] << 8)
            z = n + (data[n - 1] << 2)
            return (mix((y * K2) ^ (z * K3)) * K2) & MASK
        return K2
    if n <= 32:
        a, b = load(0) * K1, load(8)
        c, d = load(n - 8) * K2, load(n - 16) * K0
        return hash16(rotate(a - b, 43) + rotate(c, 30) + d,
                      a + rotate(b ^ K3, 20) - c + n)
    if n <= 64:
        z = load(24)
        a = load(0) + (n + load(n - 16)) * K0
        b, c = rotate(a + z, 52), rotate(a, 37)
        a += load(8)
        c += rotate(a, 7)
        a += load(16)
        vf, vs = a + z, b + rotate(a, 31) + c
        a, z = load(16) + load(n - 32), load(n - 8)
        b, c = rotate(a + z, 52), rotate(a, 37)
        a += load(n - 24)
        c += rotate(a, 7)
        a += load(n - 16)
        wf, ws = a + z, b + rotate(a, 31) + c
        r = mix((vf + ws) * K2 + (wf + vs) * K0)
        return (mix(r * K0 + vs) * K2) & MASK
    x, y, z = load(0), load(n - 16) ^ K1, load(n - 56) ^ K0
    v, w = weak(n - 64, n, y), weak(n - 32, n * K1, K0)
    z = (z + mix(v[1]) * K1) & MASK
    x, y = rotate(z + x, 39) * K1, rotate(y, 33) * K1
    for offset in range(0, (n - 1) & ~63, 64):
        x = ((rotate(x + y + v[0] + load(offset + 16), 37) * K1) & MASK) ^ w[1]
        y = ((rotate(y + v[1] + load(offset + 48), 42) * K1) & MASK) ^ v[0]
        z = rotate(z ^ w[0], 33)
        v = weak(offset, v[1] * K1, x + w[0])
        w = weak(offset + 32, z + w[1], y)
        z, x = x, z
    return hash16(hash16(v[0], w[0]) + mix(y) * K1 + z, hash16(v[1], w[1]) + x)


def mozilla_install_hash(path):
    return f'{cityhash64(path.encode("utf-16le")):X}'


def store_id(path):
    profiles = configparser.ConfigParser(interpolation=None)
    profiles.read(path)
    for section in profiles.sections():
        profile = profiles[section]
        if section.startswith('Profile') and profile.get('IsRelative') == '1' and profile.get('Path') == 'profiles/joe':
            return profile.get('StoreID', '')
    return ''


if __name__ == '__main__':
    if sys.argv[1:] == ['--test']:
        assert mozilla_install_hash('/Applications/Firefox.app/Contents/MacOS') == '2656FF1E876E9973'
        assert mozilla_install_hash('/usr/lib64/firefox') == '11457493C5A56847'
    elif sys.argv[1:2] == ['--store-id']:
        print(store_id(sys.argv[2]), end='')
    else:
        print(mozilla_install_hash(sys.argv[1]), end='')
