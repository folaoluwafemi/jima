import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/router.dart';
import 'package:jima/src/modules/admin/presentation/notifiers/all_categories_notifier.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:jima/src/tools/extensions/extensions.dart';
import 'package:vanilla_state/vanilla_state.dart';

class SelectCategoryModal extends StatefulWidget {
  const SelectCategoryModal({super.key});

  static Future<Category?> show() {
    final context = AppRouter.rootNavigatorKey.currentContext!;
    return showModalBottomSheet<Category?>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => const SelectCategoryModal(),
    );
  }

  @override
  State<SelectCategoryModal> createState() => _SelectCategoryModalState();
}

class _SelectCategoryModalState extends State<SelectCategoryModal> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        if (!mounted ||
            context.read<AllCategoriesNotifier>().data.isNotNullOrEmpty) {
          return;
        }
        context.read<AllCategoriesNotifier>().fetchAllCategories();
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VanillaBuilder<AllCategoriesNotifier, BaseState>(
      builder: (context, state) {
        final List<Category> categories = state.data ?? [];
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                padding: REdgeInsets.symmetric(vertical: 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (categories.isEmpty)
                      Padding(
                        padding: REdgeInsets.only(top: 50, bottom: 100),
                        child: state.isInLoading
                            ? const CircularProgressIndicator()
                            : const Text('No categories'),
                      ),
                    ...categories.map(
                      (category) {
                        return InkWell(
                          onTap: () {
                            context.pop(category);
                          },
                          child: Padding(
                            padding: REdgeInsets.symmetric(
                              vertical: 14.h,
                            ),
                            child: Row(
                              children: [
                                24.boxWidth,
                                Text(
                                  category.name,
                                  style: Textstyles.medium.copyWith(
                                    fontSize: 14.sp,
                                    color: AppColors.black.withOpacity(0.7),
                                  ),
                                ),
                                24.boxWidth,
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            32.boxHeight,
            context.viewInsets.bottom.boxHeight,
          ],
        );
      },
    );
  }
}
