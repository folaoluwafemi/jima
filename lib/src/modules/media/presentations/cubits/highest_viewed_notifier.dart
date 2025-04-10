import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef HighestViewedState = BaseState<GenericMedia?>;

class HighestViewedNotifier extends BaseNotifier<GenericMedia?> {
  final MediaDataSource _source;

  HighestViewedNotifier(this._source) : super(const InitialState());

  Future<void> fetchViewCount() async {
    setInLoading();

    final result = await _source.fetchHighestViewCountItem().tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right(:final value) => setSuccess(value),
    };
  }
}
