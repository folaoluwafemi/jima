import 'package:flutter/material.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/media/data/media_data_source.dart';
import 'package:jima/src/modules/media/domain/entities/audio.dart';
import 'package:jima/src/modules/media/domain/entities/generic_media_type.dart';

class AudioPreviewScreen extends StatefulWidget {
  final Audio audio;

  const AudioPreviewScreen({
    super.key,
    required this.audio,
  });

  @override
  State<AudioPreviewScreen> createState() => _AudioPreviewScreenState();
}

class _AudioPreviewScreenState extends State<AudioPreviewScreen> {
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Placeholder(),
    );
  }
}
