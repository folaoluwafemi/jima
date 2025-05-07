// import 'package:audio_service/audio_service.dart';
// import 'package:flutter/material.dart';
// import 'package:jima/src/core/core.dart';
// import 'package:jima/src/modules/media/domain/audio_stream_handler.dart';
// import 'package:jima/src/modules/media/domain/entities/audio.dart';
//
// class AudioPlayerScreen extends StatelessWidget {
//   final Audio audio;
//
//   const AudioPlayerScreen({
//     Key? key,
//     required this.audio,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.blackVoid,
//       body: SafeArea(
//         child: Center(
//           child: SpotifyWebPlayerBridge(
//             spotifyTrackId: audio.url,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class AudioPlayerView extends StatefulWidget {
//   const AudioPlayerView({super.key});
//
//   @override
//   State<AudioPlayerView> createState() => _AudioPlayerViewState();
// }
//
// class _AudioPlayerViewState extends State<AudioPlayerView> {
//   MyAudioHandler? handler;
//
//   Future<void> initialize() async {
//     handler = await AudioService.init(
//       builder: () => MyAudioHandler(),
//       config: const AudioServiceConfig(
//         androidNotificationChannelId: 'com.dartgod.jima.jima',
//         androidNotificationChannelName: 'Audio playback',
//         androidNotificationOngoing: true,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget(child: const Placeholder());
//   }
// }
