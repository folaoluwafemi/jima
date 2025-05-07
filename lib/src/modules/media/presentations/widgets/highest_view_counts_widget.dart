import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media.dart';
import 'package:jima/src/modules/media/presentations/cubits/highest_viewed_notifier.dart';
import 'package:jima/src/modules/media/presentations/widgets/highest_media_carousel.dart';
import 'package:jima/src/tools/components/make_shimmer.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class HighestViewedMediaView extends StatelessWidget {
  const HighestViewedMediaView({super.key});

  @override
  Widget build(BuildContext context) {
    return VanillaListener<HighestViewedNotifier, HighestViewedState>(
      listener: (previous, current) {
        if (current case ErrorState(:final message)) {
          context.showErrorToast(message);
        }
      },
      child: VanillaBuilder<HighestViewedNotifier, HighestViewedState>(
        builder: (context, state) {
          if (state.isInLoading && state.data == null) {
            return const AllViewCountLoader();
          }
          if (state.data.isNullOrEmpty) return const SizedBox.shrink();
          return Padding(
            padding: REdgeInsets.only(top: 24),
            child: HighestMediaCarousel(mediaList: state.data ?? []),
          );
        },
      ),
    );
  }
}

class HighestViewedMediaItemWidget extends StatelessWidget {
  final GenericMedia media;
  final VoidCallback? onPressed;

  const HighestViewedMediaItemWidget({
    super.key,
    required this.media,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: 20.circularBorder,
        child: SizedBox(
          width: context.screenWidth(),
          height: 180.h,
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: media.thumbnail ?? NetworkImages.placeholder,
                fit: BoxFit.cover,
                width: context.screenWidth(),
                height: 180.h,
              ),
              Container(color: AppColors.black.withAlpha(128)),
              Padding(
                padding: REdgeInsets.symmetric(
                  horizontal: 18.w,
                  vertical: 20.h,
                ),
                child: SizedBox(
                  width: 221.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        media.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Textstyles.medium.copyWith(
                          fontSize: 21.sp,
                          height: 1.19,
                          color: AppColors.white,
                        ),
                      ),
                      14.boxHeight,
                      Text(
                        media.minister.name,
                        style: Textstyles.medium.copyWith(
                          fontSize: 14.sp,
                          height: 1.19,
                          color: AppColors.greyVariant,
                        ),
                      ),
                      19.boxHeight,
                      InkWell(
                        onTap: onPressed,
                        child: Vectors.playNow.vectorAssetWidget(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AllViewCountLoader extends StatelessWidget {
  const AllViewCountLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return MakeShimmer(
      child: Padding(
        padding: REdgeInsets.only(top: 32),
        child: GreyBox(
          borderRadius: 20.circularBorder,
          height: 173.h,
          width: 351.w,
        ),
      ),
    );
  }
}
