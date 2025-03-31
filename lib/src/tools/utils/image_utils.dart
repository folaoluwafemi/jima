import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:jima/src/tools/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends Image {
  CustomNetworkImage(
    super.path, {
    super.key,
    super.scale = 1.0,
    super.frameBuilder,
    super.loadingBuilder = ImageUtils.generalLoadingImageBuilder,
    super.errorBuilder = ImageUtils.generalErrorBuilder,
    super.semanticLabel,
    super.excludeFromSemantics = false,
    super.width,
    super.height,
    super.color,
    super.opacity,
    super.colorBlendMode,
    super.fit,
    super.alignment = Alignment.center,
    super.repeat = ImageRepeat.noRepeat,
    super.centerSlice,
    super.matchTextDirection = false,
    super.gaplessPlayback = false,
    super.filterQuality = FilterQuality.low,
    super.isAntiAlias = false,
  }) : super.network();
}

class SquareCustomNetworkImage extends StatelessWidget {
  final String path;
  final double scale;
  final double dimension;
  final ImageFrameBuilder? frameBuilder;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final double? width;
  final double? height;
  final Color? color;
  final Animation<double>? opacity;
  final BlendMode? colorBlendMode;
  final BoxFit? fit;
  final AlignmentGeometry alignment;

  final ImageRepeat repeat;

  final Rect? centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final ui.FilterQuality filterQuality;
  final bool isAntiAlias;

  const SquareCustomNetworkImage(
    this.path, {
    required this.dimension,
    super.key,
    this.scale = 1.0,
    this.frameBuilder,
    this.loadingBuilder = ImageUtils.generalLoadingImageBuilder,
    this.errorBuilder = ImageUtils.generalErrorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.filterQuality = FilterQuality.low,
    this.isAntiAlias = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: CustomNetworkImage(
        path,
        scale: scale,
        frameBuilder: frameBuilder,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        width: width,
        height: height,
        color: color,
        opacity: opacity,
        colorBlendMode: colorBlendMode,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
        centerSlice: centerSlice,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        filterQuality: filterQuality,
        isAntiAlias: isAntiAlias,
      ),
    );
  }
}

abstract final class ImageUtils {
  static Widget generalErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Container(
      color: context.theme.colorScheme.surface,
      child: Icon(
        Icons.error_outline,
        color: context.theme.colorScheme.onSurface,
        size: 30.spMax,
      ),
    );
  }

  static Widget avatarLoadingImageBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    final bool isLoading = loadingProgress != null;

    return isLoading
        ? FittedBox(
            child: Icon(Icons.person, color: Colors.grey.shade300),
          )
        : child;
  }

  static Widget generalLoadingImageBuilder([
    BuildContext? context,
    Widget? child,
    ImageChunkEvent? loadingProgress,
  ]) {
    final Widget skeleton = Container(
      color: Colors.grey.shade200.withValues(alpha: 0.5),
    );

    final bool isLoading = loadingProgress != null;

    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade200,
            direction: ShimmerDirection.ltr,
            enabled: true,
            child: skeleton,
          )
        : child ?? const SizedBox.shrink();
  }

  static Widget cachedImageProgressBuilder(
    BuildContext context,
    String url,
    DownloadProgress progress,
  ) {
    final Widget skeleton = Container(
      color: Colors.grey.shade200.withValues(alpha: 0.5),
    );

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300.withValues(alpha: 0.5),
      highlightColor: Colors.grey.shade100.withValues(alpha: 0.5),
      direction: ShimmerDirection.ltr,
      enabled: true,
      child: skeleton,
    );
  }

  static Widget imageLoadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress, {
    Color? progressIndicatorColor,
  }) {
    if (loadingProgress == null ||
        loadingProgress.expectedTotalBytes == null ||
        loadingProgress.expectedTotalBytes == 0 ||
        loadingProgress.cumulativeBytesLoaded ==
            loadingProgress.expectedTotalBytes) {
      return child;
    }
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: progressIndicatorColor,
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
      ),
    );
  }
}
