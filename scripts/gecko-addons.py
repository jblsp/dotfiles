#!/usr/bin/env python3
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
from urllib.request import urlopen
from zipfile import ZipFile


def validate_id(value):
    if (not isinstance(value, str) or not value or value in ('.', '..')
            or any(c in value for c in '/\\\0\r\n')):
        raise ValueError('Invalid Gecko ID')
    return value


def certificate_id(signature):
    certificates = subprocess.run(
        ['openssl', 'pkcs7', '-inform', 'DER', '-print_certs'],
        input=signature, capture_output=True, check=True).stdout
    ids = []
    for certificate in re.findall(
            rb'-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----',
            certificates, re.DOTALL):
        details = subprocess.run(
            ['openssl', 'x509', '-noout', '-text', '-subject', '-nameopt', 'multiline'],
            input=certificate, capture_output=True, check=True).stdout.decode()
        if re.search(r'CA:TRUE\b', details):
            continue
        subject = details.rsplit('subject=', 1)[-1]
        match = re.search(r'^\s*commonName\s*=\s*(.+)$', subject, re.MULTILINE)
        if match:
            ids.append(validate_id(match[1]))
    if len(ids) != 1:
        raise ValueError('Expected one signing certificate with a Gecko ID')
    return ids[0]


def addon_id(archive):
    with ZipFile(archive) as xpi:
        manifest = json.loads(xpi.read('manifest.json'))
        for key in ('browser_specific_settings', 'applications'):
            value = manifest.get(key, {}).get('gecko', {}).get('id')
            if value is not None:
                return validate_id(value)
        return certificate_id(xpi.read('META-INF/mozilla.rsa'))


def install(addons_file, profile, downloads, browser_name):
    urls = [line.strip() for line in addons_file.read_text().splitlines()
            if line.strip() and not line.lstrip().startswith('#')]
    extensions = profile / 'extensions'
    cache_file = profile / 'dotfiles-addons.json'
    cache = json.loads(cache_file.read_text()) if cache_file.exists() else {}
    pending = []
    for url in urls:
        if url.startswith('moz:'):
            url = f'https://addons.mozilla.org/firefox/downloads/latest/{url[4:]}/latest.xpi'
        known_id = cache.get(url)
        if known_id and (extensions / f'{known_id}.xpi').is_file():
            continue
        if url not in pending:
            pending.append(url)
    if not pending:
        return
    print(f'gecko-addons: Installing {len(pending)} addons for {browser_name} profile {profile.name}', flush=True)
    extensions.mkdir(parents=True, exist_ok=True)
    for url in pending:
        with tempfile.TemporaryDirectory(prefix='.addons-', dir=profile) as stage:
            archive = Path(stage) / 'addon.xpi'
            if url in downloads and downloads[url].is_file():
                shutil.copyfile(downloads[url], archive)
            else:
                with urlopen(url, timeout=60) as response, archive.open('wb') as output:
                    shutil.copyfileobj(response, output)
            try:
                gecko_id = addon_id(archive)
            except (KeyError, ValueError, subprocess.CalledProcessError, OSError) as error:
                raise ValueError(f'Cannot determine Gecko ID for {url}: {error}') from error
            destination = extensions / f'{gecko_id}.xpi'
            if not destination.exists():
                archive.replace(destination)
            downloads[url] = destination
            cache[url] = gecko_id
            staged_cache = Path(stage) / 'cache.json'
            staged_cache.write_text(json.dumps(cache, indent=2) + '\n')
            staged_cache.replace(cache_file)


def main():
    if sys.platform == 'darwin':
        waterfox = Path.home() / 'Library/Application Support/Waterfox'
    elif sys.platform.startswith('linux'):
        waterfox = Path.home() / '.waterfox'
    else:
        return
    root = Path(__file__).resolve().parent.parent
    downloads = {}
    for cache_file in sorted((waterfox / 'profiles').glob('*/dotfiles-addons.json')):
        for url, gecko_id in json.loads(cache_file.read_text()).items():
            archive = cache_file.parent / 'extensions' / f'{validate_id(gecko_id)}.xpi'
            if archive.is_file():
                downloads[url] = archive
    for addons_file in sorted((root / 'config/waterfox/profiles').glob('*/addons.txt')):
        install(addons_file, waterfox / 'profiles' / addons_file.parent.name, downloads, 'Waterfox')


if __name__ == '__main__':
    main()
