import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/donate/domain/entities/donation_data.dart';
import 'package:jima/src/modules/donate/domain/entities/payment_method_value.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef DonationState = BaseState<DonationData?>;

class DonationNotifier extends BaseNotifier<DonationData?> {
  final MediaDataSource _source;

  DonationNotifier(this._source) : super(const InitialState(data: null));

  Future<void> uploadData({
    required String targetAmount,
    required String description,
    required List<List<PaymentMethodValue>> paymentGroup,
  }) async {
    final data = DonationData(
      targetAmount: targetAmount,
      description: description,
      paymentGroup: paymentGroup,
    );

    setOutLoading();

    final result = await _source.uploadDonationData(data).tryCatch();

    return switch (result) {
      Right() => setSuccess(this.data),
      Left(:final value) => setError(value.displayMessage),
    };
  }

  Future<void> refresh() async {
    setInLoading();

    final result = await _source.fetchDonationData().tryCatch();

    return switch (result) {
      Right(:final value) => setInitial(value),
      Left(:final value) => setError(value.displayMessage),
    };
  }
}
