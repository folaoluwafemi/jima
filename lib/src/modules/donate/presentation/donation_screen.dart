import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
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
              padding: REdgeInsets.fromLTRB(7, 8, 7, 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: 10.83.circularBorder,
                      color: AppColors.blue,
                    ),
                    padding: REdgeInsets.all(9),
                    child: Vectors.sendIcon.vectorAssetWidget(
                      dimension: 24.sp,
                    ),
                  ),
                  6.boxWidth,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target amount',
                        style: Textstyles.medium.copyWith(
                          fontSize: 12.sp,
                          height: 1.8,
                          color: const Color(0xFF373E49),
                        ),
                      ),
                      Text(
                        '\$15,000',
                        style: Textstyles.semibold.copyWith(
                          fontSize: 14.sp,
                          height: 1.8,
                          color: const Color(0xFF373E49),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            18.boxHeight,
            Padding(
              padding: REdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Lorem ipsum dolor sit amet consectetur. Lobortis elit donec '
                'tellus quis eleifend congue risus. Mauris duis eu lacus gravida'
                ' interdum nibh varius adipiscing. Viverra adipiscing blandit '
                'pulvinar ultrices ultrices in nunc feugiat. Mauris est turpis '
                'nec egestas. Ridiculus nibh bibendum nulla.',
                style: Textstyles.normal.copyWith(
                  fontSize: 14.sp,
                  height: 1.7857,
                  color: const Color(0xCC3E3E3E),
                ),
              ),
            ),
            32.boxHeight,
            Text(
              'Donation Details',
              style: Textstyles.bold.copyWith(
                height: 1.5,
                fontSize: 16.sp,
                color: const Color(0xFF3E3E3E),
              ),
            ),
            12.boxHeight,
            Text.rich(
              TextSpan(
                text: 'Bank name: ',
                children: [
                  TextSpan(
                    text: 'Wema Bank',
                    style: Textstyles.bold.copyWith(
                      fontSize: 14.sp,
                      color: const Color(0xCC3E3E3E),
                    ),
                  ),
                ],
              ),
              style: Textstyles.normal.copyWith(
                fontSize: 14.sp,
                color: const Color(0xCC3E3E3E),
              ),
            ),
            8.boxHeight,
            Text.rich(
              TextSpan(
                text: 'Account Number: ',
                children: [
                  TextSpan(
                    text: '0124698236  ',
                    style: Textstyles.bold.copyWith(
                      fontSize: 14.sp,
                      color: const Color(0xCC3E3E3E),
                    ),
                  ),
                  WidgetSpan(
                    child: InkWell(
                      onTap: () async {
                        await Clipboard.setData(
                          const ClipboardData(text: '0124698236'),
                        );
                        if (!context.mounted) return;
                        context.showSuccessToast('Account number copied');
                      },
                      child: Icon(
                        Icons.copy_all,
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
            8.boxHeight,
            Text.rich(
              TextSpan(
                text: 'Account Name: ',
                children: [
                  TextSpan(
                    text: 'Iginla Ministries',
                    style: Textstyles.bold.copyWith(
                      fontSize: 14.sp,
                      color: const Color(0xCC3E3E3E),
                    ),
                  ),
                ],
              ),
              style: Textstyles.normal.copyWith(
                fontSize: 14.sp,
                color: const Color(0xCC3E3E3E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
