import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final root = Directory.current;

  test('domain layout remains Flutter-free and inward-only', () {
    final violations = _importsMatching(
      root.directory('lib/domain_layout'),
      const <String>[
        'package:flutter',
        'package:bloc',
        '/business_layout/',
        '/data_layout/',
        '/ui_layout/',
      ],
    );

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('business layout never imports data, UI, or Flutter', () {
    final violations = _importsMatching(
      root.directory('lib/business_layout'),
      const <String>[
        'package:flutter',
        'package:flutter_bloc',
        '/data_layout/',
        '/ui_layout/',
      ],
    );

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('data layout never imports business or UI', () {
    final violations = _importsMatching(
      root.directory('lib/data_layout'),
      const <String>['/business_layout/', '/ui_layout/'],
    );

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('only composition root imports concrete data layout', () {
    final violations = <String>[];
    for (final file in _dartFiles(root.directory('lib/ui_layout'))) {
      final path = file.path.replaceAll('\\', '/');
      if (path.contains('/ui_layout/app/di/')) continue;
      for (final entry in file.readAsLinesSync().indexed) {
        if (entry.$2.startsWith('import ') &&
            entry.$2.contains('/data_layout/')) {
          violations.add('$path:${entry.$1 + 1}: ${entry.$2}');
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('service locator access stays inside composition root', () {
    final violations = <String>[];
    for (final file in _dartFiles(root.directory('lib'))) {
      final path = file.path.replaceAll('\\', '/');
      if (path.contains('/ui_layout/app/di/')) continue;
      for (final entry in file.readAsLinesSync().indexed) {
        final line = entry.$2;
        if (line.contains('package:get_it') ||
            line.contains('GetIt.I') ||
            line.contains('GetIt.instance')) {
          violations.add('$path:${entry.$1 + 1}: $line');
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}

List<String> _importsMatching(Directory directory, List<String> forbidden) {
  final violations = <String>[];
  for (final file in _dartFiles(directory)) {
    for (final entry in file.readAsLinesSync().indexed) {
      final line = entry.$2;
      if (!line.startsWith('import ')) continue;
      for (final token in forbidden) {
        if (line.contains(token)) {
          violations.add('${file.path}:${entry.$1 + 1}: $line');
        }
      }
    }
  }
  return violations;
}

Iterable<File> _dartFiles(Directory directory) sync* {
  if (!directory.existsSync()) return;
  for (final entity in directory.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) yield entity;
  }
}

extension on Directory {
  Directory directory(String relativePath) => Directory('$path/$relativePath');
}
