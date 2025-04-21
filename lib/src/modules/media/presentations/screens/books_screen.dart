import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/media/presentations/cubits/books_notifier.dart';
import 'package:jima/src/modules/media/presentations/widgets/dashboard_book_widget.dart';
import 'package:jima/src/tools/components/make_shimmer.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  String query = '';

  Future<void> search(BuildContext context) async {
    if (query.isEmpty) {
      context.read<BooksNotifier>().fetchBooks(fetchAFresh: true);
      return;
    }
    context.read<BooksNotifier>().search(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10.h,
        bottom: PreferredSize(
          preferredSize: Size(context.screenWidth(), 48.h),
          child: Padding(
            padding: REdgeInsets.symmetric(horizontal: 16.w),
            child: Builder(
              builder: (context) {
                final border = OutlineInputBorder(
                  borderRadius: 25.circularBorder,
                  borderSide: BorderSide.none,
                );
                return TextField(
                  onChanged: (value) {
                    query = value;
                  },
                  maxLines: 1,
                  onSubmitted: (value) => search(context),
                  decoration: InputDecoration(
                    contentPadding: REdgeInsets.symmetric(horizontal: 26),
                    prefixIcon: IntrinsicWidth(
                      child: Align(
                        child: SizedBox.square(
                          dimension: 17.sp,
                          child: Vectors.searchIcon.vectorAssetWidget(),
                        ),
                      ),
                    ),
                    suffix: InkWell(
                      onTap: () => search(context),
                      child: Padding(
                        padding: REdgeInsets.all(4),
                        child: Text(
                          'Done',
                          style: Textstyles.normal.copyWith(
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.buttonGrey,
                    hintText: 'Search your favorite message',
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => unawaited(
          context.read<BooksNotifier>().fetchBooks(fetchAFresh: true),
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: REdgeInsets.only(bottom: 200),
          child: VanillaBuilder<BooksNotifier, BooksState>(
            builder: (context, state) {
              if (state.isInLoading) return const BooksLoader();
              final books = state.data?.items;

              if (books.isNullOrEmpty) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: REdgeInsets.symmetric(vertical: 120),
                        child: Text(
                          state is InitialState
                              ? 'Enter the query you want to search'
                              : 'No results!!!',
                          style: Textstyles.normal.copyWith(
                            fontSize: 16.sp,
                            color: AppColors.buttonTextBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  28.boxHeight,
                  Padding(
                    padding: REdgeInsets.symmetric(horizontal: 26),
                    child: Text(
                      'Books',
                      style: Textstyles.bold.copyWith(
                        fontSize: 32.sp,
                        height: 1.5,
                      ),
                    ),
                  ),
                  20.boxHeight,
                  Builder(
                    builder: (context) {
                      // final itemWidth = (context.screenWidth() - 328.w) / 2;
                      return Padding(
                        padding: REdgeInsets.symmetric(horizontal: 26),
                        child: Wrap(
                          runSpacing: 36.w,
                          spacing: context.screenWidth() - 328.w,
                          children: [
                            ...books!.map(
                              (e) => BookItemWidget(book: e),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
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
        padding: REdgeInsets.symmetric(vertical: 24, horizontal: 36),
        child: SizedBox(
          height: 258.h,
          child: Wrap(
            runSpacing: 20.w,
            spacing: context.screenWidth() - 348.w,
            children: [
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
    );
  }
}
