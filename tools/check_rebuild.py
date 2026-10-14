#!/usr/bin/env python3
"""Check the rebuild against the supplied ZIP without requiring Flutter.

This is source-level regression checking, not a pixel/golden test or analyzer.
Run from any directory: python3 tools/check_rebuild.py
"""
from collections import Counter
from pathlib import Path
import re
import zipfile

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / 'three_bhai_alpha'
TOKEN = re.compile(
    r'''//[^\n]*|/\*.*?\*/|'(?:\\.|[^'\\])*'|"(?:\\.|[^"\\])*"|\b0x[0-9a-fA-F]+\b|\b\d+(?:\.\d+)?\b''',
    re.DOTALL,
)


def literals(source):
    """Compare UI strings/numbers, ignoring comments, imports and formatting."""
    source = re.sub(r'^import .*?;\s*', '', source, flags=re.MULTILINE)
    return Counter(token for token in TOKEN.findall(source)
                   if not token.startswith(('//', '/*')))


def relocated(old):
    name = Path(old).name
    if '/presentation/pages/' in old:
        return 'lib/screens/' + name
    if '/presentation/widgets/' in old:
        return 'lib/widgets/' + name
    return old


def check():
    errors = []
    checked_ui = checked_assets = checked_data = 0
    with zipfile.ZipFile(ROOT / 'three_bhai_alpha_lite.zip') as archive:
        for entry in archive.namelist():
            old = entry.removeprefix('three_bhai_alpha/')
            is_ui = (old.endswith('.dart') and
                     any(part in old for part in (
                         '/presentation/pages/', '/presentation/widgets/',
                         '/core/theme/', '/core/widgets/')))
            if is_ui:
                new = APP / relocated(old)
                original = literals(archive.read(entry).decode())
                rebuilt = literals(new.read_text())
                if original != rebuilt:
                    errors.append(f'UI literals changed: {new.relative_to(APP)}\n'
                                  f'  removed: {original - rebuilt}\n'
                                  f'  added: {rebuilt - original}')
                checked_ui += 1
            if old.startswith(('assets/', 'android/')):
                new = APP / old
                if not new.exists() or new.read_bytes() != archive.read(entry):
                    errors.append(f'Original asset/platform file changed: {old}')
                checked_assets += 1
            if old.endswith(('mock_recipes.dart', 'mock_ingredient_repository.dart')):
                folder = 'data' if old.endswith('mock_recipes.dart') else 'repositories'
                new = APP / 'lib' / folder / Path(old).name
                if literals(archive.read(entry).decode()) != literals(new.read_text()):
                    errors.append(f'Sample data changed: {new.relative_to(APP)}')
                checked_data += 1

    dart_files = sorted([*APP.glob('lib/**/*.dart'), *APP.glob('test/**/*.dart')])
    for file in dart_files:
        source = file.read_text()
        for dependency in re.findall(r"(?:import|export) ['\"]([^'\"]+)['\"]", source):
            if dependency.startswith('package:three_bhai/'):
                target = APP / 'lib' / dependency.removeprefix('package:three_bhai/')
            elif ':' not in dependency:
                target = file.parent / dependency
            else:
                continue
            if not target.exists():
                errors.append(f'Missing import: {file.relative_to(APP)} -> {dependency}')
        if re.search(r'flutter_bloc|equatable|\bBloc(?:Builder|Consumer|Provider)\b|\bCubit\b', source):
            errors.append(f'Old state-management dependency remains: {file.relative_to(APP)}')

    if errors:
        raise SystemExit('\n'.join(errors))
    print(f'PASS: original strings/numbers retained in {checked_ui} UI files')
    print(f'PASS: {checked_assets} asset/platform files retained byte-for-byte')
    print(f'PASS: {checked_data} ingredient/recipe sample-data files retained')
    print(f'PASS: local imports resolve in {len(dart_files)} Dart files; no BLoC/Equatable references')
    print('Note: run flutter analyze and flutter test for type/runtime validation.')


if __name__ == '__main__':
    check()
