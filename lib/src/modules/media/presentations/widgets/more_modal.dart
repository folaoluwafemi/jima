import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/router.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media_type.dart';
import 'package:jima/src/modules/media/presentations/cubits/audios_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/books_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/delete_media_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/videos_notifier.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class MoreModal extends StatelessWidget {
  final String mediaId;
  final GenericMediaType type;
  final String mediaUrl;

  const MoreModal({
    super.key,
    required this.mediaId,
    required this.type,
    required this.mediaUrl,
  });

  static Future show(
    String mediaId, {
    required GenericMediaType type,
    required String mediaUrl,
  }) {
    final context = AppRouter.rootNavigatorKey.currentContext!;
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => MoreModal(
        mediaId: mediaId,
        type: type,
        mediaUrl: mediaUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InheritedVanilla<DeleteMediaNotifier>(
      createNotifier: () => DeleteMediaNotifier(container()),
      child: Builder(
        builder: (context) {
          return VanillaListener<DeleteMediaNotifier, BaseState>(
            listener: (previous, current) {
              if (current case ErrorState(:final message)) {
                context.showErrorToast(message);
              }
              if (current.isSuccess) {
                context.pop();
                switch (type) {
                  case GenericMediaType.audio:
                    context
                        .read<AudiosNotifier>()
                        .fetchAudios(fetchAFresh: true);
                    break;
                  case GenericMediaType.video:
                    context
                        .read<VideosNotifier>()
                        .fetchVideos(fetchAFresh: true);
                    break;
                  case GenericMediaType.book:
                    context.read<BooksNotifier>().fetchBooks(fetchAFresh: true);
                    break;
                }
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => context
                      .read<DeleteMediaNotifier>()
                      .deleteMedia(mediaId, type, mediaUrl),
                  child: Padding(
                    padding:
                        REdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete,
                          color: AppColors.red,
                        ),
                        24.boxWidth,
                        VanillaBuilder<DeleteMediaNotifier, BaseState>(
                          builder: (context, state) {
                            return Text(
                              state.isOutLoading ? 'Deleting . . .' : 'Delete',
                              style: TextStyle(
                                color:
                                    state.isOutLoading ? null : AppColors.red,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                16.boxHeight,
                context.bottomScreenPadding.boxHeight,
              ],
            ),
          );
        },
      ),
    );
  }
}
