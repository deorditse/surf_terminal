import 'package:flutter/material.dart';

class SpecialKeys extends StatelessWidget {
  const SpecialKeys({
    required this.control,
    required this.alt,
    required this.onControl,
    required this.onAlt,
    required this.onSend,
    required this.onPaste,
    required this.onHideKeyboard,
    super.key,
  });

  final bool control;
  final bool alt;
  final VoidCallback onControl;
  final VoidCallback onAlt;
  final ValueChanged<String> onSend;
  final VoidCallback onPaste;
  final VoidCallback onHideKeyboard;

  @override
  Widget build(BuildContext context) {
    Widget button(String label, VoidCallback action, {bool selected = false}) =>
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: selected
              ? FilledButton.tonal(onPressed: action, child: Text(label))
              : OutlinedButton(onPressed: action, child: Text(label)),
        );
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SizedBox(
        height: 64,
        child: ListView(
          key: const Key('special-key-toolbar'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          scrollDirection: Axis.horizontal,
          children: [
            button('Esc', () => onSend('\u001b')),
            button('Ctrl', onControl, selected: control),
            button('Alt', onAlt, selected: alt),
            button('C', () {
              if (control) {
                onSend('\u0003');
              } else if (alt) {
                onSend('\u001bc');
              } else {
                onSend('c');
              }
            }),
            button('Tab', () => onSend('\t')),
            button('Paste', onPaste),
            button('←', () => onSend('\u001b[D')),
            button('↓', () => onSend('\u001b[B')),
            button('↑', () => onSend('\u001b[A')),
            button('→', () => onSend('\u001b[C')),
            button('Hide keyboard', onHideKeyboard),
          ],
        ),
      ),
    );
  }
}
