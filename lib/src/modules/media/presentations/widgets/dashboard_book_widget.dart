import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/modules/media/domain/entities/books.dart';
import 'package:jima/src/modules/media/presentations/cubits/books_notifier.dart';
import 'package:jima/src/tools/components/make_shimmer.dart';
import 'package:jima/src/tools/tools_barrel.dart';
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
            SizedBox(
              height: 258.h,
              child: SingleChildScrollView(
                padding: REdgeInsets.symmetric(horizontal: 26),
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 16.w,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...books.take(4).map((e) {
                      return BookItemWidget(
                        book: e,
                        onPressed: () {},
                      );
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
  final VoidCallback onPressed;

  const BookItemWidget({
    super.key,
    required this.book,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 136.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: 15.circularBorder,
            child: SizedBox(
              height: 200.h,
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
              height: 1.5,
              color: AppColors.buttonTextBlack,
            ),
          ),
          8.boxHeight,
          Text(
            book.minister.name,
            style: Textstyles.normal.copyWith(
              fontSize: 14.sp,
              height: 1.5,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}
