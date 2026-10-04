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

  test('handwritten feature state uses Bloc rather than Cubit', () {
    final violations = <String>[];
    for (final file in _dartFiles(root.directory('lib'))) {
      if (file.path.endsWith('.freezed.dart')) continue;
      final source = file.readAsStringSync();
      if (source.contains('extends Cubit<') ||
          RegExp(r'class\s+\w*Cubit\b').hasMatch(source)) {
        violations.add(file.path);
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('transport and persistence plugins stay behind data or DI', () {
    const plugins = <String>[
      'package:dartssh2/',
      'package:sqflite/',
      'package:flutter_secure_storage/',
    ];
    final violations = <String>[];
    for (final file in _dartFiles(root.directory('lib'))) {
      final path = file.path.replaceAll('\\', '/');
      if (path.contains('/data_layout/') ||
          path.contains('/ui_layout/app/di/')) {
        continue;
      }
      for (final line in file.readAsLinesSync()) {
        if (plugins.any(line.contains)) {
          violations.add('$path: $line');
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test(
    'production SSH construction requires verification and forbids bypass',
    () {
      final source = root
          .file('lib/data_layout/src/ssh/dartssh_session_factory.dart')
          .readAsStringSync();
      expect(source, contains('verifyHostKey: _verify'));
      expect(source, contains('disableHostkeyVerification: false'));
      expect(source, isNot(contains('disableHostkeyVerification: true')));
    },
  );

  test(
    'serialized workflow and routes contain no credential or transcript fields',
    () {
      final violations = <String>[];
      for (final file in _dartFiles(root.directory('lib/business_layout'))) {
        final path = file.path.replaceAll('\\', '/');
        if (!path.endsWith('_event.dart') && !path.endsWith('_state.dart')) {
          continue;
        }
        final source = file.readAsStringSync();
        for (final pattern in <RegExp>[
          RegExp(r'String\??\s+(password|secret|passphrase)\b'),
          RegExp(r'\b(transcript|terminalOutput)\b'),
        ]) {
          if (pattern.hasMatch(source)) {
            violations.add(path);
          }
        }
      }
      final routes = root
          .file('lib/ui_layout/app/router/app_router.dart')
          .readAsStringSync();
      if (RegExp(
        r'password|secret|passphrase',
        caseSensitive: false,
      ).hasMatch(routes)) {
        violations.add('lib/ui_layout/app/router/app_router.dart');
      }
      expect(violations, isEmpty, reason: violations.join('\n'));
    },
  );
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

  File file(String relativePath) => File('$path/$relativePath');
}
