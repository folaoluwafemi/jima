import 'package:equatable/equatable.dart';
import 'package:jima/src/modules/donate/domain/entities/payment_method_value.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class DonationData with EquatableMixin {
  final String targetAmount;
  final String description;
  final List<List<PaymentMethodValue>> paymentGroup;

  const DonationData({
    required this.targetAmount,
    required this.description,
    required this.paymentGroup,
  });

  @override
  List<Object> get props => [targetAmount, description, paymentGroup];

  Map<String, dynamic> toMap() {
    return {
      'targetAmount': targetAmount,
      'description': description,
      'paymentGroup': paymentGroup.map((e) {
        return e.map((e2) => e2.toMap()).toList();
      }).toList(),
    };
  }

  factory DonationData.fromMap(Map<String, dynamic> map) {
    return DonationData(
      targetAmount: map['targetAmount'] as String,
      description: map['description'] as String,
      paymentGroup: [
        for (final item in (map['paymentGroup'] as List? ?? []))
          ParseUtils.parseMapArray(
            item as List,
            mapper: PaymentMethodValue.fromMap,
          ),
      ],
    );
  }
}
