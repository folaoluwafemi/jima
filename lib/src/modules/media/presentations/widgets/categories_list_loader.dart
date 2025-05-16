import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/tools/components/make_shimmer.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class CategoriesListLoader extends StatelessWidget {
  const CategoriesListLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return MakeShimmer(
      child: UnconstrainedBox(
        constrainedAxis: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: REdgeInsets.fromLTRB(24, 26, 26, 0),
          child: Row(
            spacing: 20.w,
            children: [
              ...List.generate(
                3,
                (index) {
                  return GreyBox(
                    width: 110.w,
                    height: 60.h,
                    borderRadius: 5.circularBorder,
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
