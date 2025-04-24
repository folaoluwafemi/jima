import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/core/supabase_infra/auth_service.dart';
import 'package:jima/src/modules/auth/data/auth_source.dart';
import 'package:jima/src/modules/donate/presentation/cubit/donation_cubit.dart';
import 'package:jima/src/modules/media/presentations/cubits/audios_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/books_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/highest_viewed_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/videos_notifier.dart';
import 'package:jima/src/modules/media/presentations/widgets/dashboard_audio_widgets.dart';
import 'package:jima/src/modules/media/presentations/widgets/dashboard_book_widget.dart';
import 'package:jima/src/modules/media/presentations/widgets/dashboard_video_widgets.dart';
import 'package:jima/src/modules/media/presentations/widgets/highest_view_counts_widget.dart';
import 'package:jima/src/tools/constants/vectors.dart';
import 'package:jima/src/tools/extensions/extensions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) => fetchItems(),
    );
  }

  Future<void> fetchItems() async {
    container<HighestViewedNotifier>().fetchViewCount();
    container<VideosNotifier>().fetchVideos(fetchAFresh: true);
    container<AudiosNotifier>().fetchAudios(fetchAFresh: true);
    container<BooksNotifier>().fetchBooks(fetchAFresh: true);
    container<DonationNotifier>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Builder(
          builder: (context) {
            final user =
                container<SupabaseAuthService>().currentState?.userMetadata;
            final firstname = (user?['firstname'] ?? user?['firstName']);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello ${firstname ?? ''}'.trim(),
                  style: Textstyles.normal.copyWith(
                    height: 1.2,
                    fontSize: 13.sp,
                  ),
                ),
                Text(
                  'Welcome!',
                  style: Textstyles.bold.copyWith(
                    height: 1.35,
                    fontSize: 20.sp,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          if (container<SupabaseAuthService>().currentState == null ||
              container<AuthSource>().isUserAnonymous)
            TextButton(
              onPressed: () async {
                await container<AuthSource>().signOut();
                if (!context.mounted) return;
                context.goNamed(AppRoute.authAction.name);
              },
              child: Text(
                'Log out',
                style: Textstyles.medium.copyWith(
                  color: AppColors.red,
                ),
              ),
            ),
          12.boxWidth,
        ],
        bottom: PreferredSize(
          preferredSize: Size(context.screenWidth(), 48.h),
          child: Padding(
            padding: REdgeInsets.symmetric(horizontal: 16.w),
            child: RawMaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: 25.circularBorder,
              ),
              fillColor: AppColors.buttonGrey,
              onPressed: () => context.goNamed(AppRoute.allMediaSearch.name),
              elevation: 0,
              highlightElevation: 0,
              constraints: BoxConstraints(minHeight: 48.h),
              child: Padding(
                padding: REdgeInsets.symmetric(horizontal: 27.w),
                child: Row(
                  children: [
                    Vectors.searchIcon.vectorAssetWidget(),
                    15.boxWidth,
                    Text(
                      'Search your favorite Message ',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        height: 1.5,
                        color: AppColors.textHintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => unawaited(fetchItems()),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HighestViewedMediaView(),
              const DashboardVideoWidgets(),
              const DashboardAudioWidgets(),
              const DashboardBookWidgets(),
              100.boxHeight,
            ],
          ),
        ),
      ),
    );
  }
}
