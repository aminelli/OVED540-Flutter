/// Costanti utilizzate nell'applicazione

class StorageKeys {
  // SharedPreferences keys
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String showTutorial = 'show_tutorial';
  static const String appLaunchCount = 'app_launch_count';
  static const String userName = 'user_name';

  // Secure Storage keys
  static const String authToken = 'auth_token';
  static const String apiKey = 'api_key';
  static const String userEmail = 'user_email';
  static const String userPassword = 'user_password';
  static const String pinCode = 'pin_code';

  // Database
  static const String databaseName = 'demo_data.db';
  static const int databaseVersion = 1;
  static const String tasksTable = 'tasks';
}

class AppStrings {
  static const String appTitle = 'Demo Data Storage';
  static const String fileStorageTitle = 'File System';
  static const String sharedPrefsTitle = 'SharedPreferences';
  static const String secureStorageTitle = 'Secure Storage';
  static const String sqliteTitle = 'SQLite Database';
}
