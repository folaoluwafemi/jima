import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media_type.dart';
import 'package:jima/src/modules/media/domain/entities/video.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPreviewScreen extends StatefulWidget {
  final Video video;

  const VideoPreviewScreen({
    super.key,
    required this.video,
  });

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late ValueNotifier<bool> isDarkNotifier = ValueNotifier(
    context.brightness == Brightness.dark,
  );

  @override
  void initState() {
    super.initState();
    updateViewCount();
  }

  Future<void> updateViewCount() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    container<MediaDataSource>().increaseMediaViewedCount(
      id: widget.video.id,
      type: GenericMediaType.video,
    );
  }

  @override
  void dispose() {
    isDarkNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: ValueListenableBuilder<bool>(
        valueListenable: isDarkNotifier,
        builder: (context, value, _) {
          return Scaffold(
            backgroundColor: value ? AppColors.black : AppColors.white,
            body: VideoPreviewer(
              video: widget.video,
              isDarkNotifier: isDarkNotifier,
              key: ValueKey(widget.video),
            ),
          );
        },
      ),
    );
  }
}

class VideoPreviewer extends StatefulWidget {
  final Video video;
  final ValueNotifier<bool> isDarkNotifier;

  const VideoPreviewer({
    super.key,
    required this.video,
    required this.isDarkNotifier,
  });

  @override
  State<VideoPreviewer> createState() => _VideoPreviewerState();
}

class _VideoPreviewerState extends State<VideoPreviewer> {
  late final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: YoutubePlayer.convertUrlToId(widget.video.url)!,
    flags: const YoutubePlayerFlags(
      autoPlay: false,
    ),
  );

  void listener() {}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      builder: (context, widget) {
        return SafeArea(
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget,
                    Padding(
                      padding: REdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: this.widget.isDarkNotifier,
                        builder: (context, isDark, _) {
                          return Text(
                            this.widget.video.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: Textstyles.medium.copyWith(
                              fontSize: 14.sp,
                              height: 1.5,
                              color: isDark
                                  ? AppColors.buttonGrey
                                  : AppColors.textBlack,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: REdgeInsets.all(16),
                child: ValueListenableBuilder<bool>(
                  valueListenable: this.widget.isDarkNotifier,
                  builder: (context, isDark, _) {
                    return IconButton(
                      onPressed: () {
                        this.widget.isDarkNotifier.value = !isDark;
                      },
                      icon: Icon(
                        isDark
                            ? Icons.light_mode_rounded
                            : Icons.lightbulb_outlined,
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        onReady: () {
          _controller.addListener(listener);
        },
      ),
    );
  }
}
