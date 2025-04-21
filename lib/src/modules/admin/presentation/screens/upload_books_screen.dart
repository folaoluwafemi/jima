import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/admin/presentation/notifiers/upload_books_notifier.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class UploadBooksScreen extends StatefulWidget {
  const UploadBooksScreen({super.key});

  @override
  State<UploadBooksScreen> createState() => _UploadBooksScreenState();
}

class _UploadBooksScreenState extends State<UploadBooksScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final bookUrlController = TextEditingController();
  final releaseDateNotifier = ValueNotifier<DateTime?>(null);
  final imagePathNotifier = ValueNotifier<String?>(null);

  @override
  void dispose() {
    titleController.dispose();
    bookUrlController.dispose();
    releaseDateNotifier.dispose();
    imagePathNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedVanilla<UploadBookNotifier>(
      createNotifier: () => UploadBookNotifier(container()),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: AppColors.blue,
          centerTitle: true,
          title: Text(
            'Upload Book',
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
                  hintText: 'Book Title',
                ),
                32.boxHeight,
                AppTextField.text(
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  controller: bookUrlController,
                  labelText: 'Book Link',
                  hintText: 'Amazon Link Here',
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
                ValueListenableBuilder<String?>(
                  valueListenable: imagePathNotifier,
                  builder: (context, imagePath, _) {
                    return ImagePickerWidget(
                      initialValue: imagePath,
                      onChanged: (value) {
                        imagePathNotifier.value = value;
                      },
                    );
                  },
                ),
                32.boxHeight,
                VanillaListener<UploadBookNotifier, UploadBookState>(
                  listener: (previous, current) {
                    if (current.isSuccess) {
                      titleController.clear();
                      bookUrlController.clear();
                      releaseDateNotifier.value = null;
                      imagePathNotifier.value = null;
                      context.showSuccessToast('Upload successful');
                    }
                    if (current case ErrorState(:final message)) {
                      context.showErrorToast(message);
                    }
                  },
                  child: VanillaBuilder<UploadBookNotifier, UploadBookState>(
                    builder: (context, state) {
                      return AppButton.primary(
                        loading: state.isOutLoading,
                        onPressed: () {
                          if (formKey.currentState?.validate() != true) return;
                          if (imagePathNotifier.value == null) {
                            return context.showErrorToast('Select an image');
                          }
                          context.read<UploadBookNotifier>().uploadBook(
                                title: titleController.text.trim(),
                                bookUrl: bookUrlController.text.trim(),
                                imagePath: imagePathNotifier.value!,
                                releaseDate: releaseDateNotifier.value!,
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

class ImagePickerWidget extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String?> onChanged;

  const ImagePickerWidget({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Future<void> pickImage() async {
    final file = await FilePicker.platform.pickFiles(type: FileType.image);
    if ((file?.paths).isNullOrEmpty || !mounted) return;
    widget.onChanged(file!.paths.first);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Upload Image',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                height: 1.3,
                color: AppColors.black500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        16.boxHeight,
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Padding(
              padding: REdgeInsets.only(right: 12, bottom: 8),
              child: InkWell(
                borderRadius: 16.circularBorder,
                onTap: pickImage,
                child: widget.initialValue != null
                    ? ClipRRect(
                        borderRadius: 16.circularBorder,
                        child: Image.file(
                          File(widget.initialValue!),
                          height: 100.h,
                          width: 90.w,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: 16.circularBorder,
                          color: AppColors.lightBlue,
                        ),
                        padding: REdgeInsets.symmetric(
                          horizontal: 29,
                          vertical: 34,
                        ),
                        child: Vectors.image.vectorAssetWidget(
                          dimension: 32.sp,
                        ),
                      ),
              ),
            ),
            CircleAvatar(
              radius: 15.5.sp,
              child: SizedBox.square(
                dimension: 18.sp,
                child: const FittedBox(
                  child: Icon(Icons.edit_sharp),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
