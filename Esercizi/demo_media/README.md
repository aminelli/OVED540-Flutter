# Demo Media App

Applicazione Flutter completa che dimostra l'utilizzo di funzionalità media avanzate con architettura BLoC Pattern.

## 📱 Funzionalità Principali

- **📷 Fotocamera**: Scatto foto con camera preview, cambio fotocamera frontale/posteriore, galleria foto salvate
- **🖼️ Galleria Media**: Selezione immagini e video dalla galleria, selezione multipla, preview dettagliata
- **🎬 Video Player**: Riproduzione video con controlli completi (play/pause, seek, volume) tramite Chewie
- **🎵 Audio Player**: Riproduzione file audio con controlli avanzati tramite just_audio
- **🗺️ Mappe**: Integrazione Google Maps con geolocalizzazione e marker personalizzati
- **📱 QR Scanner**: Scansione e generazione QR codes/barcodes

## 🏗️ Architettura

Il progetto segue il **BLoC Pattern (Business Logic Component)** con separazione in layer:

```
lib/
├── main.dart                 # Entry point dell'app
├── app.dart                  # Configurazione MaterialApp
├── core/                     # Codice condiviso
│   ├── constants/           # Costanti globali
│   ├── theme/               # Configurazione tema
│   ├── utils/               # Utilities e helper
│   └── widgets/             # Widget riutilizzabili
├── config/
│   └── routes/              # Configurazione routing
└── features/                # Funzionalità organizzate per feature
    ├── home/
    ├── camera/
    │   ├── data/            # Repository e modelli
    │   ├── domain/          # Entità e logica business (se necessario)
    │   └── presentation/    # BLoC, pagine e widget
    ├── media_picker/
    ├── video_player/
    ├── audio_player/
    ├── maps/
    └── qr_scanner/
```

### Separazione Responsabilità

- **Data Layer**: Repository per accesso a dati esterni (camera, storage, API)
- **Domain Layer**: Logica business pura (se necessaria)
- **Presentation Layer**: BLoC per state management, UI (pagine e widget)

## 📦 Dipendenze Utilizzate

### State Management
- `flutter_bloc: ^8.1.3` - Implementazione pattern BLoC
- `equatable: ^2.0.5` - Confronto oggetti per stati ed eventi

### Media - Camera e Foto
- `image_picker: ^1.0.7` - Accesso fotocamera e galleria (cross-platform)
- `camera: ^0.10.5+5` - Controllo avanzato fotocamera con preview

### Media - Video
- `video_player: ^2.8.2` - Riproduzione video nativi
- `chewie: ^1.7.4` - UI controls eleganti per video player

### Media - Audio
- `just_audio: ^0.9.36` - Audio player potente e flessibile
- `audio_session: ^0.1.18` - Gestione sessioni audio multipiattaforma

### File e Storage
- `file_picker: ^6.1.1` - Selezione file dal dispositivo
- `path_provider: ^2.1.1` - Accesso directory sistema
- `path: ^1.8.3` - Manipolazione percorsi file

### Maps e Geolocalizzazione
- `google_maps_flutter: ^2.5.3` - Integrazione Google Maps
- `geolocator: ^10.1.0` - Ottenere posizione GPS
- `geocoding: ^2.1.1` - Conversione coordinate ↔ indirizzi

### Scanner
- `mobile_scanner: ^3.5.6` - Scanner QR/Barcode moderno
- `qr_flutter: ^4.1.0` - Generazione QR codes

### Permissions
- `permission_handler: ^11.1.0` - Gestione permessi runtime

### Testing
- `bloc_test: ^9.1.5` - Testing per BLoC
- `mocktail: ^1.0.1` - Mock objects per test
- `integration_test` - Test end-to-end
- `very_good_analysis: ^5.1.0` - Regole lint avanzate

## 🚀 Setup e Installazione

### Prerequisiti

- Flutter SDK (latest stable version)
- Dart SDK (>= 3.11.4)
- Android Studio (per Android) o Xcode (per iOS)
- Dispositivo fisico o emulatore

### Installazione

1. **Clona il repository** (se applicabile):
```bash
git clone <repository-url>
cd demo_media
```

2. **Installa le dipendenze**:
```bash
flutter pub get
```

3. **Configura Google Maps** (opzionale):

**Android**: Aggiungi la tua API key in `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
```

**iOS**: Aggiungi la tua API key in `ios/Runner/AppDelegate.swift`:
```swift
GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```

4. **Esegui l'app**:
```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Dispositivo specifico
flutter run -d <device_id>
```

## 🧪 Testing

### Esegui Tutti i Test
```bash
flutter test
```

