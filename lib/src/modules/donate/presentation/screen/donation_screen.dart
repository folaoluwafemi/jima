import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/donate/presentation/cubit/donation_cubit.dart';
import 'package:jima/src/tools/components/make_shimmer.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InheritedVanilla<DonationNotifier>(
      createNotifier: () => container<DonationNotifier>()..refresh(),
      shouldDispose: false,
      isLazy: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Donate',
            style: Textstyles.bold.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
              height: 1.5,
              color: AppColors.blackVoid,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: container<DonationNotifier>().refresh,
          child: VanillaBuilder<DonationNotifier, DonationState>(
            builder: (context, state) {
              final details = state.data?.paymentGroup ?? [];
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: REdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    18.boxHeight,
                    ClipRRect(
                      borderRadius: 21.circularBorder,
                      child: Images.donationImage.imageAssetWidget(
                        height: 142.h,
                        width: context.screenWidth(),
                        fit: BoxFit.cover,
                      ),
                    ),
                    32.boxHeight,
                    if (state.isInLoading)
                      const DonationDataLoading()
                    else ...[
                      if (state.data?.description.nullIfEmpty != null) ...[
                        Text(
                          ' Joshua Iginla Ministries',
                          style: Textstyles.bold.copyWith(
                            height: 1.5,
                            fontSize: 16.sp,
                            color: const Color(0xFF3E3E3E),
                          ),
                        ),
                        22.boxHeight,
                        Padding(
                          padding: REdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            state.data?.description ?? '',
                            style: Textstyles.normal.copyWith(
                              fontSize: 14.sp,
                              height: 1.7857,
                              color: const Color(0xCC3E3E3E),
                            ),
                          ),
                        ),
                        32.boxHeight,
                      ],
                      Text(
                        'Donation Details',
                        style: Textstyles.bold.copyWith(
                          height: 1.5,
                          fontSize: 16.sp,
                          color: const Color(0xFF3E3E3E),
                        ),
                      ),
                      12.boxHeight,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 24.h,
                        children: [
                          ...details.map(
                            (e) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8.h,
                              children: [
                                ...e.map(
                                  (items) => Text.rich(
                                    TextSpan(
                                      text: '${items.name}: ',
                                      children: [
                                        TextSpan(
                                          text: '${items.value}  ',
                                          style: Textstyles.bold.copyWith(
                                            fontSize: 14.sp,
                                            color: const Color(0xCC3E3E3E),
                                          ),
                                        ),
                                        if (items.canCopy)
                                          WidgetSpan(
                                            child: InkWell(
                                              onTap: () async {
                                                await Clipboard.setData(
                                                  ClipboardData(
                                                    text: items.value,
                                                  ),
                                                );
                                                if (!context.mounted) return;
                                                context
                                                    .showSuccessToast('copied');
                                              },
                                              child: Icon(
                                                Icons.copy,
                                                size: 18.sp,
                                                color: const Color(0xCC3E3E3E),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    style: Textstyles.normal.copyWith(
                                      fontSize: 14.sp,
                                      color: const Color(0xCC3E3E3E),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    100.boxHeight,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DonationDataLoading extends StatelessWidget {
  const DonationDataLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return MakeShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GreyBox(
            height: 20.h,
            width: context.screenWidth(),
          ),
          12.boxHeight,
          GreyBox(
            height: 148.h,
            width: context.screenWidth(),
          ),
          GreyBox(
            height: 30.h,
            width: context.screenWidth(percent: 0.7),
          ),
          48.boxHeight,
          Row(
            children: [
              GreyBox(
                height: 20.h,
                width: context.screenWidth(percent: 0.2),
              ),
              8.boxWidth,
              GreyBox(
                height: 20.h,
                width: context.screenWidth(percent: 0.4),
              ),
            ],
          ),
          8.boxHeight,
          Row(
            children: [
              GreyBox(
                height: 20.h,
                width: context.screenWidth(percent: 0.25),
              ),
              8.boxWidth,
              GreyBox(
                height: 20.h,
                width: context.screenWidth(percent: 0.4),
              ),
            ],
          ),
          8.boxHeight,
          Row(
            children: [
              GreyBox(
                height: 20.h,
                width: context.screenWidth(percent: 0.2),
              ),
              8.boxWidth,
              GreyBox(
                height: 20.h,
                width: context.screenWidth(percent: 0.4),
              ),
            ],
          ),
          24.boxHeight,
          Row(
            children: [
              GreyBox(
                height: 20.h,
                width: context.screenWidth(percent: 0.25),
              ),
              8.boxWidth,
              GreyBox(
                height: 20.h,
                width: context.screenWidth(percent: 0.4),
              ),
            ],
          ),
          8.boxHeight,
          Row(
            children: [
              GreyBox(
                height: 20.h,
                width: context.screenWidth(percent: 0.2),
              ),
              8.boxWidth,
              GreyBox(
                height: 20.h,
                width: context.screenWidth(percent: 0.4),
              ),
            ],
          ),
          8.boxHeight,
          Row(
            children: [
              GreyBox(
                height: 20.h,
                width: context.screenWidth(percent: 0.25),
              ),
              8.boxWidth,
              GreyBox(
                height: 20.h,
                width: context.screenWidth(percent: 0.4),
              ),
            ],
          ),
          24.boxHeight,
        ],
      ),
    );
  }
}
