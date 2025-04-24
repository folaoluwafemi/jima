import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/donate/domain/entities/payment_method_value.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class AddPaymentWidget extends StatefulWidget {
  final List<PaymentMethodValue>? initialItems;

  const AddPaymentWidget({super.key, this.initialItems});

  @override
  State<AddPaymentWidget> createState() => _AddPaymentWidgetState();
}

class _AddPaymentWidgetState extends State<AddPaymentWidget> {
  final editModeNotifier = ValueNotifier<PaymentMethodValue?>(null);
  late List<PaymentMethodValue> paymentDetails = widget.initialItems ?? [];

  @override
  void dispose() {
    editModeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: REdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          24.boxHeight,
          Row(
            children: [
              const Spacer(),
              Text(
                'Add Payment Detail',
                style: Textstyles.medium.copyWith(
                  height: 1.5,
                  fontSize: 18.sp,
                  color: AppColors.black700,
                ),
              ),
              const Spacer(),
              RawMaterialButton(
                onPressed: () => context.pop(paymentDetails),
                fillColor: context.colorScheme.primary,
                elevation: 0,
                highlightElevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: 8.circularBorder,
                ),
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: REdgeInsets.symmetric(
                    horizontal: 25.w,
                    vertical: 10.h,
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          24.boxHeight,
          Container(
            decoration: BoxDecoration(
              color: AppColors.grey400.withOpacity(0.3),
              borderRadius: 12.circularBorder,
            ),
            padding: REdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8.h,
              children: [
                Text(
                  'Payment Methods',
                  style: Textstyles.semibold.copyWith(
                    height: 1.5,
                    fontSize: 14.sp,
                    color: AppColors.blackVoid,
                  ),
                ),
                if (paymentDetails.isEmpty)
                  Padding(
                    padding: REdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        '+ Use the form below to add items',
                        style: Textstyles.normal.copyWith(
                          height: 1.5,
                          fontSize: 14.sp,
                          color: AppColors.blackVoid.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ...paymentDetails.map(
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
                                  ClipboardData(text: items.value),
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
          30.boxHeight,
          ValueListenableBuilder<PaymentMethodValue?>(
            valueListenable: editModeNotifier,
            builder: (context, value, _) {
              return TextFieldSection(
                key: ValueKey(value),
                title: value?.name ?? '',
                value: value?.value ?? '',
                canCopy: value?.canCopy ?? false,
                onItemsAdded: (PaymentMethodValue? value) {
                  if (value != null) {
                    paymentDetails = paymentDetails.copyAdd(value);
                    setState(() {});
                  }
                  editModeNotifier.value = null;
                },
              );
            },
          ),
          24.boxHeight,
          context.bottomScreenPadding.boxHeight,
        ],
      ),
    );
  }
}

class TextFieldSection extends StatefulWidget {
  final String title;
  final String value;
  final bool canCopy;
  final ValueChanged<PaymentMethodValue?> onItemsAdded;

  const TextFieldSection({
    super.key,
    required this.title,
    required this.value,
    required this.canCopy,
    required this.onItemsAdded,
  });

  @override
  State<TextFieldSection> createState() => _TextFieldSectionState();
}

class _TextFieldSectionState extends State<TextFieldSection> {
  late final titleController = TextEditingController(text: widget.title);
  late final valueController = TextEditingController(text: widget.value);
  late bool canCopyValue = widget.canCopy;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField.text(
            labelText: 'Payment type name',
            hintText: 'E.g Account number',
            controller: titleController,
            maxLines: 1,
          ),
          16.boxHeight,
          AppTextField.text(
            labelText: 'Payment type value',
            hintText: 'E.g 123456798',
            maxLines: 1,
            controller: valueController,
          ),
          16.boxHeight,
          Row(
            children: [
              SizedBox(
                height: 28.h,
                child: FittedBox(
                  child: CupertinoSwitch(
                    value: canCopyValue,
                    activeTrackColor: AppColors.black700,
                    onChanged: (value) => setState(() {
                      canCopyValue = !canCopyValue;
                    }),
                  ),
                ),
              ),
              12.boxWidth,
              InkWell(
                onTap: () => setState(() {
                  canCopyValue = !canCopyValue;
                }),
                child: Text(
                  'Allow users to copy text',
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          16.boxHeight,
          RawMaterialButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              final validate = formKey.currentState?.validate();
              if (validate != true) return;
              widget.onItemsAdded(
                PaymentMethodValue(
                  name: titleController.text,
                  value: valueController.text,
                  canCopy: canCopyValue,
                ),
              );
              titleController.clear();
              valueController.clear();
              canCopyValue = false;
              setState(() {});
            },
            fillColor: AppColors.black700,
            elevation: 0,
            highlightElevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: 8.circularBorder,
              side: BorderSide(width: 1.sp),
            ),
            visualDensity: const VisualDensity(
              horizontal: -4,
              vertical: -4,
            ),
            padding: EdgeInsets.zero,
            child: Padding(
              padding: REdgeInsets.symmetric(
                horizontal: 25.w,
                vertical: 10.h,
              ),
              child: Text(
                'Add',
                style: TextStyle(
                  height: 1.5,
                  fontSize: 14.sp,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
