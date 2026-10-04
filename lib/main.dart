import 'package:flutter/widgets.dart';
import 'package:surf_terminal/ui_layout/app/app.dart';

import 'package:surf_terminal/ui_layout/app/di/app_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = await AppDependencies.production();
  runApp(SurfTerminalApp(dependencies: dependencies));
}
