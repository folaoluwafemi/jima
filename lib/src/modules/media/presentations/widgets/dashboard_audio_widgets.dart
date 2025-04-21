import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/modules/media/domain/entities/audio.dart';
import 'package:jima/src/modules/media/presentations/cubits/audios_notifier.dart';
import 'package:jima/src/tools/components/make_shimmer.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vanilla_state/vanilla_state.dart';

class DashboardAudioWidgets extends StatefulWidget {
  const DashboardAudioWidgets({super.key});

  @override
  State<DashboardAudioWidgets> createState() => _DashboardAudioWidgetsState();
}

class _DashboardAudioWidgetsState extends State<DashboardAudioWidgets> {
  @override
  Widget build(BuildContext context) {
    return VanillaBuilder<AudiosNotifier, AudiosState>(
      builder: (context, state) {
        final audios = state.data?.items;
        if (state.isInLoading && audios.isNullOrEmpty) {
          return const AudiosLoader();
        }
        if (audios == null || audios.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: REdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              24.boxHeight,
              Row(
                children: [
                  Text(
                    'Top Audios',
                    style: Textstyles.bold.copyWith(
                      fontSize: 16.sp,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => context.goNamed(AppRoute.audios.name),
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
                ],
              ),
              16.boxHeight,
              Column(
                spacing: 10.h,
                children: [
                  ...audios.take(3).map((e) => AudioItemWidget(audio: e)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class AudiosLoader extends StatelessWidget {
  const AudiosLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final itemWidth = (context.screenWidth() - 88) / 2;
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
                  children: [
                    GreyBox(
                      width: 79.w,
                      height: 89.h,
                      borderRadius: 15.circularBorder,
                    ),
                    12.boxWidth,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GreyBox(
                          width: itemWidth.percent(80),
                          height: 19.h,
                        ),
                        7.boxHeight,
                        GreyBox(
                          width: itemWidth.percent(65),
                          height: 15.h,
                        ),
                        7.boxHeight,
                        GreyBox(
                          width: itemWidth,
                          height: 26.h,
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

class AudioItemWidget extends StatelessWidget {
  final Audio audio;

  const AudioItemWidget({super.key, required this.audio});

  Future<void> onPressed() async {
    launchUrl(
      Uri.parse(audio.url),
      mode: LaunchMode.externalApplication,
    );
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: 8.circularBorder,
            child: SizedBox(
              width: 79.w,
              height: 89.h,
              child: Image.network(
                audio.thumbnail ?? NetworkImages.placeholder,
                fit: BoxFit.cover,
              ),
            ),
          ),
          12.boxWidth,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                audio.title,
                style: Textstyles.semibold.copyWith(
                  fontSize: 12.sp,
                  height: 1.5,
                ),
              ),
              7.boxHeight,
              Text(
                audio.minister.name,
                style: Textstyles.normal.copyWith(
                  fontSize: 11.sp,
                  height: 1.5,
                  color: AppColors.grey400,
                ),
              ),
              7.boxHeight,
              Row(
                children: [
                  Vectors.calendar.vectorAssetWidget(),
                  4.boxWidth,
                  Text(
                    DateFormat('MMM dd yyyy').format(audio.dateReleased),
                    style: Textstyles.normal.copyWith(
                      fontSize: 11.sp,
                      height: 1.5,
                      color: AppColors.grey400,
                    ),
                  ),
                  17.boxWidth,
                  Vectors.clock.vectorAssetWidget(),
                  4.boxWidth,
                  Text(
                    DateFormat('hh:mm').format(audio.dateReleased),
                    style: Textstyles.normal.copyWith(
                      fontSize: 11.sp,
                      height: 1.5,
                      color: AppColors.grey400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
