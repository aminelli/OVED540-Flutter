/// Schermata della fotocamera con preview e controlli
library;

import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/camera_bloc.dart';
import '../bloc/camera_event.dart';
import '../bloc/camera_state.dart';
import '../../data/repositories/camera_repository.dart';
import '../../../../core/utils/permission_service.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/constants/app_constants.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Su Windows, la libreria camera non è supportata, usa image_picker
    if (!kIsWeb && Platform.isWindows) {
      return const WindowsCameraScreen();
    }
    
    return BlocProvider(
      create: (context) => CameraBloc(
        repository: CameraRepository(
          permissionService: PermissionService(),
        ),
      )..add(CameraInitializeEvent()),
      child: const CameraView(),
    );
  }
}

/// Schermata camera alternativa per Windows usando image_picker
class WindowsCameraScreen extends StatefulWidget {
  const WindowsCameraScreen({super.key});

  @override
  State<WindowsCameraScreen> createState() => _WindowsCameraScreenState();
}

class _WindowsCameraScreenState extends State<WindowsCameraScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<String> _photos = [];

  Future<void> _selectImage() async {
    try {
      // Su Windows, ImageSource.camera non è supportato
      // Usa la galleria/filesystem invece
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (photo != null && mounted) {
        setState(() {
          _photos.insert(0, photo.path);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Immagine selezionata con successo!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _selectMultipleImages() async {
    try {
      final List<XFile> photos = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (photos.isNotEmpty && mounted) {
        setState(() {
          _photos.insertAll(0, photos.map((p) => p.path));
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${photos.length} immagini selezionate!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fotocamera'),
        actions: [
          if (_photos.isNotEmpty)
            IconButton(
              icon: Badge(
                label: Text('${_photos.length}'),
                child: const Icon(Icons.photo_library),
              ),
              onPressed: () => _showPhotosGallery(),
            ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 80,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
              ),
              const SizedBox(height: 24),
              Text(
                'Camera non disponibile su Windows',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'L\'accesso live alla webcam non è supportato su Windows.\nPuoi selezionare immagini dal tuo dispositivo.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Pulsante seleziona singola immagine
              SizedBox(
                width: 280,
                child: ElevatedButton.icon(
                  onPressed: _selectImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Seleziona Immagine'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Pulsante seleziona multiple immagini
              SizedBox(
                width: 280,
                child: OutlinedButton.icon(
                  onPressed: _selectMultipleImages,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Seleziona Multiple Immagini'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              if (_photos.isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  '${_photos.length} immagine${_photos.length != 1 ? "i" : ""} selezionate',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _photos.length > 5 ? 5 : _photos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_photos[index]),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showPhotosGallery() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: 600,
          height: 500,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Immagini selezionate (${_photos.length})',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Cancella tutto',
                          onPressed: () {
                            setState(() {
                              _photos.clear();
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tutte le immagini cancellate'),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _photos.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_photos[index]),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(4),
                              minimumSize: const Size(24, 24),
                            ),
                            onPressed: () {
                              setState(() {
                                _photos.removeAt(index);
                              });
                              if (_photos.isEmpty) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fotocamera'),
        actions: [
          BlocBuilder<CameraBloc, CameraState>(
            builder: (context, state) {
              if (state is CameraReady) {
                return IconButton(
                  icon: const Icon(Icons.flip_camera_ios),
                  onPressed: () {
                    context.read<CameraBloc>().add(CameraSwitchEvent());
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<CameraBloc, CameraState>(
            builder: (context, state) {
              if (state is CameraReady && state.savedPhotos.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () {
                    _showPhotosGallery(context, state.savedPhotos);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<CameraBloc, CameraState>(
        listener: (context, state) {
          if (state is CameraPictureTaken) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Foto salvata con successo!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CameraLoading) {
            return const LoadingView(message: 'Inizializzazione fotocamera...');
          }

          if (state is CameraError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<CameraBloc>().add(CameraInitializeEvent());
              },
            );
          }

          if (state is CameraReady || state is CameraPictureTaken) {
            final controller = state is CameraReady
                ? state.controller
                : (state as CameraPictureTaken).controller;

            return Stack(
              fit: StackFit.expand,
              children: [
                // Camera Preview
                CameraPreview(controller),

                // Overlay con controlli
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Pulsante scatta foto
                          Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: () {
                                context
                                    .read<CameraBloc>()
                                    .add(CameraCapturePictureEvent());
                              },
                              customBorder: const CircleBorder(),
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.camera,
                                    size: 32,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showPhotosGallery(BuildContext context, List photos) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 400,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Foto salvate (${photos.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return GestureDetector(
                    onTap: () {
                      _showPhotoDetail(context, photo.path);
                    },
                    child: Image.file(
                      File(photo.path),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoDetail(BuildContext context, String photoPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text('Foto'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context
                      .read<CameraBloc>()
                      .add(CameraDeletePhotoEvent(photoPath: photoPath));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: Center(
            child: Image.file(File(photoPath)),
          ),
        ),
      ),
    );
  }
}
