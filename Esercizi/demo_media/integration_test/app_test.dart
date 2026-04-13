/// Integration test per il flusso completo dell'app
///
/// Testa la navigazione e l'integrazione tra le varie schermate
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:demo_media/main.dart' as app;
import 'package:demo_media/features/home/presentation/pages/home_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('avvio app e verifica home screen', (tester) async {
      // Avvia app
      app.main();
      await tester.pumpAndSettle();

      // Verifica che la home screen sia visibile
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Demo Media App'), findsOneWidget);
    });

    testWidgets('navigazione a tutte le schermate principali', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test navigazione Camera
      await tester.tap(find.text('Fotocamera'));
      await tester.pumpAndSettle();
      expect(find.text('Fotocamera'), findsAtLeastNWidgets(1));
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Test navigazione Media Picker
      await tester.tap(find.text('Galleria Media'));
      await tester.pumpAndSettle();
      expect(find.text('Galleria Media'), findsAtLeastNWidgets(1));
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Test navigazione Video Player
      await tester.tap(find.text('Video Player'));
      await tester.pumpAndSettle();
      expect(find.text('Video Player'), findsAtLeastNWidgets(1));
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Test navigazione Audio Player
      await tester.tap(find.text('Audio Player'));
      await tester.pumpAndSettle();
      expect(find.text('Audio Player'), findsAtLeastNWidgets(1));
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Test navigazione Maps
      await tester.tap(find.text('Mappe'));
      await tester.pumpAndSettle();
      expect(find.text('Mappe'), findsAtLeastNWidgets(1));
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Test navigazione QR Scanner
      await tester.tap(find.text('QR Scanner'));
      await tester.pumpAndSettle();
      expect(find.text('QR/Barcode Scanner'), findsAtLeastNWidgets(1));
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Verifica ritorno alla home
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('test tema light e dark', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verifica che il tema sia applicato
      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
    });
  });
}
