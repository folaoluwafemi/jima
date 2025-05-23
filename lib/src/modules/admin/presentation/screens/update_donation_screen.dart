import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/admin/presentation/widget/add_payment_widget.dart';
import 'package:jima/src/modules/donate/domain/entities/donation_data.dart';
import 'package:jima/src/modules/donate/domain/entities/payment_method_value.dart';
import 'package:jima/src/modules/donate/presentation/cubit/donation_cubit.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class UpdateDonationScreen extends StatefulWidget {
  const UpdateDonationScreen({super.key});

  @override
  State<UpdateDonationScreen> createState() => _UpdateDonationScreenState();
}

class _UpdateDonationScreenState extends State<UpdateDonationScreen> {
  @override
  Widget build(BuildContext context) {
    return InheritedVanilla<DonationNotifier>(
      isLazy: false,
      shouldDispose: false,
      createNotifier: () => container()..refresh(),
      child: VanillaBuilder<DonationNotifier, DonationState>(
        builder: (context, state) {
          return UploadDonationView(data: state.data);
        },
      ),
    );
  }
}

class UploadDonationView extends StatefulWidget {
  final DonationData? data;

  const UploadDonationView({
    super.key,
    required this.data,
  });

  @override
  State<UploadDonationView> createState() => _UploadDonationViewState();
}

class _UploadDonationViewState extends State<UploadDonationView> {
  late final descriptionController = TextEditingController(
    text: widget.data?.description,
  );
  late final paymentDetailsNotifier =
      ValueNotifier<List<List<PaymentMethodValue>>>(
    widget.data?.paymentGroup ?? [],
  );

  @override
  void dispose() {
    descriptionController.dispose();
    paymentDetailsNotifier.dispose();
    super.dispose();
  }

  Future<void> showEditModal({
    List<PaymentMethodValue>? initialItems,
  }) async {
    final value = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddPaymentWidget(
        initialItems: initialItems,
      ),
    );

    if (initialItems != null && value != null) {
      paymentDetailsNotifier.value = paymentDetailsNotifier.value.copyRemove(
        initialItems,
      );
    }

    paymentDetailsNotifier.value = paymentDetailsNotifier.value.copyAdd(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.blue,
        centerTitle: true,
        title: Text(
          'Update Donation',
          style: Textstyles.extraBold.copyWith(
            fontSize: 14.sp,
            color: AppColors.blackVoid,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: REdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.boxHeight,
                  SizedBox(
                    height: 178.h,
                    child: AppTextField.text(
                      maxLines: null,
                      controller: descriptionController,
                      expands: true,
                      labelText: 'Description',
                      hintText: 'Enter a description of the donation target',
                    ),
                  ),
                  30.boxHeight,
                  ValueListenableBuilder<List<List<PaymentMethodValue>>>(
                    valueListenable: paymentDetailsNotifier,
                    builder: (context, value, _) {
                      return DetailsWidget(
                        details: value,
                        onEditPressed: (value) => showEditModal(
                          initialItems: value,
                        ),
                        onDeletePressed: (value) {
                          paymentDetailsNotifier.value =
                              paymentDetailsNotifier.value.copyRemove(value);
                        },
                      );
                    },
                  ),
                  RawMaterialButton(
                    onPressed: showEditModal,
                    shape: RoundedRectangleBorder(
                      borderRadius: 8.circularBorder,
                      side: BorderSide(
                        color: AppColors.black700,
                        width: 1.sp,
                      ),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add,
                            color: AppColors.black700,
                          ),
                          10.boxWidth,
                          Text(
                            'Add Payment Details',
                            style: TextStyle(
                              height: 1.5,
                              fontSize: 14.sp,
                              color: AppColors.black700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  54.boxHeight,
                ],
              ),
            ),
          ),
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 30),
            child: VanillaListener<DonationNotifier, DonationState>(
              listener: (previous, current) {
                if (current.isSuccess) {
                  context.showSuccessToast('Updated data successfully');
                  container<DonationNotifier>().refresh();
                }
                if (current case ErrorState(:final message)) {
                  context.pop();
                  context.showErrorToast(message);
                }
              },
              child: VanillaBuilder<DonationNotifier, DonationState>(
                builder: (context, state) {
                  return AppButton.primary(
                    loading: state.isInLoading || state.isOutLoading,
                    onPressed: () {
                      context.read<DonationNotifier>().uploadData(
                            description: descriptionController.text,
                            paymentGroup: paymentDetailsNotifier.value,
                          );
                    },
                    text: 'Done',
                  );
                },
              ),
            ),
          ),
          24.boxHeight,
          context.bottomScreenPadding.boxHeight,
        ],
      ),
    );
  }
}

class DetailsWidget extends StatelessWidget {
  final List<List<PaymentMethodValue>> details;
  final ValueChanged<List<PaymentMethodValue>> onEditPressed;
  final ValueChanged<List<PaymentMethodValue>> onDeletePressed;

  const DetailsWidget({
    super.key,
    required this.details,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...details.map(
          (e) {
            return Padding(
              padding: REdgeInsets.only(bottom: 24),
              child: InkWell(
                onTap: () => onEditPressed(e),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    InkWell(
                      onTap: () => onDeletePressed(e),
                      borderRadius: 40.circularBorder,
                      child: Padding(
                        padding: REdgeInsets.all(6),
                        child: Icon(
                          Icons.delete,
                          size: 24.sp,
                          color: AppColors.blackVoid,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
