import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/admin/presentation/notifiers/upload_audio_notifier.dart';
import 'package:jima/src/modules/admin/presentation/widget/select_category_modal.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class UploadAudioScreen extends StatefulWidget {
  const UploadAudioScreen({super.key});

  @override
  State<UploadAudioScreen> createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final releaseDateNotifier = ValueNotifier<DateTime?>(null);
  final categoryNotifier = ValueNotifier<Category?>(null);
  String? filePath;

  @override
  void dispose() {
    titleController.dispose();
    releaseDateNotifier.dispose();
    categoryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedVanilla<UploadAudioNotifier>(
      createNotifier: () => UploadAudioNotifier(container()),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: AppColors.blue,
          centerTitle: true,
          title: Text(
            'Upload Audio',
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
                  hintText: 'Audio Title',
                ),
                32.boxHeight,
                UploadAudioFileButton(
                  key: ValueKey(filePath),
                  onPathChanged: (value) {
                    filePath = value;
                  },
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
                VanillaListener<UploadAudioNotifier, UploadAudioState>(
                  listener: (previous, current) {
                    if (current.isSuccess) {
                      titleController.clear();
                      releaseDateNotifier.value = null;
                      filePath = null;
                      setState(() {});
                      context.showSuccessToast('Upload successful');
                    }
                    if (current case ErrorState(:final message)) {
                      context.showErrorToast(message);
                    }
                  },
                  child: VanillaBuilder<UploadAudioNotifier, UploadAudioState>(
                    builder: (context, state) {
                      return AppButton.primary(
                        loading: state.isOutLoading,
                        onPressed: () {
                          if (formKey.currentState?.validate() != true) return;
                          if (filePath == null) {
                            context.showErrorToast(
                              'Please select an audio file',
                            );
                            return;
                          }
                          if (releaseDateNotifier.value == null) return;
                          context.read<UploadAudioNotifier>().uploadAudio(
                                titleController.text.trim(),
                                filePath!,
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

class UploadAudioFileButton extends StatefulWidget {
  final ValueChanged<String> onPathChanged;

  const UploadAudioFileButton({
    super.key,
    required this.onPathChanged,
  });

  @override
  State<UploadAudioFileButton> createState() => _UploadAudioFileButtonState();
}

class _UploadAudioFileButtonState extends State<UploadAudioFileButton> {
  Future<void> pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    if (result == null) return;
    final file = result.files.first;
    if (file.path == null) return;
    filePath = file.path!;
    if (!mounted) return;
    setState(() {});
    widget.onPathChanged(filePath!);
  }

  String? filePath;

  @override
  Widget build(BuildContext context) {
    return VanillaBuilder<UploadAudioNotifier, UploadAudioState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Upload Audio File',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                height: 1.3,
                color: AppColors.black500,
                fontWeight: FontWeight.w600,
              ),
            ),
            8.boxHeight,
            RawMaterialButton(
              onPressed: () {
                if (state.isOutLoading) return;
                pickAudioFile();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: AppColors.iGrey500, width: 1),
              ),
              padding: EdgeInsets.zero,
              child: Padding(
                padding: REdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        filePath?.split('/').last ?? 'Select Audio File',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: filePath == null
                            ? context.textTheme.bodyMedium?.copyWith(
                                color: AppColors.grey500,
                                fontSize: 14.sp,
                                height: 1.6,
                                fontWeight: FontWeight.w400,
                              )
                            : context.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textBlack,
                                fontSize: 14.sp,
                                height: 1.6,
                                fontWeight: FontWeight.w400,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
