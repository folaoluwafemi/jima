import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/media/domain/entities/audio.dart';
import 'package:jima/src/modules/media/presentations/cubits/audios_notifier.dart';
import 'package:jima/src/tools/components/grey_box.dart';
import 'package:jima/src/tools/components/make_shimmer.dart';
import 'package:jima/src/tools/tools_barrel.dart';
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
        if (state.isInLoading) return const AudiosLoader();
        final audios = state.data?.items;
        if (audios == null || audios.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: REdgeInsets.symmetric(horizontal: 26),
          child: Column(
            children: [
              24.boxHeight,
              Row(
                children: [
                  25.boxWidth,
                  Text(
                    'Top Audios',
                    style: Textstyles.bold.copyWith(
                      fontSize: 16.sp,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {},
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

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
