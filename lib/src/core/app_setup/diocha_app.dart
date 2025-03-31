import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/core/dependency_injection/ui_container.dart';
import 'package:jima/src/core/navigation/router.dart';
import 'package:jima/src/core/theme/app_theme.dart';

class JimaApp extends StatelessWidget {
  const JimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GeneralUiIOCContainer(
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp.router(
            title: 'JIMA',
            theme: AppTheme.light,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.config,
          );
        },
      ),
    );
  }
}
