import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final details = <List<(String, String, bool)>>[
      [
        ('Bank name', 'Access bank', false),
        ('Account number', '00180770071', true),
        ('Account name', 'Champions royal assembly ', false),
      ],
      [
        ('PayPal', 'Joshuaiginla48821@gmail.com', true),
      ],
      [
        ('Bank name', 'Eco bank PLC', false),
        ('Account number', '4582043784', true),
        ('Account name', 'Champions royal assembly ', false),
      ],
      [
        ('Bank name', 'FNB', false),
        ('Account name', 'Champions royal assembly ', false),
        ('Account number', '63065448136', true),
      ],
      [
        ('SWIFT code', '05 0 0 8 1 0 3 7', true),
      ],
    ];

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
      body: SingleChildScrollView(
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
                            text: '${items.$1}: ',
                            children: [
                              TextSpan(
                                text: '${items.$2}  ',
                                style: Textstyles.bold.copyWith(
                                  fontSize: 14.sp,
                                  color: const Color(0xCC3E3E3E),
                                ),
                              ),
                              if (items.$3)
                                WidgetSpan(
                                  child: InkWell(
                                    onTap: () async {
                                      await Clipboard.setData(
                                        ClipboardData(text: items.$2),
                                      );
                                      if (!context.mounted) return;
                                      context.showSuccessToast('copied');
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
            100.boxHeight,
          ],
        ),
      ),
    );
  }
}
