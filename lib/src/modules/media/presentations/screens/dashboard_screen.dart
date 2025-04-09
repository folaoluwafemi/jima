import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/supabase_infra/auth_service.dart';
import 'package:jima/src/modules/media/presentations/cubits/all_view_count_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/audios_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/books_notifier.dart';
import 'package:jima/src/modules/media/presentations/cubits/videos_notifier.dart';
import 'package:jima/src/modules/media/presentations/widgets/all_view_counts_widget.dart';
import 'package:jima/src/modules/media/presentations/widgets/dashboard_audio_widgets.dart';
import 'package:jima/src/modules/media/presentations/widgets/dashboard_book_widget.dart';
import 'package:jima/src/modules/media/presentations/widgets/dashboard_video_widgets.dart';
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
    fetchItems();
  }

  Future<void> fetchItems() async {
    container<HighestViewedNotifier>().fetchViewCount();
    container<VideosNotifier>().fetchVideos(fetchAFresh: true);
    container<AudiosNotifier>().fetchAudios(fetchAFresh: true);
    container<BooksNotifier>().fetchBooks(fetchAFresh: true);
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
        bottom: PreferredSize(
          preferredSize: Size(context.screenWidth(), 48.h),
          child: Padding(
            padding: REdgeInsets.symmetric(horizontal: 16.w),
            child: RawMaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: 25.circularBorder,
              ),
              fillColor: AppColors.buttonGrey,
              onPressed: () {},
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => unawaited(fetchItems()),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HighestViewedMediaView(),
                DashboardVideoWidgets(),
                DashboardAudioWidgets(),
                DashboardBookWidgets(),
                100.boxHeight,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
