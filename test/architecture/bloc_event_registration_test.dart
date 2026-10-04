import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('feature blocs register concrete event subtypes separately', () {
    final violations = <String>[];
    final directory = Directory('lib/business_layout');

    for (final entity in directory.listSync(recursive: true)) {
      if (entity is! File ||
          !entity.path.endsWith('_bloc.dart') ||
          entity.path.endsWith('.freezed.dart')) {
        continue;
      }
      final source = entity.readAsStringSync();
      if (RegExp(r'on<\w+Event>\s*\(').hasMatch(source)) {
        violations.add('${entity.path}: parent event registration');
      }
      if (RegExp(r'switch\s*\(\s*event\s*\)').hasMatch(source)) {
        violations.add('${entity.path}: switch-based event dispatcher');
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
