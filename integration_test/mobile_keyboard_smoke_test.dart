import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/app/di/terminal_runtime_registry.dart';
import 'package:surf_terminal/ui_layout/pages/terminal/widgets/session_pane.dart';

import 'support/mobile_keyboard_fakes.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'mobile software keyboard drives the connected terminal',
    (tester) => _runAndroidKeyboardSmoke(tester),
    skip: !Platform.isAndroid,
    timeout: const Timeout(Duration(minutes: 3)),
  );
}

Future<void> _runAndroidKeyboardSmoke(WidgetTester tester) async {
  final session = InjectedSshSession();
  final registry = TerminalRuntimeRegistry(
    factory: InjectedSessionFactory(session),
    knownHosts: InjectedKnownHosts(),
    credentials: InjectedCredentialStore(),
  );
  final runtime = registry.open(injectedProfile);

  try {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: SessionPane(
            runtime: runtime,
            preferences: const TerminalPreferences(),
          ),
        ),
      ),
    );
    await _pumpUntil(tester, () => runtime.bloc.state is SshSessionConnected);
    await _pumpUntil(tester, () => session.resizes.isNotEmpty);

    expect(_keyboardInset(tester), 0, reason: 'keyboard starts closed');
    final dimensionsBeforeKeyboard = session.resizes.last;

    await tester.tap(find.byKey(const Key('terminal-viewport')));
    await tester.pump();
    expect(runtime.focusNode.hasFocus, isTrue, reason: 'tap focuses terminal');
    await _pumpUntil(tester, () => _keyboardInset(tester) > 0);
    await _enterPlatformText(tester, 'ios');
    await _pumpUntil(
      tester,
      () => utf8
          .decode(session.sent.expand((bytes) => bytes).toList())
          .contains('ios'),
    );
    expect(_keyboardInset(tester), greaterThan(0));
    await _pumpUntil(
      tester,
      () => session.resizes.any(
        (dimensions) => dimensions != dimensionsBeforeKeyboard,
      ),
    );

    await tester.tap(find.text('Ctrl'));
    await tester.pump();
    await tester.tap(find.text('C'));
    await tester.pump();
    expect(session.sent.last, <int>[3]);
    expect(runtime.focusNode.hasFocus, isTrue);
    expect(_keyboardInset(tester), greaterThan(0));

    await tester.scrollUntilVisible(
      find.text('Hide keyboard'),
      300,
      scrollable: find.descendant(
        of: find.byKey(const Key('special-key-toolbar')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.text('Hide keyboard'));
    await _pumpUntil(tester, () => _keyboardInset(tester) == 0);
    expect(runtime.focusNode.hasFocus, isFalse);

    await tester.tap(find.byKey(const Key('terminal-viewport')));
    await _pumpUntil(tester, () => _keyboardInset(tester) > 0);
    expect(runtime.focusNode.hasFocus, isTrue);
  } finally {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await registry.dispose();
  }
}

double _keyboardInset(WidgetTester tester) {
  final context = tester.element(find.byKey(const Key('terminal-viewport')));
  return View.of(context).viewInsets.bottom;
}

Future<void> _enterPlatformText(WidgetTester tester, String text) async {
  final editingText = '  $text';
  final message = SystemChannels.textInput.codec.encodeMethodCall(
    MethodCall('TextInputClient.updateEditingState', [
      1,
      <String, Object>{
        'text': editingText,
        'selectionBase': editingText.length,
        'selectionExtent': editingText.length,
        'composingBase': -1,
        'composingExtent': -1,
      },
    ]),
  );
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    SystemChannels.textInput.name,
    message,
    (_) {},
  );
  await tester.pump();
}

Future<void> _pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 15),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition() && DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(condition(), isTrue);
}
