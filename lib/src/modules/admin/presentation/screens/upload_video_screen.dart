import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/admin/presentation/notifiers/upload_video_notifier.dart';
import 'package:jima/src/modules/admin/presentation/widget/select_category_modal.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final videoIdController = TextEditingController();
  final releaseDateNotifier = ValueNotifier<DateTime?>(null);
  final categoryNotifier = ValueNotifier<Category?>(null);

  @override
  void dispose() {
    titleController.dispose();
    videoIdController.dispose();
    releaseDateNotifier.dispose();
    categoryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedVanilla<UploadVideoNotifier>(
      createNotifier: () => UploadVideoNotifier(container()),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: AppColors.blue,
          centerTitle: true,
          title: Text(
            'Upload Video',
            style: Textstyles.extraBold.copyWith(
              fontSize: 14.sp,
              color: AppColors.blackVoid,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: REdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                18.boxHeight,
                AppTextField.text(
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  controller: titleController,
                  labelText: 'Title',
                  hintText: 'Video Title',
                ),
                32.boxHeight,
                AppTextField.text(
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  controller: videoIdController,
                  labelText: 'Video ID',
                  hintText: 'Youtube Video ID e.g https://youtu.be/{{id_here}}',
                ),
                32.boxHeight,
                ValueListenableBuilder<DateTime?>(
                  valueListenable: releaseDateNotifier,
                  builder: (context, releaseDate, _) {
                    return AppTextField.text(
                      key: ValueKey(releaseDate),
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: releaseDate,
                          firstDate: DateTime.now().copySubtract(year: 100),
                          lastDate: DateTime.now(),
                        );
                        if (date == null) return;
                        if (!context.mounted) return;
                        releaseDateNotifier.value = date;
                      },
                      initialValue: releaseDate == null
                          ? null
                          : DateFormat('EEE, dd MMM, yyyy').format(releaseDate),
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      labelText: 'Release Date',
                      hintText: 'Select Release Date',
                    );
                  },
                ),
                32.boxHeight,
                ValueListenableBuilder<Category?>(
                  valueListenable: categoryNotifier,
                  builder: (context, category, _) {
                    return AppTextField.text(
                      key: ValueKey(category),
                      readOnly: true,
                      onTap: () async {
                        final category = await SelectCategoryModal.show();
                        if (category == null || !mounted) return;
                        categoryNotifier.value = category;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select a category';
                        }
                        return null;
                      },
                      initialValue: category?.name,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      labelText: 'Category',
                      hintText: 'Select Category',
                    );
                  },
                ),
                32.boxHeight,
                VanillaListener<UploadVideoNotifier, UploadVideoState>(
                  listener: (previous, current) {
                    if (current.isSuccess) {
                      titleController.clear();
                      videoIdController.clear();
                      releaseDateNotifier.value = null;
                      context.showSuccessToast('Upload successful');
                    }
                    if (current case ErrorState(:final message)) {
                      context.showErrorToast(message);
                    }
                  },
                  child: VanillaBuilder<UploadVideoNotifier, UploadVideoState>(
                    builder: (context, state) {
                      return AppButton.primary(
                        loading: state.isOutLoading,
                        onPressed: () {
                          if (formKey.currentState?.validate() != true) return;
                          if (releaseDateNotifier.value == null) return;
                          context.read<UploadVideoNotifier>().uploadVideo(
                                titleController.text.trim(),
                                videoIdController.text.trim(),
                                releaseDateNotifier.value!,
                                categoryNotifier.value!,
                              );
                        },
                        text: 'Upload',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
