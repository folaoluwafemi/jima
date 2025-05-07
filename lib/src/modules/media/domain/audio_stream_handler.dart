import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> playFromUrl(String url) async {
    await _player.setUrl(url);
    await _player.play();
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      playing: _player.playing,
      controls: [
        MediaControl.play,
        MediaControl.pause,
        MediaControl.stop,
      ],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }
}
