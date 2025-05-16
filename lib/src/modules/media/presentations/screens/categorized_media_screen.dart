import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/media/domain/entities/categorized_media.dart';
import 'package:jima/src/modules/media/domain/entities/category.dart';
import 'package:jima/src/modules/media/presentations/cubits/categorized_media_notifier.dart';
import 'package:jima/src/modules/media/presentations/widgets/dashboard_audio_widgets.dart';
import 'package:jima/src/modules/media/presentations/widgets/dashboard_video_widgets.dart';
import 'package:jima/src/tools/extensions/extensions.dart';
import 'package:vanilla_state/vanilla_state.dart';

class CategorizedMediaScreen extends StatefulWidget {
  final CategorizedMedia? defaultMediaType;
  final Category category;

  const CategorizedMediaScreen({
    super.key,
    this.defaultMediaType,
    required this.category,
  });

  @override
  State<CategorizedMediaScreen> createState() => _CategorizedMediaScreenState();
}

class _CategorizedMediaScreenState extends State<CategorizedMediaScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return InheritedVanilla<CategorizedMediaNotifier>(
      createNotifier: () => CategorizedMediaNotifier(
        container(),
        category: widget.category,
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: Text(
            widget.category.name,
            style: Textstyles.medium.copyWith(fontSize: 18.sp),
          ),
          centerTitle: true,
        ),
        body: switch (widget.defaultMediaType) {
          CategorizedMedia.audio => AudioCategorizedMediaView(
              category: widget.category,
            ),
          CategorizedMedia.video => VideoCategorizedMediaView(
              category: widget.category,
            ),
          null => Column(
              children: [
                TabBar(
                  controller: _tabController,
                  dividerHeight: 0.h,
                  tabs: [
                    ...CategorizedMedia.values.map(
                      (e) => Text(e.name.toFirstUppercase()),
                    ),
                  ],
                ),
                20.boxHeight,
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      AudioCategorizedMediaView(category: widget.category),
                      VideoCategorizedMediaView(category: widget.category),
                    ],
                  ),
                ),
              ],
            ),
        },
      ),
    );
  }
}

class AudioCategorizedMediaView extends StatefulWidget {
  final Category category;

  const AudioCategorizedMediaView({
    super.key,
    required this.category,
  });

  @override
  State<AudioCategorizedMediaView> createState() =>
      _AudioCategorizedMediaViewState();
}

class _AudioCategorizedMediaViewState extends State<AudioCategorizedMediaView> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => context
          .read<CategorizedMediaNotifier>()
          .fetchCategorizedAudios(widget.category),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => unawaited(
        context
            .read<CategorizedMediaNotifier>()
            .fetchCategorizedAudios(widget.category, fetchAFresh: true),
      ),
      child: SingleChildScrollView(
        padding: REdgeInsets.only(bottom: 200),
        physics: const AlwaysScrollableScrollPhysics(),
        child: VanillaBuilder<CategorizedMediaNotifier, CategorizedMediaState>(
          builder: (context, state) {
            final audios = state.data?.audios.items;
            if (state.isInLoading && audios.isNullOrEmpty) {
              return const AudiosLoader();
            }

            if (audios.isNullOrEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Padding(
                        padding: REdgeInsets.symmetric(vertical: 120),
                        child: Text(
                          'No results!!!',
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
    );
  }
}

class VideoCategorizedMediaView extends StatefulWidget {
  final Category category;

  const VideoCategorizedMediaView({
    super.key,
    required this.category,
  });

  @override
  State<VideoCategorizedMediaView> createState() =>
      _VideoCategorizedMediaViewState();
}

class _VideoCategorizedMediaViewState extends State<VideoCategorizedMediaView> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => context
          .read<CategorizedMediaNotifier>()
          .fetchCategorizedVideos(widget.category),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => unawaited(
        context
            .read<CategorizedMediaNotifier>()
            .fetchCategorizedVideos(widget.category, fetchAFresh: true),
      ),
      child: SingleChildScrollView(
        padding: REdgeInsets.only(bottom: 200),
        physics: const AlwaysScrollableScrollPhysics(),
        child: VanillaBuilder<CategorizedMediaNotifier, CategorizedMediaState>(
          builder: (context, state) {
            if (state.isInLoading) return const VideosLoader();
            final videos = state.data?.videos.items;

            if (videos.isNullOrEmpty) {
              return Center(
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: REdgeInsets.symmetric(vertical: 120),
                        child: Text(
                          'No results!!!',
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
                20.boxHeight,
                Padding(
                  padding: REdgeInsets.symmetric(horizontal: 26),
                  child: Wrap(
                    runSpacing: 36.w,
                    spacing: 20.h,
                    children: [
                      ...videos!.map((e) => VideoItemWidget(video: e)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
