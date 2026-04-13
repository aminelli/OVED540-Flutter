/// Schermata principale che mostra tutte le funzionalità disponibili
library;

import 'package:flutter/material.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/constants/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        mainAxisSpacing: AppConstants.defaultPadding,
        crossAxisSpacing: AppConstants.defaultPadding,
        children: [
          _buildFeatureCard(
            context,
            title: 'Fotocamera',
            icon: Icons.camera_alt,
            color: Colors.blue,
            onTap: () => Navigator.pushNamed(context, RouteNames.camera),
          ),
          _buildFeatureCard(
            context,
            title: 'Galleria Media',
            icon: Icons.photo_library,
            color: Colors.purple,
            onTap: () => Navigator.pushNamed(context, RouteNames.mediaPicker),
          ),
          _buildFeatureCard(
            context,
            title: 'Video Player',
            icon: Icons.play_circle_filled,
            color: Colors.red,
            onTap: () => Navigator.pushNamed(context, RouteNames.videoPlayer),
          ),
          _buildFeatureCard(
            context,
            title: 'Audio Player',
            icon: Icons.music_note,
            color: Colors.orange,
            onTap: () => Navigator.pushNamed(context, RouteNames.audioPlayer),
          ),
          _buildFeatureCard(
            context,
            title: 'Mappe',
            icon: Icons.map,
            color: Colors.green,
            onTap: () => Navigator.pushNamed(context, RouteNames.maps),
          ),
          _buildFeatureCard(
            context,
            title: 'QR Scanner',
            icon: Icons.qr_code_scanner,
            color: Colors.teal,
            onTap: () => Navigator.pushNamed(context, RouteNames.qrScanner),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
