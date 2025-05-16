import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/router.dart';
import 'package:jima/src/tools/components/app_text_field.dart';
import 'package:jima/src/tools/extensions/extensions.dart';

class AddCategoryModal extends StatefulWidget {
  const AddCategoryModal({super.key});

  static Future<String?> show() {
    final context = AppRouter.rootNavigatorKey.currentContext!;
    return showModalBottomSheet<String?>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => const AddCategoryModal(),
    );
  }

  @override
  State<AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField.text(
            controller: controller,
            labelText: 'Category name',
            hintText: 'Enter category name',
          ),
          32.boxHeight,
          InkWell(
            onTap: () {
              if (controller.text.trim().isEmpty) {
                context.showErrorToast('Please enter a category name');
                return;
              }
              context.pop(controller.text);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.buttonTextBlack,
                borderRadius: 12.circularBorder,
              ),
              padding: REdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Center(
                child: Text(
                  'Add Category',
                  style: Textstyles.medium.copyWith(
                    fontSize: 16.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
          32.boxHeight,
          32.boxHeight,
          context.viewInsets.bottom.boxHeight,
        ],
      ),
    );
  }
}
