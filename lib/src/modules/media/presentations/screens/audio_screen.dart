import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/media/domain/entities/categorized_media.dart';
import 'package:jima/src/modules/media/presentations/cubits/audios_notifier.dart';
import 'package:jima/src/modules/media/presentations/screens/dashboard_screen.dart';
import 'package:jima/src/modules/media/presentations/widgets/dashboard_audio_widgets.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class AudiosScreen extends StatefulWidget {
  const AudiosScreen({super.key});

  @override
  State<AudiosScreen> createState() => _AudiosScreenState();
}

class _AudiosScreenState extends State<AudiosScreen> {
  String query = '';

  Future<void> search(BuildContext context) async {
    if (query.isEmpty) {
      context.read<AudiosNotifier>().fetchAudios(fetchAFresh: true);
      return;
    }
    context.read<AudiosNotifier>().search(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10.h,
        bottom: PreferredSize(
          preferredSize: Size(context.screenWidth(), 48.h),
          child: Padding(
            padding: REdgeInsets.symmetric(horizontal: 16.w),
            child: Builder(
              builder: (context) {
                final border = OutlineInputBorder(
                  borderRadius: 25.circularBorder,
                  borderSide: BorderSide.none,
                );
                return TextField(
                  onChanged: (value) {
                    query = value;
                  },
                  maxLines: 1,
                  onSubmitted: (value) => search(context),
                  decoration: InputDecoration(
                    contentPadding: REdgeInsets.symmetric(horizontal: 26),
                    prefixIcon: IntrinsicWidth(
                      child: Align(
                        child: SizedBox.square(
                          dimension: 17.sp,
                          child: Vectors.searchIcon.vectorAssetWidget(),
                        ),
                      ),
                    ),
                    suffix: InkWell(
                      onTap: () => search(context),
                      child: Padding(
                        padding: REdgeInsets.all(4),
                        child: Text(
                          'Done',
                          style: Textstyles.normal.copyWith(
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.buttonGrey,
                    hintText: 'Search your favorite message',
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => unawaited(
          context.read<AudiosNotifier>().fetchAudios(fetchAFresh: true),
        ),
        child: SingleChildScrollView(
          padding: REdgeInsets.only(bottom: 200),
          physics: const AlwaysScrollableScrollPhysics(),
          child: VanillaBuilder<AudiosNotifier, AudiosState>(
            builder: (context, state) {
              if (state.isInLoading) {
                return const AudiosLoader();
              }
              final audios = state.data?.items;

              if (audios.isNullOrEmpty) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Padding(
                          padding: REdgeInsets.symmetric(vertical: 120),
                          child: Text(
                            state is InitialState
                                ? 'Enter the query you want to search'
                                : 'No results!!!',
                            style: Textstyles.normal.copyWith(
                              fontSize: 16.sp,
                              color: AppColors.buttonTextBlack,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CategorizesList(mediaType: CategorizedMedia.video),
                  28.boxHeight,
                  Padding(
                    padding: REdgeInsets.symmetric(horizontal: 26),
                    child: Text(
                      'Audios',
                      style: Textstyles.bold.copyWith(
                        fontSize: 16.sp,
                        height: 1.5,
                      ),
                    ),
                  ),
                  20.boxHeight,
                  Padding(
                    padding: REdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      spacing: 10.h,
                      children: [
                        ...audios!.map((e) => AudioItemWidget(audio: e)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
