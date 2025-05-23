import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media_type.dart';
import 'package:jima/src/modules/media/domain/entities/video.dart';
import 'package:jima/src/modules/media/presentations/cubits/videos_notifier.dart';
import 'package:jima/src/modules/media/presentations/widgets/dashboard_video_loader.dart';
import 'package:jima/src/modules/media/presentations/widgets/more_modal.dart';
import 'package:jima/src/modules/profile/domain/entities/user_privilege.dart';
import 'package:jima/src/modules/profile/presentation/cubits/user_cubit.dart';
import 'package:jima/src/tools/components/make_shimmer.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class DashboardVideoWidgets extends StatefulWidget {
  const DashboardVideoWidgets({super.key});

  @override
  State<DashboardVideoWidgets> createState() => _DashboardVideoWidgetsState();
}

class _DashboardVideoWidgetsState extends State<DashboardVideoWidgets> {
  @override
  Widget build(BuildContext context) {
    return VanillaBuilder<VideosNotifier, VideosState>(
      builder: (context, state) {
        final videos = state.data?.items;
        if (videos == null || videos.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.boxHeight,
            Row(
              children: [
                25.boxWidth,
                Text(
                  'Top Videos',
                  style: Textstyles.bold.copyWith(
                    fontSize: 16.sp,
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => context.goNamed(AppRoute.videos.name),
                  borderRadius: 4.circularBorder,
                  child: Padding(
                    padding: REdgeInsets.all(8),
                    child: Text(
                      'More',
                      style: Textstyles.medium.copyWith(
                        fontSize: 12.sp,
                        height: 1.5,
                        color: AppColors.red,
                      ),
                    ),
                  ),
                ),
                17.boxWidth,
              ],
            ),
            16.boxHeight,
            if (state.isInLoading && videos.isNullOrEmpty)
              const DashboardVideosLoader()
            else
              UnconstrainedBox(
                constrainedAxis: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: REdgeInsets.symmetric(horizontal: 26),
                  child: Row(
                    spacing: 20.w,
                    children: [
                      ...videos.take(4).map((e) => VideoItemWidget(video: e)),
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

class VideoItemWidget extends StatelessWidget {
  final Video video;

  const VideoItemWidget({
    super.key,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    final itemWidth = (context.screenWidth() - 88.w) / 2;
    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: () =>
              context.pushNamed(AppRoute.videoPreview.name, extra: video),
          child: SizedBox(
            width: itemWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: 15.circularBorder,
                  child: SizedBox(
                    width: itemWidth,
                    height: itemWidth / 1.38,
                    child: Image.network(
                      video.thumbnail ?? NetworkImages.placeholder,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                6.boxHeight,
                Text(
                  video.title,
                  style: Textstyles.normal.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    fontSize: 12.sp,
                  ),
                ),
                6.boxHeight,
                Row(
                  children: [
                    ClipOval(
                      child: SizedBox.square(
                        dimension: 21.sp,
                        child: CachedNetworkImage(
                          imageUrl: video.minister.profilePhoto,
                          fit: BoxFit.cover,
                          width: 21.sp,
                          height: 21.sp,
                        ),
                      ),
                    ),
                    6.boxWidth,
                    Text(
                      video.minister.name,
                      style: Textstyles.medium.copyWith(
                        fontSize: 10.sp,
                        height: 1.5,
                      ),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 10.5.sp,
                      child: Icon(
                        Icons.play_arrow,
                        size: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: container<UserNotifier>(),
          builder: (context, state, _) {
            if (state.data?.privilege != UserPrivilege.admin) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: REdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => MoreModal.show(
                  video.id,
                  type: GenericMediaType.video,
                  mediaUrl: video.url,
                ),
                borderRadius: 40.circularBorder,
                child: ClipOval(
                  child: Container(
                    color: AppColors.black.withOpacity(0.4),
                    child: Padding(
                      padding: REdgeInsets.all(8),
                      child: const Icon(
                        Icons.more_vert_sharp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class VideosLoader extends StatelessWidget {
  const VideosLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final itemWidth = (context.screenWidth() - 88.w) / 2;
    return MakeShimmer(
      child: Padding(
        padding: REdgeInsets.symmetric(horizontal: 26),
        child: Column(
          spacing: 20.h,
          children: [
            24.boxHeight,
            ...List.generate(
              2,
              (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GreyBox(
                          width: itemWidth,
                          height: 113.h,
                          borderRadius: 15.circularBorder,
                        ),
                        6.boxHeight,
                        GreyBox(
                          width: itemWidth.percent(80),
                          height: 14.h,
                        ),
                        2.boxHeight,
                        GreyBox(
                          width: itemWidth.percent(65),
                          height: 14.h,
                        ),
                        6.boxHeight,
                        GreyBox(
                          width: itemWidth,
                          height: 20.h,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GreyBox(
                          width: itemWidth,
                          height: 113.h,
                          borderRadius: 15.circularBorder,
                        ),
                        6.boxHeight,
                        GreyBox(
                          width: itemWidth.percent(80),
                          height: 14.h,
                        ),
                        2.boxHeight,
                        GreyBox(
                          width: itemWidth.percent(65),
                          height: 14.h,
                        ),
                        6.boxHeight,
                        GreyBox(
                          width: itemWidth,
                          height: 20.h,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
