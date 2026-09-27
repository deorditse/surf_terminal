import 'package:surf_terminal/domain_layout/domain_layout.dart';

final class PreviewFixtureSource {
  const PreviewFixtureSource();

  List<SshProfile> profiles() => const <SshProfile>[
    SshProfile(
      id: 'profile-atlas',
      name: 'Atlas Lab',
      host: 'atlas.example.com',
      port: 22,
      username: 'developer',
      label: 'Lab',
    ),
    SshProfile(
      id: 'profile-edge',
      name: 'Edge Sandbox',
      host: '192.0.2.24',
      port: 2222,
      username: 'operator',
      label: 'Sandbox',
    ),
  ];

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

  List<SftpEntry> sftpEntries(String path) => switch (path) {
    '/home/demo' => const <SftpEntry>[
      SftpEntry(name: 'projects', metadata: 'Directory', isDirectory: true),
      SftpEntry(name: 'notes', metadata: 'Directory', isDirectory: true),
      SftpEntry(name: 'README.md', metadata: '1.2 KB', isDirectory: false),
      SftpEntry(name: 'sample.json', metadata: '640 B', isDirectory: false),
    ],
    '/home/demo/projects' => const <SftpEntry>[
      SftpEntry(
        name: 'surf-terminal',
        metadata: 'Directory',
        isDirectory: true,
      ),
      SftpEntry(
        name: 'release-notes.txt',
        metadata: '2.4 KB',
        isDirectory: false,
      ),
    ],
    '/home/demo/notes' => const <SftpEntry>[
      SftpEntry(name: 'operations.md', metadata: '3.1 KB', isDirectory: false),
    ],
    _ => const <SftpEntry>[],
  };
}