### Test con Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
# Apri coverage/html/index.html nel browser
```

### Integration Test
```bash
flutter test integration_test/
```

### Test Specifico
```bash
flutter test test/unit/camera_bloc_test.dart
```

### Coverage Obiettivi
- **Unit Test**: ≥ 80% coverage per business logic
- **Widget Test**: ≥ 70% coverage per UI components
- **Integration Test**: Almeno 1 test per ogni feature principale

## 🔐 Permessi Richiesti

### Android (`AndroidManifest.xml`)
- `CAMERA` - Accesso fotocamera
- `RECORD_AUDIO` - Registrazione audio
- `ACCESS_FINE_LOCATION` / `ACCESS_COARSE_LOCATION` - Geolocalizzazione
- `READ_EXTERNAL_STORAGE` / `WRITE_EXTERNAL_STORAGE` - Storage (Android ≤ 12)
- `READ_MEDIA_IMAGES` / `READ_MEDIA_VIDEO` / `READ_MEDIA_AUDIO` - Media (Android 13+)

### iOS (`Info.plist`)
- `NSCameraUsageDescription` - Descrizione uso fotocamera
- `NSMicrophoneUsageDescription` - Descrizione uso microfono
- `NSPhotoLibraryUsageDescription` - Descrizione accesso galleria
- `NSLocationWhenInUseUsageDescription` - Descrizione uso posizione

Tutti i permessi sono gestiti automaticamente tramite `PermissionService`.

## 💡 Best Practices Adottate

### Codice
- ✅ **Null Safety**: Codice 100% null-safe
- ✅ **Stateless vs Stateful**: StatefulWidget solo quando necessario
- ✅ **Separazione Responsabilità**: Ogni classe ha uno scopo specifico
- ✅ **Naming Conventions**: snake_case per file, PascalCase per classi, camelCase per variabili
- ✅ **Error Handling**: Gestione robusta degli errori con messaggi user-friendly
- ✅ **Responsive Design**: Layout adattivo per mobile/tablet/desktop

### Testing
- ✅ **Unit Test**: BLoC testati con bloc_test e mocktail
- ✅ **Widget Test**: UI testata con find e pump
- ✅ **Integration Test**: Flussi end-to-end completi

### Performance
- ✅ **Lazy Loading**: Immagini caricate on-demand
- ✅ **Memory Management**: Dispose corretto di controller e stream
- ✅ **Asset Optimization**: Immagini ottimizzate per dimensione
- ✅ **Isolates**: Operazioni pesanti su thread separati (se necessario)

### Sicurezza
- ✅ **Permission Handling**: Richiesta permessi solo quando necessari
- ✅ **Data Privacy**: Dati sensibili solo in storage locale
- ✅ **Validazione Input**: Controlli su tutti gli input utente

## 📝 Documentazione Codice

Tutti i file contengono:
- **Header**: Descrizione scopo e contenuto del file
- **Commenti alle classi**: Responsabilità e funzionamento
- **Commenti ai metodi**: Parametri, return value, side effects
- **Commenti inline**: Per logica complessa o non ovvia
- **TODO/FIXME**: Per miglioramenti futuri

*Nota: La documentazione del codice è in **italiano**, mentre il codice stesso è in **inglese** secondo le best practices.*

## 🛠️ Comandi Utili

### Sviluppo
```bash
# Hot reload
r

# Hot restart
R

# Dev tools
flutter devtools

# Profiling
flutter run --profile
```

### Code Quality
```bash
# Analisi codice
flutter analyze

# Formattazione
flutter format .

# Verifica formattazione
flutter format --set-exit-if-changed .
```

### Build
```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios

# Web
flutter build web
```

## 🐛 Troubleshooting

### Errore "Camera permission denied"
Verifica che i permessi siano configurati correttamente in `AndroidManifest.xml` e `Info.plist`, e che l'utente abbia concesso i permessi.

### Errore "Google Maps non si carica"
Assicurati di aver configurato correttamente la API key di Google Maps per la tua piattaforma.

### Errore "Module not found"
```bash
flutter clean
flutter pub get
```

### Errore di compilazione Android
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

## 📱 Supporto Piattaforme

- ✅ Android (minSdk: 21, targetSdk: 34)
- ✅ iOS (iOS 12.0+)
- ⚠️ Web (limitato - non tutte le funzionalità disponibili)
- ⚠️ Desktop (Windows/macOS/Linux - non tutte le funzionalità disponibili)

## 📄 Licenza

Questo progetto è un'applicazione demo per scopi didattici e di sviluppo.

## 👥 Contributi

Per contribuire al progetto:
1. Fork del repository
2. Crea un branch per la tua feature (`git checkout -b feature/AmazingFeature`)
3. Commit dei cambiamenti (`git commit -m 'Add some AmazingFeature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Apri una Pull Request

## 📞 Supporto

Per domande o problemi, apri una issue nel repository GitHub.

---

**Versione**: 1.0.0  
**Ultimo aggiornamento**: Aprile 2026  
**Framework**: Flutter (latest stable)  
**Linguaggio**: Dart (SDK >= 3.11.4)

