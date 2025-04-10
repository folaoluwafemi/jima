import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/media/presentations/cubits/search_all_media_notifier.dart';
import 'package:jima/src/modules/media/presentations/widgets/generic_widgets.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class AllMediaSearchScreen extends StatefulWidget {
  const AllMediaSearchScreen({super.key});

  @override
  State<AllMediaSearchScreen> createState() => _AllMediaSearchScreenState();
}

class _AllMediaSearchScreenState extends State<AllMediaSearchScreen> {
  String query = '';

  Future<void> search(BuildContext context) async {
    context.read<SearchAllMediaNotifier>().search(query);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedVanilla<SearchAllMediaNotifier>(
      createNotifier: () => SearchAllMediaNotifier(container()),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: PreferredSize(
            preferredSize: Size(context.screenWidth(), 48.h),
            child: Row(
              children: [
                const BackButton(),
                Expanded(
                  child: Padding(
                    padding: REdgeInsets.only(right: 16.w),
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
                            contentPadding:
                                REdgeInsets.symmetric(horizontal: 26),
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
              ],
            ),
          ),
        ),
        body: VanillaListener<SearchAllMediaNotifier, SearchAllMediaState>(
          listener: (previous, current) => handleErrorCase(
            previous,
            current,
            context: context,
            callback: (previous, current) {
              if (current.isSuccess) {}
            },
          ),
          child: VanillaBuilder<SearchAllMediaNotifier, SearchAllMediaState>(
            builder: (context, state) {
              if (state.isInLoading) {
                return const GenericMediasLoader();
              }

              final items = state.data ?? [];

              if (items.isNullOrEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: REdgeInsets.symmetric(vertical: 120),
                        child: Text(
                          state is InitialState
                              ? 'Enter the query you want to search'
                              : 'No search results!!!',
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

              return ListView.separated(
                padding: REdgeInsets.symmetric(horizontal: 25, vertical: 20),
                itemCount: items.length,
                separatorBuilder: (context, index) => 22.boxHeight,
                itemBuilder: (context, index) {
                  return GenericMediaItemWidget(genericMedia: items[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
