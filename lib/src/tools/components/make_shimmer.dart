import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jima/src/core/core.dart';
import 'package:shimmer/shimmer.dart';

class MakeShimmer extends StatelessWidget {
  final Widget child;
  final bool shimmer;

  const MakeShimmer({
    super.key,
    required this.child,
    this.shimmer = true,
  });

  static const Duration shimmerDuration = Duration(milliseconds: 1000);

  @override
  Widget build(BuildContext context) {
    if (!shimmer || Platform.isIOS && kDebugMode) return child;

    return Shimmer.fromColors(
      period: shimmerDuration,
      direction: ShimmerDirection.ltr,
      baseColor: AppColors.iGrey500,
      highlightColor: AppColors.offWhite,
      child: child,
    );
  }
}
