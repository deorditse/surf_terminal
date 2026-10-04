import 'package:surf_terminal/domain_layout/domain_layout.dart';

final class PreviewFixtureSource {
  const PreviewFixtureSource();

  List<CommandSnippet> snippets() => <CommandSnippet>[
    CommandSnippet(
      id: 'snippet-status',
      title: 'Service status',
      command: 'systemctl --no-pager --failed',
      description: 'Show failed services without opening a pager.',
      labels: const <String>['ops', 'safe'],
    ),
    CommandSnippet(
      id: 'snippet-disk',
      title: 'Disk overview',
      command: 'df -hT',
      labels: const <String>['diagnostics'],
    ),
  ];

  TerminalPreferences preferences() => const TerminalPreferences();
}
