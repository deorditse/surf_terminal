import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

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
    Widget button(
      Widget content,
      VoidCallback action, {
      required Key key,
      required String semanticLabel,
      bool selected = false,
    }) => Semantics(
      label: semanticLabel,
      button: true,
      child: CupertinoButton(
        key: key,
        minimumSize: const Size(44, 44),
        padding: const EdgeInsets.symmetric(horizontal: 7),
        onPressed: action,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: 28,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: selected
                ? CupertinoColors.activeBlue.withValues(alpha: 0.30)
                : null,
            borderRadius: BorderRadius.circular(14),
          ),
          child: content,
        ),
      ),
    );
    const symbolStyle = TextStyle(
      color: Color(0xFFE8F7FF),
      fontSize: 13,
      fontWeight: FontWeight.w600,
    );
    const iconColor = Color(0xFFE8F7FF);
    return SizedBox(
      key: const Key('special-key-toolbar'),
      height: 44,
      child: Stack(
        children: [
          Positioned.fill(
            top: 5,
            bottom: 5,
            child: GlassContainer(
              key: const Key('terminal-glass-special-key-controls'),
              useOwnLayer: true,
              quality: GlassQuality.standard,
              shape: const LiquidRoundedSuperellipse(borderRadius: 17),
              padding: EdgeInsets.zero,
              child: const SizedBox.expand(),
            ),
          ),
          ListView(
            scrollDirection: Axis.horizontal,
            children: [
              button(
                const Text('⎋', style: symbolStyle),
                () => onSend('\u001b'),
                key: const Key('terminal-key-escape'),
                semanticLabel: 'Escape',
              ),
              button(
                const Text('↵', style: symbolStyle),
                () => onSend('\r'),
                key: const Key('terminal-key-enter'),
                semanticLabel: 'Enter',
              ),
              button(
                const Text('⌃', style: symbolStyle),
                onControl,
                key: const Key('terminal-key-control'),
                semanticLabel: 'Control',
                selected: control,
              ),
              button(
                const Text('⌥', style: symbolStyle),
                onAlt,
                key: const Key('terminal-key-alt'),
                semanticLabel: 'Option',
                selected: alt,
              ),
              button(
                const Text('C', style: symbolStyle),
                () {
                  if (control) {
                    onSend('\u0003');
                  } else if (alt) {
                    onSend('\u001bc');
                  } else {
                    onSend('c');
                  }
                },
                key: const Key('terminal-key-c'),
                semanticLabel: 'C',
              ),
              button(
                const Text('⇥', style: symbolStyle),
                () => onSend('\t'),
                key: const Key('terminal-key-tab'),
                semanticLabel: 'Tab',
              ),
              button(
                const Icon(
                  CupertinoIcons.doc_on_clipboard,
                  size: 15,
                  color: iconColor,
                ),
                onPaste,
                key: const Key('terminal-key-paste'),
                semanticLabel: 'Paste',
              ),
              button(
                const Text('←', style: symbolStyle),
                () => onSend('\u001b[D'),
                key: const Key('terminal-key-left'),
                semanticLabel: 'Left arrow',
              ),
              button(
                const Text('↓', style: symbolStyle),
                () => onSend('\u001b[B'),
                key: const Key('terminal-key-down'),
                semanticLabel: 'Down arrow',
              ),
              button(
                const Text('↑', style: symbolStyle),
                () => onSend('\u001b[A'),
                key: const Key('terminal-key-up'),
                semanticLabel: 'Up arrow',
              ),
              button(
                const Text('→', style: symbolStyle),
                () => onSend('\u001b[C'),
                key: const Key('terminal-key-right'),
                semanticLabel: 'Right arrow',
              ),
              button(
                const Icon(
                  CupertinoIcons.keyboard_chevron_compact_down,
                  size: 16,
                  color: iconColor,
                ),
                onHideKeyboard,
                key: const Key('terminal-key-hide-keyboard'),
                semanticLabel: 'Hide keyboard',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
