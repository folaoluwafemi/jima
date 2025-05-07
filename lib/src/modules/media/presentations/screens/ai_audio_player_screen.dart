import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:jima/src/modules/media/domain/entities/audio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerScreen extends StatefulWidget {
  final Audio audio;

  const AudioPlayerScreen({super.key, required this.audio});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();

  StreamSubscription? positionSub;

  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
        _player.positionStream,
        _player.durationStream,
        (position, duration) => DurationState(
          position: position,
          total: duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    // Enable background playback
    if (!AudioService.running) {
      AudioService.start(
        backgroundTaskEntrypoint: _backgroundTaskEntrypoint,
        androidNotificationChannelName: 'Audio Playback',
        androidNotificationColor: 0xFF2196F3,
        androidNotificationIcon: 'mipmap/ic_launcher',
      );
    }

    // Restore playback position if available
    await _player.setUrl(widget.audio.url);
    positionSub = AudioService.position.listen(
      (position) => _player.seek(position),
    );

    _player.play();
  }

  @override
  void dispose() {
    positionSub?.cancel();
    AudioService.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Audio Player',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.audio.thumbnail ?? '',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 250,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.music_note, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.audio.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.audio.minister.name,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            StreamBuilder<DurationState>(
              stream: _durationStateStream,
              builder: (context, snapshot) {
                final position = snapshot.data?.position ?? Duration.zero;
                final total = snapshot.data?.total ?? Duration.zero;
                return Column(
                  children: [
                    Slider(
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey.shade300,
                      min: 0,
                      max: total.inMilliseconds.toDouble(),
                      value: position.inMilliseconds
                          .clamp(0, total.inMilliseconds)
                          .toDouble(),
                      onChanged: (value) =>
                          _player.seek(Duration(milliseconds: value.toInt())),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatTime(position)),
                          Text('-${_formatTime(total - position)}'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.repeat, color: Colors.grey),
                IconButton(
                  icon: const Icon(Icons.fast_rewind_outlined),
                  onPressed: () => _player.seek(
                    _player.position - const Duration(seconds: 10),
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  child: StreamBuilder<bool>(
                    stream: _player.playingStream,
                    builder: (context, snapshot) {
                      final isPlaying = snapshot.data ?? false;
                      return IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () =>
                            isPlaying ? _player.pause() : _player.play(),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.fast_forward_outlined),
                  onPressed: () => _player.seek(
                    _player.position + const Duration(seconds: 10),
                  ),
                ),
                const Icon(Icons.shuffle, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Background task entry point
  void _backgroundTaskEntrypoint() {
    AudioServiceBackground.run(() => AudioPlayerTask());
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

class DurationState {
  final Duration position;
  final Duration total;

  DurationState({required this.position, required this.total});
}

// Background audio task
class AudioPlayerTask extends BackgroundAudioTask {
  final _player = AudioPlayer();
  StreamSubscription? positionSub;

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    await _player.setUrl(params?['url']);
    _player.play();
    positionSub = _player.positionStream.listen((position) {
      AudioServiceBackground.setState(
        controls: [
          MediaControl.pause,
          MediaControl.play,
          MediaControl.stop,
        ],
        position: position,
        playing: _player.playing,
      );
    });
  }

  @override
  Future<void> onPlay() => _player.play();

  @override
  Future<void> onPause() => _player.pause();

  @override
  Future<void> onSeekTo(Duration position) => _player.seek(position);

  @override
  Future<void> onStop() async {
    await _player.stop();
    positionSub?.cancel();
    await super.onStop();
  }
}
