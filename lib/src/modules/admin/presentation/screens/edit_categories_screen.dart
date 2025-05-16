import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/admin/presentation/notifiers/all_categories_notifier.dart';
import 'package:jima/src/modules/admin/presentation/widget/add_category_modal.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:jima/src/modules/media/presentations/cubits/delete_category_notifier.dart';
import 'package:jima/src/tools/components/grey_box.dart';
import 'package:jima/src/tools/extensions/extensions.dart';
import 'package:vanilla_state/vanilla_state.dart';

class EditCategoriesScreen extends StatefulWidget {
  const EditCategoriesScreen({super.key});

  @override
  State<EditCategoriesScreen> createState() => _EditCategoriesScreenState();
}

class _EditCategoriesScreenState extends State<EditCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => context.read<AllCategoriesNotifier>().fetchAllCategories(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VanillaBuilder<AllCategoriesNotifier, AllCategoriesState>(
      builder: (context, state) {
        final categories = state.data ?? [];
        return Scaffold(
          appBar: AppBar(
            foregroundColor: AppColors.blue,
            centerTitle: true,
            title: Text(
              'Edit Categories',
              style: Textstyles.extraBold.copyWith(
                fontSize: 14.sp,
                color: AppColors.blackVoid,
              ),
            ),
          ),
          body: state.isInLoading && categories.isEmpty
              ? const _ItemsLoader()
              : Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<AllCategoriesNotifier>()
                              .fetchAllCategories();
                        },
                        child: ListView.separated(
                          itemCount: categories.length,
                          separatorBuilder: (context, index) => 8.boxHeight,
                          padding: REdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    category.name,
                                    style: Textstyles.medium.copyWith(
                                      fontSize: 14.sp,
                                      color: AppColors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                                DeleteIconWidget(category: category),
                                24.boxWidth,
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: REdgeInsets.symmetric(horizontal: 32),
                      child: InkWell(
                        onTap: () async {
                          final category = await AddCategoryModal.show();
                          if (category == null || !context.mounted) return;
                          context
                              .read<AllCategoriesNotifier>()
                              .addCategory(category);
                        },
                        child: Padding(
                          padding: REdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          child: state.isOutLoading
                              ? const CircularProgressIndicator()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.add),
                                    8.boxWidth,
                                    Text(
                                      'Add Category',
                                      style: Textstyles.medium.copyWith(
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    32.boxHeight,
                  ],
                ),
        );
      },
    );
  }
}

class DeleteIconWidget extends StatelessWidget {
  const DeleteIconWidget({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return InheritedVanilla<DeleteCategoryNotifier>(
      createNotifier: () => DeleteCategoryNotifier(
        container(),
      ),
      child: VanillaBuilder<DeleteCategoryNotifier, BaseState>(
        builder: (context, state) {
          if (state.isOutLoading) {
            return Padding(
              padding: REdgeInsets.all(8.0),
              child: SizedBox.square(
                dimension: 26.sp,
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              ),
            );
          }
          return Column(
            children: [
              VanillaListener<DeleteCategoryNotifier, BaseState>(
                listener: (current, previous) {
                  if (current is SuccessState) {
                    context.read<AllCategoriesNotifier>().fetchAllCategories();
                    context.read<AllCategoriesNotifier>().fetchAllCategories();
                  }
                },
                child: 0.boxHeight,
              ),
              IconButton(
                onPressed: () => context
                    .read<DeleteCategoryNotifier>()
                    .deleteCategory(category.id),
                icon: Icon(
                  Icons.delete,
                  size: 26.sp,
                  color: AppColors.black.withOpacity(0.7),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ItemsLoader extends StatelessWidget {
  const _ItemsLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: REdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24.h,
        children: [
          ...List.generate(
            6,
            (index) => Row(
              children: [
                GreyBox(
                  width: context.screenWidth(percent: 0.5),
                  height: 21.h,
                ),
                14.boxWidth,
                const Spacer(),
                GreyBox.square(dimension: 30.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
