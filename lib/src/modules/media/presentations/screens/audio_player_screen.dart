import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/media/domain/entities/audio.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AudioPlayerScreen extends StatelessWidget {
  final Audio audio;

  const AudioPlayerScreen({
    Key? key,
    required this.audio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackVoid,
      body: SafeArea(
        child: Center(
          child: SpotifyWebPlayerBridge(
            spotifyTrackId: audio.url,
          ),
        ),
      ),
    );
  }
}

class SpotifyWebPlayerBridge extends StatefulWidget {
  final String spotifyTrackId;

  const SpotifyWebPlayerBridge({Key? key, required this.spotifyTrackId})
      : super(key: key);

  @override
  _SpotifyWebPlayerBridgeState createState() => _SpotifyWebPlayerBridgeState();
}

class _SpotifyWebPlayerBridgeState extends State<SpotifyWebPlayerBridge> {
  late WebViewController _webViewController;
  bool _isPlayerReady = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _setupWebView();
  }

  void _setupWebView() {
    // Create a JavaScript channel for communication
    // final javascriptChannel = JavascriptChannel(
    //     name: 'SpotifyController',
    //     onMessageReceived: (JavaScriptMessage message) {
    //       final data = jsonDecode(message.message);
    //
    //       // Handle different events from the web player
    //       switch (data['event']) {
    //         case 'ready':
    //           setState(() => _isPlayerReady = true);
    //           break;
    //         case 'play':
    //           setState(() => _isPlaying = true);
    //           break;
    //         case 'pause':
    //           setState(() => _isPlaying = false);
    //           break;
    //         case 'error':
    //           print('Spotify player error: ${data['message']}');
    //           break;
    //       }
    //     }
    // );

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'SpotifyController',
        onMessageReceived: (message) {
          final data = jsonDecode(message.message);

          // Handle different events from the web player
          switch (data['event']) {
            case 'ready':
              setState(() => _isPlayerReady = true);
              _playTrack(widget.spotifyTrackId);
              break;
            case 'play':
              setState(() => _isPlaying = true);
              break;
            case 'pause':
              setState(() => _isPlaying = false);
              break;
            case 'error':
              print('Spotify player error: ${data['message']}');
              break;
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            // Initialize the player once page is loaded
            _initializePlayer();
          },
        ),
      )
      ..loadHtmlString(_buildPlayerHtml());
  }

  String _buildPlayerHtml() {
    // This HTML page loads the Spotify Web Playback SDK
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Spotify Web Playback</title>
        <style>
          body { margin: 0; padding: 0; background: transparent; }
        </style>
      </head>
      <body>
        <script src="https://sdk.scdn.co/spotify-player.js"></script>
        <script>
          // Spotify Web Player SDK
          window.onSpotifyWebPlaybackSDKReady = () => {
            // Replace with your actual Spotify Client ID
            const token = 'YOUR_SPOTIFY_TOKEN';
            const player = new Spotify.Player({
              name: 'Flutter Spotify Player',
              getOAuthToken: cb => { cb(token); }
            });
            
            // Connect to the player
            player.connect().then(success => {
              if (success) {
                SpotifyController.postMessage(JSON.stringify({
                  event: 'ready',
                  message: 'Player connected'
                }));
              }
            });
            
            // Handle player state changes
            player.addListener('player_state_changed', state => {
              if (state && state.paused) {
                SpotifyController.postMessage(JSON.stringify({
                  event: 'pause',
                  position: state.position
                }));
              } else if (state) {
                SpotifyController.postMessage(JSON.stringify({
                  event: 'play',
                  position: state.position
                }));
              }
            });
            
            // Handle errors
            player.addListener('initialization_error', ({ message }) => {
              SpotifyController.postMessage(JSON.stringify({
                event: 'error',
                message: message
              }));
            });
            
            // Make player global
            window.spotifyPlayer = player;
          };
          
          // Function to play a track (will be called from Flutter)
          function playTrack(trackId) {
            if (window.spotifyPlayer) {
              window.spotifyPlayer.play({
                spotify_uri: 'spotify:track:' + trackId
              });
            }
          }
          
          // Function to pause playback
          function pausePlayback() {
            if (window.spotifyPlayer) {
              window.spotifyPlayer.pause();
            }
          }
          
          // Function to resume playback
          function resumePlayback() {
            if (window.spotifyPlayer) {
              window.spotifyPlayer.resume();
            }
          }
        </script>
      </body>
      </html>
    ''';
  }

  void _initializePlayer() {
    // Nothing to do here - the HTML will call back when ready
  }

  void _playTrack(String trackId) {
    if (_isPlayerReady) {
      _webViewController.runJavaScript('playTrack("$trackId")');
    }
  }

  void _togglePlayPause() {
    if (_isPlayerReady) {
      if (_isPlaying) {
        _webViewController.runJavaScript('pausePlayback()');
      } else {
        _webViewController.runJavaScript('resumePlayback()');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hidden WebView - give it minimal size but keep it in the widget tree
        SizedBox(
          height: 1,
          width: 1,
          child: Opacity(
            opacity: 0.01, // Nearly invisible but still active
            child: WebViewWidget(controller: _webViewController),
          ),
        ),

        // Custom player controls
        if (_isPlayerReady)
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Spotify Podcast',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                      ),
                      iconSize: 48,
                      onPressed: _togglePlayPause,
                    ),
                  ],
                ),
              ],
            ),
          )
        else
          const Center(
            child: CircularProgressIndicator(
              value: 0.4,
            ),
          ),
      ],
    );
  }
}
