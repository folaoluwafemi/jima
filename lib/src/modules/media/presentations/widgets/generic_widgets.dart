import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media.dart';
import 'package:jima/src/tools/components/make_shimmer.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class GenericMediasLoader extends StatelessWidget {
  const GenericMediasLoader({super.key});

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
              4,
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

class GenericMediaItemWidget extends StatelessWidget {
  final GenericMedia genericMedia;

  const GenericMediaItemWidget({super.key, required this.genericMedia});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          ClipRRect(
            borderRadius: 8.circularBorder,
            child: SizedBox(
              width: 79.w,
              height: 89.h,
              child: Image.network(
                genericMedia.thumbnail ?? NetworkImages.placeholder,
                fit: BoxFit.cover,
              ),
            ),
          ),
          12.boxWidth,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                genericMedia.title,
                style: Textstyles.semibold.copyWith(
                  fontSize: 12.sp,
                  height: 1.5,
                ),
              ),
              7.boxHeight,
              Text(
                genericMedia.minister.name,
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
                    DateFormat('MMM dd yyyy').format(genericMedia.dateReleased),
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
                    DateFormat('hh:mm').format(genericMedia.dateReleased),
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
