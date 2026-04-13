/// Schermata per riprodurre audio con controlli
library;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/constants/app_constants.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String? audioPath;

  const AudioPlayerScreen({super.key, this.audioPath});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  String? _currentAudioPath;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    if (widget.audioPath != null) {
      _loadAudio(widget.audioPath!);
    }
  }

  Future<void> _loadAudio(String audioPath) async {
    try {
      _currentAudioPath = audioPath;

      // Determina se è un file locale o URL
      if (audioPath.startsWith('http')) {
        await _audioPlayer.setUrl(audioPath);
      } else {
        await _audioPlayer.setFilePath(audioPath);
      }

      setState(() {
        _isInitialized = true;
      });

      // Auto-play
      _audioPlayer.play();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore caricamento audio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
      ),
      body: _isInitialized
          ? StreamBuilder<PlayerState>(
              stream: _audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing ?? false;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icona audio
                    Icon(
                      Icons.music_note,
                      size: 120,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 32),

                    // Controlli di riproduzione
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultPadding,
                      ),
                      child: StreamBuilder<Duration?>(
                        stream: _audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          final duration =
                              _audioPlayer.duration ?? Duration.zero;

                          return Column(
                            children: [
                              // Barra di avanzamento
                              Slider(
                                value: position.inMilliseconds.toDouble(),
                                max: duration.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  _audioPlayer
                                      .seek(Duration(milliseconds: value.toInt()));
                                },
                              ),

                              // Tempo corrente / Totale
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.defaultPadding,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_formatDuration(position)),
                                    Text(_formatDuration(duration)),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Pulsanti controllo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            _audioPlayer.seek(
                              _audioPlayer.position - const Duration(seconds: 10),
                            );
                          },
                          icon: const Icon(Icons.replay_10),
                          iconSize: 36,
                        ),
                        const SizedBox(width: 24),
                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering)
                          const CircularProgressIndicator()
                        else
                          IconButton(
                            onPressed: () {
                              if (playing) {
                                _audioPlayer.pause();
                              } else {
                                _audioPlayer.play();
                              }
                            },
                            icon: Icon(
                              playing ? Icons.pause_circle : Icons.play_circle,
                            ),
                            iconSize: 64,
                          ),
                        const SizedBox(width: 24),
                        IconButton(
                          onPressed: () {
                            _audioPlayer.seek(
                              _audioPlayer.position + const Duration(seconds: 10),
                            );
                          },
                          icon: const Icon(Icons.forward_10),
                          iconSize: 36,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Volume
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.largePadding,
                      ),
                      child: StreamBuilder<double>(
                        stream: _audioPlayer.volumeStream,
                        builder: (context, snapshot) {
                          final volume = snapshot.data ?? 1.0;
                          return Row(
                            children: [
                              const Icon(Icons.volume_down),
                              Expanded(
                                child: Slider(
                                  value: volume,
                                  min: 0.0,
                                  max: 1.0,
                                  onChanged: (value) {
                                    _audioPlayer.setVolume(value);
                                  },
                                ),
                              ),
                              const Icon(Icons.volume_up),
                            ],
                          );
                        },
                      ),
                    ),

                    // Info file
                    if (_currentAudioPath != null)
                      Padding(
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        child: Text(
                          'File: ${_currentAudioPath!.split('/').last}',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.music_note, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('Seleziona un file audio da riprodurre'),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/media-picker');
                    },
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Seleziona Audio'),
                  ),
                ],
              ),
            ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
