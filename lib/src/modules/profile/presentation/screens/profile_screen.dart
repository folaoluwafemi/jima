import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/core/supabase_infra/auth_service.dart';
import 'package:jima/src/modules/profile/presentation/cubits/user_cubit.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Textstyles.bold.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 18.sp,
            height: 1.5,
            color: AppColors.blackVoid,
          ),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            borderRadius: 139.circularBorder,
            onTap: () {},
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                SizedBox.square(
                  dimension: 139.sp,
                  child: Vectors.userProfile.vectorAssetWidget(),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: CircleAvatar(
                    radius: 15.5.sp,
                    child: SizedBox.square(
                      dimension: 18.sp,
                      child: const FittedBox(
                        child: Icon(Icons.edit_sharp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          42.boxHeight,
          ValueListenableBuilder(
            valueListenable: container<UserNotifier>(),
            builder: (context, state, _) {
              return FieldView(
                firstname: container<UserNotifier>().firstname,
                lastname: container<UserNotifier>().lastname,
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
          const Spacer(),
          Text(
            'Joshua Iginla Ministries\nVersion 1.0',
            textAlign: TextAlign.center,
            style: Textstyles.normal.copyWith(
              fontSize: 14.sp,
              height: 1.5,
              color: const Color(0xFF646464),
            ),
          ),
          50.boxHeight,
        ],
      ),
    );
  }
}

class FieldView extends StatefulWidget {
  final String? firstname;
  final String? lastname;

  const FieldView({
    super.key,
    required this.firstname,
    required this.lastname,
  });

  @override
  State<FieldView> createState() => _FieldViewState();
}

class _FieldViewState extends State<FieldView> {
  bool isEditMode = false;
  late final firstnameController = TextEditingController(
    text: widget.firstname,
  );
  late final lastnameController = TextEditingController(
    text: widget.lastname,
  );

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Full Name',
            style: Textstyles.semibold.copyWith(
              fontSize: 14.sp,
              height: 1.3,
            ),
          ),
          12.boxHeight,
          AppTextField(
            controller: firstnameController,
            readOnly: true,
          ),
          12.boxHeight,
          Text(
            'Full Name',
            style: Textstyles.semibold.copyWith(
              fontSize: 14.sp,
              height: 1.3,
            ),
          ),
          12.boxHeight,
          AppTextField(
            controller: lastnameController,
            readOnly: true,
          ),
        ],
      ),
    );
  }
}
