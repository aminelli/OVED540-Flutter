/// Configurazione del routing dell'applicazione
library;

import 'package:flutter/material.dart';
import 'route_names.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/camera/presentation/pages/camera_screen.dart';
import '../../features/media_picker/presentation/pages/media_picker_screen.dart';
import '../../features/video_player/presentation/pages/video_player_screen.dart';
import '../../features/audio_player/presentation/pages/audio_player_screen.dart';
import '../../features/maps/presentation/pages/maps_screen.dart';
import '../../features/qr_scanner/presentation/pages/qr_scanner_screen.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case RouteNames.camera:
        return MaterialPageRoute(builder: (_) => const CameraScreen());

      case RouteNames.mediaPicker:
        return MaterialPageRoute(builder: (_) => const MediaPickerScreen());

      case RouteNames.videoPlayer:
        final args = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => VideoPlayerScreen(videoPath: args),
        );

      case RouteNames.audioPlayer:
        final args = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => AudioPlayerScreen(audioPath: args),
        );

      case RouteNames.maps:
        return MaterialPageRoute(builder: (_) => const MapsScreen());

      case RouteNames.qrScanner:
        return MaterialPageRoute(builder: (_) => const QrScannerScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route non trovata: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
