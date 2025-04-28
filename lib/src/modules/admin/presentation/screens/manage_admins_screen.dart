import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/admin/presentation/notifiers/manage_admins_notifier.dart';
import 'package:jima/src/modules/profile/domain/entities/user.dart';
import 'package:jima/src/tools/components/make_shimmer.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class ManageAdminsScreen extends StatefulWidget {
  const ManageAdminsScreen({super.key});

  @override
  State<ManageAdminsScreen> createState() => _ManageAdminsScreenState();
}

class _ManageAdminsScreenState extends State<ManageAdminsScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<ManageAdminsNotifier>().fetchAdmins();
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VanillaBuilder<ManageAdminsNotifier, ManageAdminsState>(
      builder: (context, state) {
        final admins = state.data ?? [];
        return Scaffold(
          backgroundColor: AppColors.whiteVariant,
          appBar: AppBar(
            foregroundColor: AppColors.blue,
            centerTitle: true,
            title: Text(
              'Manage Admins',
              style: Textstyles.extraBold.copyWith(
                fontSize: 14.sp,
                color: AppColors.blackVoid,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size(context.screenWidth(), 1.h),
              child: state.isOutLoading
                  ? const LinearProgressIndicator()
                  : const SizedBox.shrink(),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => unawaited(
                    context.read<ManageAdminsNotifier>().fetchAdmins(),
                  ),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: REdgeInsets.symmetric(horizontal: 18),
                    child: VanillaListener<ManageAdminsNotifier,
                        ManageAdminsState>(
                      listener: (previous, current) {
                        if (current case ErrorState(:final message)) {
                          context.showErrorToast(message);
                        }
                      },
                      child: Column(
                        children: [
                          20.boxHeight,
                          if (admins.isEmpty && !state.isInLoading)
                            Padding(
                              padding: REdgeInsets.symmetric(vertical: 200),
                              child: Column(
                                children: [
                                  Text(
                                    'There are no admins currently',
                                    textAlign: TextAlign.center,
                                    style: Textstyles.medium.copyWith(
                                      fontSize: 18.sp,
                                      color: AppColors.buttonTextBlack,
                                    ),
                                  ),
                                  4.boxHeight,
                                  Text(
                                    'Check below to add',
                                    textAlign: TextAlign.center,
                                    style: Textstyles.normal.copyWith(
                                      fontSize: 16.sp,
                                      color: AppColors.buttonTextBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ...admins.map(
                            (e) => AdminItemWidget(
                              admin: e,
                              onDeleteUser: () => context
                                  .read<ManageAdminsNotifier>()
                                  .removeUserAsAdmin(e),
                            ),
                          ),
                          if (state.isInLoading) const AdminsShimmer(),
                          300.boxHeight,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(color: AppColors.white),
                padding: REdgeInsets.fromLTRB(
                  18,
                  24,
                  18,
                  context.bottomScreenPadding + 18,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AppTextField.email(
                        focusNode: focusNode,
                        autovalidateMode: AutovalidateMode.disabled,
                        onSubmit: (value) {
                          context.read<ManageAdminsNotifier>().addAdmin(
                                controller.text.trim(),
                              );
                          controller.clear();
                          focusNode.unfocus();
                        },
                        controller: controller,
                        labelText: null,
                        hintText: 'Enter user email',
                      ),
                    ),
                    Padding(
                      padding: REdgeInsets.only(left: 16),
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<ManageAdminsNotifier>().addAdmin(
                                controller.text.trim(),
                              );
                          controller.clear();
                          focusNode.unfocus();
                        },
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                            REdgeInsets.symmetric(vertical: 16.h),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: 8.circularBorder,
                            ),
                          ),
                        ),
                        child: state.isOutLoading
                            ? SizedBox.square(
                                dimension: 21.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 3,
                                  backgroundColor: AppColors.black,
                                  valueColor: AlwaysStoppedAnimation(
                                    AppColors.white,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.add,
                                color: AppColors.black,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AdminItemWidget extends StatelessWidget {
  final User admin;
  final VoidCallback onDeleteUser;

  const AdminItemWidget({
    super.key,
    required this.admin,
    required this.onDeleteUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          ClipOval(
            child: Container(
              height: 54.sp,
              width: 54.sp,
              color: AppColors.iGrey500,
              child: admin.profilePhoto == null
                  ? Vectors.userProfile.vectorAssetWidget()
                  : CachedNetworkImage(
                      imageUrl: admin.profilePhoto!,
                      width: 54.sp,
                      height: 54.sp,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          12.boxWidth,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      admin.firstname ?? 'No first name',
                      style: Textstyles.medium.copyWith(
                        color: AppColors.bottomNavText,
                      ),
                    ),
                    8.boxWidth,
                    Text(
                      admin.lastname ?? 'No last name',
                      style: Textstyles.medium.copyWith(
                        color: AppColors.bottomNavText,
                      ),
                    ),
                  ],
                ),
                4.boxHeight,
                Text(
                  admin.email ?? 'No email',
                  style: Textstyles.medium.copyWith(
                    color: AppColors.black700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDeleteUser,
            icon: const Icon(
              Icons.delete,
              color: AppColors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class AdminsShimmer extends StatelessWidget {
  const AdminsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return MakeShimmer(
      child: Column(
        spacing: 18.h,
        children: [
          ...List.generate(
            7,
            (index) => Row(
              children: [
                GreyBox.circle(dimension: 54),
                12.boxWidth,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GreyBox(
                          height: 18.h,
                          width: context.screenWidth(percent: .25),
                        ),
                        12.boxWidth,
                        GreyBox(
                          height: 18.h,
                          width: context.screenWidth(percent: .3),
                        ),
                      ],
                    ),
                    12.boxHeight,
                    GreyBox(
                      height: 14.h,
                      width: context.screenWidth(percent: .6),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
