import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/media/presentations/cubits/videos_notifier.dart';
import 'package:jima/src/modules/media/presentations/widgets/dashboard_video_widgets.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  String query = '';

  Future<void> search(BuildContext context) async {
    if (query.isEmpty) {
      context.read<VideosNotifier>().fetchVideos(fetchAFresh: true);
      return;
    }

    context.read<VideosNotifier>().search(query);
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
          context.read<VideosNotifier>().fetchVideos(fetchAFresh: true),
        ),
        child: SingleChildScrollView(
          padding: REdgeInsets.only(bottom: 200),
          physics: const AlwaysScrollableScrollPhysics(),
          child: VanillaBuilder<VideosNotifier, VideosState>(
            builder: (context, state) {
              if (state.isInLoading) return const VideosLoader();
              final videos = state.data?.items;

              if (videos.isNullOrEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Padding(
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
                    ],
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  28.boxHeight,
                  Padding(
                    padding: REdgeInsets.symmetric(horizontal: 26),
                    child: Text(
                      'Videos',
                      style: Textstyles.bold.copyWith(
                        fontSize: 32.sp,
                        height: 1.5,
                      ),
                    ),
                  ),
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
      ),
    );
  }
}
