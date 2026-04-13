/// Costanti globali dell'applicazione
library;

class AppConstants {
  AppConstants._();

  // Timeout
  static const int defaultTimeoutSeconds = 30;
  static const int maxRetries = 3;

  // Dimensioni
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Breakpoints per responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Limiti file
  static const int maxImageSizeMB = 10;
  static const int maxVideoSizeMB = 100;
  static const int maxAudioSizeMB = 50;

  // Messaggi
  static const String appName = 'Demo Media App';
  static const String defaultErrorMessage = 'Si è verificato un errore imprevisto';
  static const String networkErrorMessage = 'Errore di connessione. Verifica la tua rete.';
  static const String permissionDeniedMessage = 'Permesso negato. Abilita i permessi nelle impostazioni.';
}
