import 'package:surf_terminal/domain_layout/domain_layout.dart';

typedef IdFactory = String Function(String prefix);

String dateTimeIdFactory(String prefix) =>
    '$prefix-${DateTime.now().microsecondsSinceEpoch}';

String repositoryErrorMessage(Object error) => switch (error) {
  RepositoryFailure(:final message) => message,
  _ => error.toString(),
};
