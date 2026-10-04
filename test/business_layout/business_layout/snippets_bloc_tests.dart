part of '../business_layout_test.dart';

void _registerSnippetsTests() {
  group('SnippetsBloc', () {
    test('filters, creates, updates, and deletes snippets', () async {
      final repository = _SnippetsRepository(<CommandSnippet>[
        CommandSnippet(
          id: 'one',
          title: 'Disk overview',
          command: 'df -h',
          labels: const <String>['diagnostics'],
        ),
        CommandSnippet(id: 'two', title: 'Status', command: 'systemctl'),
      ]);
      final bloc = SnippetsBloc(
        repository,
        idFactory: (prefix) => '$prefix-fixed',
      );
      addTearDown(bloc.close);
      await bloc.stream.firstWhere(
        (state) => state.status == SnippetsStatus.success,
      );

      final filtered = bloc.stream.firstWhere(
        (state) => state.filter == 'DIAG',
      );
      bloc.add(const SnippetsEvent.filterChanged('DIAG'));
      await filtered;
      expect(bloc.state.filteredSnippets.map((item) => item.id), <String>[
        'one',
      ]);
      expect(
        bloc
            .createSnippet(
              title: 'Logs',
              command: 'journalctl',
              description: 'Recent logs',
              labels: const <String>['ops'],
            )
            .id,
        'snippet-fixed',
      );

      final saved = bloc.stream.firstWhere(
        (state) => state.snippets.first.title == 'Disk usage',
      );
      bloc.add(
        SnippetsEvent.snippetSaved(
          repository.items.first.copyWith(title: 'Disk usage'),
        ),
      );
      await saved;
      final deleted = bloc.stream.firstWhere(
        (state) => state.snippets.length == 1,
      );
      bloc.add(const SnippetsEvent.snippetDeleted('one'));
      await deleted;
      expect(bloc.state.snippets.map((item) => item.id), <String>['two']);
    });

    test('reports repository failures without discarding snippets', () async {
      final snippet = CommandSnippet(id: 'one', title: 'One', command: 'true');
      final repository = _SnippetsRepository(<CommandSnippet>[snippet]);
      final bloc = SnippetsBloc(repository);
      addTearDown(bloc.close);
      await bloc.stream.firstWhere(
        (state) => state.status == SnippetsStatus.success,
      );
      repository.failure = const RepositoryFailure('delete', 'cannot delete');

      final failed = bloc.stream.firstWhere(
        (state) => state.status == SnippetsStatus.failure,
      );
      bloc.add(const SnippetsEvent.snippetDeleted('one'));
      await failed;

      expect(bloc.state.errorMessage, 'cannot delete');
      expect(bloc.state.snippets, <CommandSnippet>[snippet]);
    });
  });
}
