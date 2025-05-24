import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:jima/src/modules/media/domain/entities/audio.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media_type.dart';
import 'package:jima/src/modules/media/presentations/cubits/audio_player_manager.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vanilla_state/vanilla_state.dart';

class AudioPlayerScreen extends StatefulWidget {
  final Audio audio;

  const AudioPlayerScreen({super.key, required this.audio});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late final _player =
      context.read<AudioPlayerManager>().getPlayerForAudio(widget.audio);

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
    updateViewCount();
  }

  Future<void> updateViewCount() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    container<MediaDataSource>().increaseMediaViewedCount(
      id: widget.audio.id,
      type: GenericMediaType.audio,
    );
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    await Future.delayed(const Duration(milliseconds: 100));
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
                      activeColor: AppColors.blue,
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
                IconButton(
                  icon: const Icon(Icons.fast_rewind_outlined),
                  onPressed: () => _player.seek(
                    _player.position - const Duration(seconds: 10),
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.blue,
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
              ],
            ),
          ],
        ),
      ),
    );
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
