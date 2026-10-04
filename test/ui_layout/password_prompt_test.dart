import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/ui_layout/pages/connections/dialogs/password_prompt.dart';

void main() {
  testWidgets(
    'keeps password controller alive through dialog reverse animation',
    (tester) async {
      bool? accepted;
      String? submittedPassword;
      bool? submittedRemember;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                showPasswordPrompt(
                  context,
                  endpoint: 'alice@example.test:22',
                  onSubmit: (password, remember) {
                    submittedPassword = password;
                    submittedRemember = remember;
                  },
                ).then((value) => accepted = value);
              },
              child: const Text('Open prompt'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open prompt'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<CheckboxListTile>(
          find.byKey(const Key('retain-transient-password')),
        ).value,
        isTrue,
      );
      await tester.enterText(
        find.byKey(const Key('transient-password')),
        'runtime-secret',
      );
      await tester.pump();
      await tester.tap(find.text('Connect'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(accepted, isTrue);
      expect(submittedPassword, 'runtime-secret');
      expect(submittedRemember, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
}
