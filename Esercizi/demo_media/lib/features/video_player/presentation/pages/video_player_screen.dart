/// Schermata per riprodurre video con controlli
library;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../../core/constants/app_constants.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String? videoPath;

  const VideoPlayerScreen({super.key, this.videoPath});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController?_chewieController;
  String? _currentVideoPath;

  @override
  void initState() {
    super.initState();
    if (widget.videoPath != null) {
      _initializePlayer(widget.videoPath!);
    }
  }

  Future<void> _initializePlayer(String videoPath) async {
    try {
      _currentVideoPath = videoPath;

      // Determina se è un file locale o URL
      if (videoPath.startsWith('http')) {
        _videoPlayerController = VideoPlayerController.network(videoPath);
      } else {
        _videoPlayerController = VideoPlayerController.file(File(videoPath));
      }

      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Theme.of(context).colorScheme.primary,
          handleColor: Theme.of(context).colorScheme.primary,
          bufferedColor: Colors.grey,
          backgroundColor: Colors.black12,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Errore riproduzione video',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore caricamento video: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: _chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized
          ? Column(
              children: [
                AspectRatio(
                  aspectRatio:
                      _chewieController!.videoPlayerController.value.aspectRatio,
                  child: Chewie(controller: _chewieController!),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informazioni Video',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Durata',
                        _formatDuration(_videoPlayerController!.value.duration),
                      ),
                      _buildInfoRow(
                        'Risoluzione',
                        '${_videoPlayerController!.value.size.width.toInt()}x${_videoPlayerController!.value.size.height.toInt()}',
                      ),
                      if (_currentVideoPath != null)
                        _buildInfoRow(
                          'Percorso',
                          _currentVideoPath!,
                        ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_currentVideoPath == null) ...[
                    Icon(Icons.video_library, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text('Seleziona un video da riprodurre'),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/media-picker');
                      },
                      icon: const Icon(Icons.folder_open),
                      label: const Text('Seleziona Video'),
                    ),
                  ] else
                    const CircularProgressIndicator(),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours != '00' ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }
}
