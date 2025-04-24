import 'package:equatable/equatable.dart';

class PaymentMethodValue with EquatableMixin {
  final String name;
  final String value;
  final bool canCopy;

  const PaymentMethodValue({
    required this.name,
    required this.value,
    required this.canCopy,
  });

  PaymentMethodValue copyWith({
    String? name,
    String? value,
    bool? canCopy,
  }) {
    return PaymentMethodValue(
      name: name ?? this.name,
      value: value ?? this.value,
      canCopy: canCopy ?? this.canCopy,
    );
  }

  @override
  List<Object> get props => [name, value, canCopy];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
      'canCopy': canCopy,
    };
  }

  factory PaymentMethodValue.fromMap(Map<String, dynamic> map) {
    return PaymentMethodValue(
      name: map['name'] as String,
      value: map['value'] as String,
      canCopy: map['canCopy'] as bool,
    );
  }
}
