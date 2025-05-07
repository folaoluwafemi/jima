import 'package:jima/src/modules/media/domain/entities/audio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vanilla_state/vanilla_state.dart';

class AudioPlayerState {
  final AudioPlayer player;
  final Audio audio;

  const AudioPlayerState({
    required this.player,
    required this.audio,
  });
}

class AudioPlayerManager extends VanillaNotifier<AudioPlayerState?> {
  AudioPlayerManager() : super(null);

  AudioPlayer getPlayerForAudio(Audio audio) {
    if (audio.id == state?.audio.id) return state!.player;
    if (state != null) releaseResources();
    final player = createAudioPlayerFor(audio);
    state = AudioPlayerState(
      player: player,
      audio: audio,
    );

    return state!.player;
  }

  void releaseResources() {
    state?.player.dispose();
    state = null;
  }

  AudioPlayer createAudioPlayerFor(Audio audio) {
    final player = AudioPlayer();
    player.setAudioSource(
      AudioSource.uri(
        Uri.parse(audio.url),
        tag: MediaItem(
          id: audio.id,
          title: audio.title,
          artUri: Uri.tryParse(audio.thumbnail ?? ''),
        ),
      ),
    );
    return player;
  }

  @override
  void dispose() {
    releaseResources();
    super.dispose();
  }
}
