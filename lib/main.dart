import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jima/src/core/app_setup/diocha_app.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/supabase_infra/supabase_api.dart';
import 'package:jima/src/tools/tools_barrel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  injectDependencies();
  runApp(const JimaApp());
}

Future<void> setupInfra() async {
  await dotenv.load(fileName: 'assets/env/.env');

  await SupabaseApi.initialize(
    url: dotenv.get('URL'),
    anonKey: dotenv.get('ANONKEY'),
  );

  await Hive.initFlutter();
  await Hive.openBox<Map>(StorageAccess.user);
}
