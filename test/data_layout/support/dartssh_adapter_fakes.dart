import 'dart:async';

import 'package:surf_terminal/data_layout/data_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

Future<bool> futureStaysPending(Future<Object?> future) async {
  final marker = Object();
  return identical(
    await Future.any<Object?>(<Future<Object?>>[
      future,
      Future<Object?>.delayed(const Duration(milliseconds: 20), () => marker),
    ]),
    marker,
  );
}

final class FakeCredentialStore implements SecureCredentialStore {
  var readCount = 0;
  @override
  Future<String?> read(CredentialReference reference) async {
    readCount++;
    return 'fictional-auth-value';
  }

  @override
  Future<bool> contains(CredentialReference reference) async => true;
  @override
  Future<void> delete(CredentialReference reference) async {}
  @override
  Future<void> write(CredentialReference reference, String secret) async {}
}

final class FakeSshBackend implements DartSshBackend {
  final _connected = Completer<void>();
  final client = FakeClient(FakeShell());
  DartSshConnectRequest? request;
  Future<void> get connected => _connected.future;

  @override
  Future<DartSshClientHandle> connect(DartSshConnectRequest value) async {
    request = value;
    client.password = value.requestPassword;
    _connected.complete();
    return client;
  }
}

final class FakeClient implements DartSshClientHandle {
  FakeClient(this.shell);
  final FakeShell shell;
  Future<String?> Function()? password;
  TerminalDimensions? openedDimensions;
  var closeCount = 0;

  @override
  Future<DartSshShellHandle> openShell(TerminalDimensions dimensions) async {
    openedDimensions = dimensions;
    await password!();
    return shell;
  }

  @override
  Future<void> get done => Completer<void>().future;
  @override
  Future<void> close() async => closeCount++;
}

final class FakeShell implements DartSshShellHandle {
  final stdout = StreamController<List<int>>();
  final stderr = StreamController<List<int>>();
  final writes = <List<int>>[];
  final resizes = <TerminalDimensions>[];
  var closeCount = 0;
  @override
  Stream<List<int>> get output => stdout.stream;
  @override
  Stream<List<int>> get errorOutput => stderr.stream;
  @override
  Future<void> get done => Completer<void>().future;
  @override
  int? get exitCode => null;
  @override
  Future<void> write(List<int> bytes) async => writes.add(List<int>.of(bytes));
  @override
  Future<void> resize(TerminalDimensions dimensions) async =>
      resizes.add(dimensions);
  @override
  Future<void> close() async {
    closeCount++;
    await stdout.close();
    await stderr.close();
  }
}
