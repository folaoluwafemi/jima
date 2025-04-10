import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef SearchAllMediaState = BaseState<List<GenericMedia>>;

class SearchAllMediaNotifier extends BaseNotifier<List<GenericMedia>> {
  final MediaDataSource _source;

  SearchAllMediaNotifier(this._source) : super(const InitialState(data: []));

  Future<void> search(String query) async {
    if (state.isInLoading) return;
    setInLoading();

    final result = await _source.searchMedia(query).tryCatch();


    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right(:final value) => setSuccess(value),
    };
  }
}
