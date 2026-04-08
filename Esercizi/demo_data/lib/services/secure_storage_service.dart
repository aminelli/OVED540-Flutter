import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service per gestire la memorizzazione sicura di dati sensibili.
/// 
/// Utilizza:
/// - Keychain su iOS
/// - EncryptedSharedPreferences su Android
/// 
/// Ideale per: token di autenticazione, password, chiavi API, dati personali.
/// 
/// IMPORTANTE: I dati vengono crittografati automaticamente.
class SecureStorageService {
  // Configurazione per Android
  static const AndroidOptions _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  // Configurazione per iOS
  static const IOSOptions _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: _androidOptions,
    iOptions: _iosOptions,
  );

  // ==================== BASIC OPERATIONS ====================

  /// Salva un valore in modo sicuro
  /// 
  /// [key] chiave univoca
  /// [value] valore da salvare
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      print('Error writing to secure storage: $e');
      rethrow;
    }
  }

  /// Legge un valore dalla storage sicura
  /// 
  /// [key] chiave da leggere
  /// Ritorna il valore o null se non esiste
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      print('Error reading from secure storage: $e');
      return null;
    }
  }

  /// Elimina un valore specifico
  /// 
  /// [key] chiave da eliminare
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print('Error deleting from secure storage: $e');
      rethrow;
    }
  }

  /// Elimina tutti i valori (usa con cautela!)
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      print('Error deleting all from secure storage: $e');
      rethrow;
    }
  }

  /// Verifica se una chiave esiste
  /// 
  /// [key] chiave da verificare
  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      print('Error checking key in secure storage: $e');
      return false;
    }
  }

  /// Ottiene tutte le chiavi salvate
  Future<Map<String, String>> readAll() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      print('Error reading all from secure storage: $e');
      return {};
    }
  }

  // ==================== AUTHENTICATION METHODS ====================

  /// Salva il token di autenticazione
  Future<void> saveAuthToken(String token) async {
    await write('auth_token', token);
  }

  /// Legge il token di autenticazione
  Future<String?> getAuthToken() async {
    return await read('auth_token');
  }

  /// Elimina il token di autenticazione
  Future<void> deleteAuthToken() async {
    await delete('auth_token');
  }

  /// Verifica se l'utente è autenticato (ha un token)
  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // ==================== USER CREDENTIALS ====================

  /// Salva le credenziali utente (per demo - non usare password in plain text in produzione!)
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await write('user_email', email);
    await write('user_password', password);
  }

  /// Legge le credenziali salvate
  Future<Map<String, String?>> getCredentials() async {
    final email = await read('user_email');
    final password = await read('user_password');
    return {
      'email': email,
      'password': password,
    };
  }

  /// Elimina le credenziali salvate
  Future<void> deleteCredentials() async {
    await delete('user_email');
    await delete('user_password');
  }

  // ==================== API KEY ====================

  /// Salva una chiave API
  Future<void> saveApiKey(String apiKey) async {
    await write('api_key', apiKey);
  }

  /// Legge la chiave API
  Future<String?> getApiKey() async {
    return await read('api_key');
  }

  /// Elimina la chiave API
  Future<void> deleteApiKey() async {
    await delete('api_key');
  }

  // ==================== PIN CODE ====================

  /// Salva un PIN code
  Future<void> savePinCode(String pin) async {
    await write('pin_code', pin);
  }

  /// Verifica il PIN code
  Future<bool> verifyPinCode(String pin) async {
    final savedPin = await read('pin_code');
    return savedPin == pin;
  }

  /// Verifica se esiste un PIN salvato
  Future<bool> hasPinCode() async {
    return await containsKey('pin_code');
  }

  /// Elimina il PIN code
  Future<void> deletePinCode() async {
    await delete('pin_code');
  }

  // ==================== BIOMETRICS SETTINGS ====================

  /// Salva le impostazioni biometriche
  Future<void> setBiometricsEnabled(bool enabled) async {
    await write('biometrics_enabled', enabled.toString());
  }

  /// Verifica se le biometriche sono abilitate
  Future<bool> isBiometricsEnabled() async {
    final value = await read('biometrics_enabled');
    return value == 'true';
  }

  // ==================== DEMO DATA ====================

  /// Popolamento dati di esempio per la demo
  Future<void> populateDemoData() async {
    await saveAuthToken('demo_token_123456789');
    await saveApiKey('sk-demo-api-key-abcdef123456');
    await saveCredentials(
      email: 'demo@example.com',
      password: 'DemoPassword123!',
    );
    await savePinCode('1234');
    await setBiometricsEnabled(true);
  }

  /// Pulisce i dati demo
  Future<void> clearDemoData() async {
    await deleteAuthToken();
    await deleteApiKey();
    await deleteCredentials();
    await deletePinCode();
    await delete('biometrics_enabled');
  }
}
