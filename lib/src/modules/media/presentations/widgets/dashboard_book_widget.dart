import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:jima/src/modules/media/domain/entities/books.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media_type.dart';
import 'package:jima/src/modules/media/presentations/cubits/books_notifier.dart';
import 'package:jima/src/modules/media/presentations/widgets/more_modal.dart';
import 'package:jima/src/modules/profile/domain/entities/user_privilege.dart';
import 'package:jima/src/modules/profile/presentation/cubits/user_cubit.dart';
import 'package:jima/src/tools/components/make_shimmer.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vanilla_state/vanilla_state.dart';

class DashboardBookWidgets extends StatefulWidget {
  const DashboardBookWidgets({super.key});

  @override
  State<DashboardBookWidgets> createState() => _DashboardBookWidgetsState();
}

class _DashboardBookWidgetsState extends State<DashboardBookWidgets> {
  @override
  Widget build(BuildContext context) {
    return VanillaBuilder<BooksNotifier, BooksState>(
      builder: (context, state) {
        final books = state.data?.items;
        if (state.isInLoading && books.isNullOrEmpty) {
          return const BooksLoader();
        }
        if (books == null || books.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.boxHeight,
            Row(
              children: [
                25.boxWidth,
                Text(
                  'Top Books',
                  style: Textstyles.bold.copyWith(
                    fontSize: 16.sp,
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => context.goNamed(AppRoute.books.name),
                  icon: const Icon(Icons.arrow_forward),
                ),
                17.boxWidth,
              ],
            ),
            16.boxHeight,
            UnconstrainedBox(
              child: SingleChildScrollView(
                padding: REdgeInsets.symmetric(horizontal: 26),
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 16.w,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...books.take(4).map((e) {
                      return BookItemWidget(book: e);
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class BooksLoader extends StatelessWidget {
  const BooksLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final itemWidth = 136.w;
    return MakeShimmer(
      child: Padding(
        padding: REdgeInsets.symmetric(vertical: 24),
        child: SizedBox(
          height: 258.h,
          child: SingleChildScrollView(
            padding: REdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 20.h,
              children: [
                24.boxHeight,
                ...List.generate(
                  4,
                  (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GreyBox(
                          width: 136.w,
                          height: 200.h,
                          borderRadius: 15.circularBorder,
                        ),
                        8.boxHeight,
                        GreyBox(
                          width: itemWidth.percent(100),
                          height: 21.h,
                        ),
                        8.boxHeight,
                        GreyBox(
                          width: itemWidth.percent(65),
                          height: 21.h,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookItemWidget extends StatelessWidget {
  final Book book;

  const BookItemWidget({
    super.key,
    required this.book,
  });

  Future<void> onPressed() async {
    container<MediaDataSource>().increaseMediaViewedCount(
      id: book.id,
      type: GenericMediaType.book,
    );
    launchUrl(
      Uri.parse(book.url),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: 16.circularBorder,
          child: SizedBox(
            width: 136.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: 4.circularBorder,
                  child: SizedBox(
                    height: 148.h,
                    width: 136.w,
                    child: Image.network(
                      book.thumbnail ?? NetworkImages.placeholder,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                8.boxHeight,
                Text(
                  book.title,
                  style: Textstyles.semibold.copyWith(
                    fontSize: 14.sp,
                    height: 1.3,
                    color: AppColors.buttonTextBlack,
                  ),
                ),
                Text(
                  book.minister.name,
                  style: Textstyles.normal.copyWith(
                    fontSize: 14.sp,
                    height: 1.3,
                    color: AppColors.darkGrey,
                  ),
                ),
                8.boxHeight,
                AppButton.primary(
                  padding: REdgeInsets.symmetric(vertical: 8.5),
                  borderRadius: 12.circularBorder,
                  onPressed: onPressed,
                  text: 'Buy Now',
                ),
              ],
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: container<UserNotifier>(),
          builder: (context, state, _) {
            if (state.data?.privilege != UserPrivilege.admin) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: REdgeInsets.all(4),
              child: InkWell(
                onTap: () => MoreModal.show(
                  book.id,
                  type: GenericMediaType.book,
                  mediaUrl: book.url,
                ),
                borderRadius: 40.circularBorder,
                child: ClipOval(
                  child: Container(
                    color: AppColors.black.withOpacity(0.4),
                    child: Padding(
                      padding: REdgeInsets.all(8),
                      child: const Icon(
                        Icons.more_vert_sharp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
