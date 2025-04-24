import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/donate/presentation/cubit/donation_cubit.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:jima/src/modules/media/domain/entities/audio_data.dart';
import 'package:vanilla_state/vanilla_state.dart';

class AudioDataNotifier extends BaseNotifier<AudioData> {
  final MediaDataSource _source;

  AudioDataNotifier(this._source)
      : super(InitialState(data: AudioData.initial()));

  Future<void> refresh() async {
    setInLoading();

    final result = await _source.fetchAudioData().tryCatch();

    return switch (result) {
      Right(:final value) => () {
          setSuccess(value.$1);
          container<DonationNotifier>().setData(value.$2);
        }(),
      Left(:final value) => setError(value.displayMessage),
    };
  }
}
