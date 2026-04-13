/// Unit test per CameraBloc
///
/// Testa la logica del BLoC in isolamento usando mock del repository
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:camera/camera.dart';
import 'package:demo_media/features/camera/presentation/bloc/camera_bloc.dart';
import 'package:demo_media/features/camera/presentation/bloc/camera_event.dart';
import 'package:demo_media/features/camera/presentation/bloc/camera_state.dart';
import 'package:demo_media/features/camera/data/repositories/camera_repository.dart';
import 'package:demo_media/features/camera/data/models/photo_model.dart';

/// Mock del CameraRepository
class MockCameraRepository extends Mock implements CameraRepository {}

/// Mock del CameraController
class MockCameraController extends Mock implements CameraController {}

void main() {
  group('CameraBloc', () {
    late MockCameraRepository mockRepository;
    late CameraBloc cameraBloc;
    late MockCameraController mockController;

    setUp(() {
      mockRepository = MockCameraRepository();
      cameraBloc = CameraBloc(repository: mockRepository);
      mockController = MockCameraController();
    });

    tearDown(() {
      cameraBloc.close();
    });

    test('stato iniziale è CameraInitial', () {
      expect(cameraBloc.state, equals(CameraInitial()));
    });

    group('CameraInitializeEvent', () {
      blocTest<CameraBloc, CameraState>(
        'emette [CameraLoading, CameraReady] quando inizializzazione ha successo',
        build: () {
          when(() => mockRepository.initializeCamera())
              .thenAnswer((_) async => mockController);
          when(() => mockRepository.getSavedPhotos())
              .thenAnswer((_) async => []);
          return cameraBloc;
        },
        act: (bloc) => bloc.add(CameraInitializeEvent()),
        expect: () => [
          CameraLoading(),
          isA<CameraReady>(),
        ],
        verify: (_) {
          verify(() => mockRepository.initializeCamera()).called(1);
          verify(() => mockRepository.getSavedPhotos()).called(1);
        },
      );

      blocTest<CameraBloc, CameraState>(
        'emette [CameraLoading, CameraError] quando inizializzazione fallisce',
        build: () {
          when(() => mockRepository.initializeCamera())
              .thenThrow(Exception('Camera non disponibile'));
          return cameraBloc;
        },
        act: (bloc) => bloc.add(CameraInitializeEvent()),
        expect: () => [
          CameraLoading(),
          isA<CameraError>(),
        ],
      );
    });

    group('CameraCapturePictureEvent', () {
      final testPhoto = PhotoModel(
        path: '/test/photo.jpg',
        timestamp: DateTime.now(),
      );

      blocTest<CameraBloc, CameraState>(
        'emette [CameraPictureTaken, CameraReady] quando scatto ha successo',
        build: () {
          when(() => mockRepository.takePicture())
              .thenAnswer((_) async => testPhoto);
          when(() => mockRepository.getSavedPhotos())
              .thenAnswer((_) async => [testPhoto]);
          return cameraBloc;
        },
        seed: () => CameraReady(controller: mockController),
        act: (bloc) => bloc.add(CameraCapturePictureEvent()),
        expect: () => [
          isA<CameraPictureTaken>(),
          isA<CameraReady>(),
        ],
        verify: (_) {
          verify(() => mockRepository.takePicture()).called(1);
          verify(() => mockRepository.getSavedPhotos()).called(1);
        },
      );

      blocTest<CameraBloc, CameraState>(
        'emette [CameraError, CameraReady] quando scatto fallisce',
        build: () {
          when(() => mockRepository.takePicture())
              .thenThrow(Exception('Errore scatto'));
          return cameraBloc;
        },
        seed: () => CameraReady(controller: mockController),
        act: (bloc) => bloc.add(CameraCapturePictureEvent()),
        expect: () => [
          isA<CameraError>(),
          isA<CameraReady>(),
        ],
      );
    });

    group('CameraSwitchEvent', () {
      blocTest<CameraBloc, CameraState>(
        'emette [CameraLoading, CameraReady] quando cambio fotocamera ha successo',
        build: () {
          when(() => mockRepository.switchCamera())
              .thenAnswer((_) async => mockController);
          return cameraBloc;
        },
        seed: () => CameraReady(controller: mockController),
        act: (bloc) => bloc.add(CameraSwitchEvent()),
        expect: () => [
          CameraLoading(),
          isA<CameraReady>(),
        ],
        verify: (_) {
          verify(() => mockRepository.switchCamera()).called(1);
        },
      );
    });

    group('CameraDeletePhotoEvent', () {
      final testPhoto = PhotoModel(
        path: '/test/photo.jpg',
        timestamp: DateTime.now(),
      );

      blocTest<CameraBloc, CameraState>(
        'emette [CameraReady] con foto aggiornate dopo eliminazione',
        build: () {
          when(() => mockRepository.deletePhoto(any()))
              .thenAnswer((_) async => {});
          when(() => mockRepository.getSavedPhotos())
              .thenAnswer((_) async => []);
          return cameraBloc;
        },
        seed: () => CameraReady(
          controller: mockController,
          savedPhotos: [testPhoto],
        ),
        act: (bloc) => bloc.add(
          CameraDeletePhotoEvent(photoPath: testPhoto.path),
        ),
        expect: () => [
          isA<CameraReady>(),
        ],
        verify: (_) {
          verify(() => mockRepository.deletePhoto(testPhoto.path)).called(1);
          verify(() => mockRepository.getSavedPhotos()).called(1);
        },
      );
    });
  });
}
