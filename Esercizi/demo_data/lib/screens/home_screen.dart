import 'package:flutter/material.dart';
import '../screens/file_storage_demo_screen.dart';
import '../screens/shared_prefs_demo_screen.dart';
import '../screens/secure_storage_demo_screen.dart';
import '../screens/sqlite_demo_screen.dart';
import '../screens/hive_demo_screen.dart';

/// Schermata principale dell'applicazione.
/// 
/// Mostra 5 card per accedere alle diverse demo di storage:
/// - File System (path_provider)
/// - SharedPreferences
/// - Flutter Secure Storage
/// - SQLite Database
/// - Hive Database
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Data Storage'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'Info',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Text(
                'Choose a Storage Type',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Explore different data persistence methods in Flutter',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Storage Cards
              Expanded(
                child: ListView(
                  children: [
                    _StorageCard(
                      title: 'File System',
                      subtitle: 'Save files, text, and JSON data',
                      icon: Icons.folder,
                      color: Colors.blue,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FileStorageDemoScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _StorageCard(
                      title: 'SharedPreferences',
                      subtitle: 'Store simple key-value pairs',
                      icon: Icons.settings,
                      color: Colors.orange,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SharedPrefsDemoScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _StorageCard(
                      title: 'Secure Storage',
                      subtitle: 'Encrypted storage for sensitive data',
                      icon: Icons.lock,
                      color: Colors.green,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SecureStorageDemoScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _StorageCard(
                      title: 'SQLite Database',
                      subtitle: 'Structured data with SQL queries',
                      icon: Icons.storage,
                      color: Colors.purple,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SqliteDemoScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _StorageCard(
                      title: 'Hive Database',
                      subtitle: 'Fast NoSQL database in pure Dart',
                      icon: Icons.inventory_2,
                      color: Colors.amber,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HiveDemoScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mostra un dialog informativo
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About This App'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This Flutter app demonstrates 5 different data storage techniques:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('📁 File System - For files, text, and JSON'),
              SizedBox(height: 8),
              Text('⚙️ SharedPreferences - For simple settings'),
              SizedBox(height: 8),
              Text('🔒 Secure Storage - For sensitive data'),
              SizedBox(height: 8),
              Text('💾 SQLite - For structured relational data'),
              SizedBox(height: 8),
              Text('📦 Hive - Fast NoSQL database in pure Dart'),
              SizedBox(height: 16),
              Text(
                'Each demo shows practical examples and best practices.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Widget riutilizzabile per le card di storage
class _StorageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StorageCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
