import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/admin/presentation/notifiers/upload_audio_notifier.dart';
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
  final spotifyUrlController = TextEditingController();
  final releaseDateNotifier = ValueNotifier<DateTime?>(null);

  @override
  void dispose() {
    titleController.dispose();
    spotifyUrlController.dispose();
    releaseDateNotifier.dispose();
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
                AppTextField.text(
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  controller: spotifyUrlController,
                  labelText: 'Spotify Url',
                  hintText: 'Spotify Link Here',
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
                VanillaListener<UploadAudioNotifier, UploadAudioState>(
                  listener: (previous, current) {
                    if (current.isSuccess) {
                      titleController.clear();
                      spotifyUrlController.clear();
                      releaseDateNotifier.value = null;
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
                          if (releaseDateNotifier.value == null) return;
                          context.read<UploadAudioNotifier>().uploadAudio(
                                titleController.text.trim(),
                                spotifyUrlController.text.trim(),
                                releaseDateNotifier.value!,
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
