import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/core/supabase_infra/auth_service.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Admin',
          style: Textstyles.extraBold.copyWith(
            fontSize: 14.sp,
            color: AppColors.blackVoid,
          ),
        ),
      ),
      body: Column(
        children: [
          23.boxHeight,
          ...[
            ('Upload Video', Vectors.videos, AppRoute.uploadVideo),
            ('Upload Audio', Vectors.audios, AppRoute.uploadAudio),
            ('Upload Books', Vectors.books, AppRoute.uploadBook),
          ].map(
            (e) {
              return InkWell(
                onTap: () => context.goNamed(e.$3.name),
                child: Padding(
                  padding: REdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Row(
                    children: [
                      e.$2.vectorAssetWidget(
                        dimension: 32.sp,
                      ),
                      20.boxWidth,
                      Text(
                        e.$1,
                        style: Textstyles.normal.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.black600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          54.boxHeight,
          RawMaterialButton(
            onPressed: () async {
              await container<SupabaseAuthService>().signOut();
              if (!context.mounted) return;
              context.goNamed(AppRoute.authAction.name);
            },
            shape: RoundedRectangleBorder(
              borderRadius: 8.circularBorder,
              side: BorderSide(color: AppColors.bleakRedColor, width: 1.sp),
            ),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            padding: EdgeInsets.zero,
            child: Padding(
              padding: REdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Vectors.logout.vectorAssetWidget(),
                  10.boxWidth,
                  Text(
                    'Logout',
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 14.sp,
                      color: AppColors.bleakRedColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
