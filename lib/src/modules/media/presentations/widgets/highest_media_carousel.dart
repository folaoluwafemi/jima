import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media_type.dart';
import 'package:jima/src/modules/media/presentations/widgets/highest_view_counts_widget.dart';

class HighestMediaCarousel extends StatefulWidget {
  final List<GenericMedia> mediaList;

  const HighestMediaCarousel({Key? key, required this.mediaList})
      : super(key: key);

  @override
  State<HighestMediaCarousel> createState() => _HighestMediaCarouselState();
}

class _HighestMediaCarouselState extends State<HighestMediaCarousel> {
  late final _pageController = PageController(
    viewportFraction: 0.9,
    initialPage: widget.mediaList.length > 2 ? 1 : 0,
  );

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 180.h,
          child: PageView.builder(
            itemCount: widget.mediaList.length,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) => Padding(
              padding: REdgeInsets.only(left: index == 0 ? 0 : 13),
              child: HighestViewedMediaItemWidget(
                media: widget.mediaList[index],
                onPressed: switch (widget.mediaList[index].type) {
                  GenericMediaType.audio => () => context.pushNamed(
                        AppRoute.audioPreview.name,
                        extra: widget.mediaList[index].toAudio(),
                      ),
                  GenericMediaType.book => () => context.pushNamed(
                        AppRoute.bookPreview.name,
                        extra: widget.mediaList[index].toBook(),
                      ),
                  GenericMediaType.video => () => context.pushNamed(
                        AppRoute.videoPreview.name,
                        extra: widget.mediaList[index].toVideo(),
                      ),
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.mediaList.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: _currentPage == index ? 10.sp : 8.sp,
              height: _currentPage == index ? 10.sp : 8.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? AppColors.blue : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
