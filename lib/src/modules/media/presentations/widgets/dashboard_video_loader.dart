import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/tools/components/make_shimmer.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class DashboardVideosLoader extends StatelessWidget {
  const DashboardVideosLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final itemWidth = (context.screenWidth() - 88.w) / 2;
    return MakeShimmer(
      child: UnconstrainedBox(
        constrainedAxis: Axis.horizontal,
        child: SingleChildScrollView(
          padding: REdgeInsets.fromLTRB(26, 24, 26, 0),
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 20.w,
            children: [
              ...List.generate(
                3,
                (index) {
                  return Column(
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
