import 'package:flutter/material.dart';
import 'package:jima/src/core/app_setup/diocha_app.dart';
import 'package:jima/src/core/core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  injectDependencies();
  runApp(const JimaApp());
}
