import 'package:flutter/material.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/admin/presentation/notifiers/all_categories_notifier.dart';
import 'package:jima/src/modules/admin/presentation/notifiers/manage_admins_notifier.dart';
import 'package:jima/src/modules/auth/presentation/notifiers/login_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/audio_player_manager.dart';
import 'package:jima/src/modules/media/presentations/cubits/audios_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/books_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/categories_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/highest_viewed_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/search_all_media_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/videos_notifier.dart';
import 'package:jima/src/modules/profile/presentation/cubits/user_cubit.dart';
import 'package:vanilla_state/vanilla_state.dart';

class GeneralUiIOCContainer extends StatelessWidget {
  final Widget child;

  const GeneralUiIOCContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiInheritedVanilla(
      children: [
        InheritedVanilla<UserNotifier>(createNotifier: () => container()),
        InheritedVanilla(createNotifier: () => LoginNotifier(container())),
        InheritedVanilla<HighestViewedNotifier>(
          createNotifier: () => container(),
        ),
        InheritedVanilla<SearchAllMediaNotifier>(
          createNotifier: () => container(),
        ),
        InheritedVanilla<VideosNotifier>(createNotifier: () => container()),
        InheritedVanilla<AudiosNotifier>(createNotifier: () => container()),
        InheritedVanilla<BooksNotifier>(createNotifier: () => container()),
        InheritedVanilla<AllCategoriesNotifier>(
          createNotifier: () => AllCategoriesNotifier(container()),
        ),
        InheritedVanilla<CategoriesNotifier>(
          createNotifier: () => CategoriesNotifier(container()),
        ),
        InheritedVanilla<AudioPlayerManager>(
          createNotifier: () => AudioPlayerManager(),
        ),
        InheritedVanilla<ManageAdminsNotifier>(
          createNotifier: () => ManageAdminsNotifier(container()),
        ),
      ],
      child: child,
    );
  }
}
