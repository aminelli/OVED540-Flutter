/// Widget test per HomeScreen
///
/// Testa il rendering e le interazioni della schermata home
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo_media/features/home/presentation/pages/home_screen.dart';
import 'package:demo_media/config/routes/route_names.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('mostra tutte le card delle funzionalità', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Verifica che tutte le card siano presenti
      expect(find.text('Fotocamera'), findsOneWidget);
      expect(find.text('Galleria Media'), findsOneWidget);
      expect(find.text('Video Player'), findsOneWidget);
      expect(find.text('Audio Player'), findsOneWidget);
      expect(find.text('Mappe'), findsOneWidget);
      expect(find.text('QR Scanner'), findsOneWidget);
    });

    testWidgets('mostra AppBar con titolo corretto', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      expect(find.text('Demo Media App'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('mostra GridView con 6 elementi', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(6));
    });

    testWidgets('ogni card ha icona e testo', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Verifica icone
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      expect(find.byIcon(Icons.photo_library), findsOneWidget);
      expect(find.byIcon(Icons.play_circle_filled), findsOneWidget);
      expect(find.byIcon(Icons.music_note), findsOneWidget);
      expect(find.byIcon(Icons.map), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
    });

    testWidgets('tap su card Fotocamera naviga alla route corrett a', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: const HomeScreen(),
          routes: {
            RouteNames.camera: (context) => const Scaffold(
              body: Center(child: Text('Camera Screen')),
            ),
          },
        ),
      );

      // Tap sulla card Fotocamera
      await tester.tap(find.text('Fotocamera'));
      await tester.pumpAndSettle();

      // Verifica navigazione
      expect(find.text('Camera Screen'), findsOneWidget);
    });

    testWidgets('tutte le card sono cliccabili', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Verifica che ci siano 6 InkWell (card cliccabili)
      expect(find.byType(InkWell), findsNWidgets(6));
    });
  });
}
