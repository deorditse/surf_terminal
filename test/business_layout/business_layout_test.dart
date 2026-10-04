import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';

part 'business_layout/profiles_bloc_tests.dart';
part 'business_layout/snippets_bloc_tests.dart';
part 'business_layout/terminal_sessions_bloc_tests.dart';
part 'business_layout/settings_bloc_tests.dart';
part 'support/business_layout_test_repositories.dart';

void main() {
  _registerProfilesTests();
  _registerSnippetsTests();
  _registerTerminalSessionsTests();
  _registerSettingsTests();
}
