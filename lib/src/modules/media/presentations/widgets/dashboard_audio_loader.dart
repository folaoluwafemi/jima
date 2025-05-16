import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/tools/components/make_shimmer.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class DashboardAudiosLoader extends StatelessWidget {
  const DashboardAudiosLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final itemWidth = (context.screenWidth() - 88) / 2;
    return MakeShimmer(
      child: UnconstrainedBox(
        constrainedAxis: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: REdgeInsets.fromLTRB(26, 24, 26, 0),
          child: Row(
            spacing: 20.w,
            children: [
              ...List.generate(
                3,
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
      ),
    );
  }
}
