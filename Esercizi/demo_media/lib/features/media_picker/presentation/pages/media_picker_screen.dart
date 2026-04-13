/// Schermata per selezionare e gestire media (foto/video/file)
library;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/media_picker_bloc.dart';
import '../bloc/media_picker_event.dart';
import '../bloc/media_picker_state.dart';
import '../../data/repositories/media_picker_repository.dart';
import '../../../../core/utils/permission_service.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/constants/app_constants.dart';

class MediaPickerScreen extends StatelessWidget {
  const MediaPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MediaPickerBloc(
        repository: MediaPickerRepository(
          imagePicker: ImagePicker(),
          permissionService: PermissionService(),
        ),
      ),
      child: const MediaPickerView(),
    );
  }
}

class MediaPickerView extends StatelessWidget {
  const MediaPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galleria Media'),
        actions: [
          BlocBuilder<MediaPickerBloc, MediaPickerState>(
            builder: (context, state) {
              if (state is MediaPickerLoaded && state.selectedFiles.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () {
                    context.read<MediaPickerBloc>().add(ClearAllMediaEvent());
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Pulsanti di selezione
          _buildActionButtons(context),

          // Lista media selezionati
          Expanded(
            child: BlocConsumer<MediaPickerBloc, MediaPickerState>(
              listener: (context, state) {
                if (state is MediaPickerError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is MediaPickerLoading) {
                  return const LoadingView(message: 'Caricamento...');
                }

                if (state is MediaPickerLoaded) {
                  if (state.selectedFiles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nessun media selezionato',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: state.selectedFiles.length,
                    itemBuilder: (context, index) {
                      final file = state.selectedFiles[index];
                      return _buildMediaItem(context, file);
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<MediaPickerBloc>().add(PickImageEvent());
                  },
                  icon: const Icon(Icons.photo),
                  label: const Text('Foto'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context
                        .read<MediaPickerBloc>()
                        .add(PickMultipleImagesEvent());
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Foto Multiple'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<MediaPickerBloc>().add(PickVideoEvent());
                  },
                  icon: const Icon(Icons.video_library),
                  label: const Text('Video'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<MediaPickerBloc>().add(TakePhotoEvent());
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Scatta'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaItem(BuildContext context, File file) {
    final isVideo = file.path.endsWith('.mp4') ||
        file.path.endsWith('.mov') ||
        file.path.endsWith('.avi');

    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: () => _showMediaDetail(context, file),
          child: isVideo
              ? Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.play_circle_filled, size: 48),
                  ),
                )
              : Image.file(
                  file,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Material(
            color: Colors.black.withOpacity(0.6),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () {
                context
                    .read<MediaPickerBloc>()
                    .add(RemoveMediaEvent(filePath: file.path));
              },
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showMediaDetail(BuildContext context, File file) {
    final isVideo = file.path.endsWith('.mp4') ||
        file.path.endsWith('.mov') ||
        file.path.endsWith('.avi');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(isVideo ? 'Video' : 'Foto'),
          ),
          body: Center(
            child: isVideo
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_circle_filled, size: 100),
                      const SizedBox(height: 16),
                      const Text('Usa Video Player per riprodurre'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/video-player',
                            arguments: file.path,
                          );
                        },
                        child: const Text('Apri Video Player'),
                      ),
                    ],
                  )
                : InteractiveViewer(
                    child: Image.file(file),
                  ),
          ),
        ),
      ),
    );
  }
}
