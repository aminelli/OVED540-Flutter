import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/secure_storage_service.dart';

/// Schermata demo per Flutter Secure Storage.
/// 
/// Mostra esempi di memorizzazione sicura per:
/// - Token di autenticazione
/// - Credenziali utente (email/password)
/// - Chiavi API
/// - PIN code
/// - Impostazioni biometriche
class SecureStorageDemoScreen extends StatefulWidget {
  const SecureStorageDemoScreen({super.key});

  @override
  State<SecureStorageDemoScreen> createState() =>
      _SecureStorageDemoScreenState();
}

class _SecureStorageDemoScreenState extends State<SecureStorageDemoScreen> {
  final SecureStorageService _secureStorage = SecureStorageService();

  String? _authToken;
  String? _apiKey;
  String? _userEmail;
  String? _userPassword;
  bool? _hasPinCode;
  bool _biometricsEnabled = false;

  bool _isLoading = true;
  bool _showPasswords = false;

  @override
  void initState() {
    super.initState();
    _loadSecureData();
  }

  /// Carica tutti i dati dalla secure storage
  Future<void> _loadSecureData() async {
    setState(() => _isLoading = true);

    try {
      final token = await _secureStorage.getAuthToken();
      final apiKey = await _secureStorage.getApiKey();
      final credentials = await _secureStorage.getCredentials();
      final hasPinCode = await _secureStorage.hasPinCode();
      final biometricsEnabled = await _secureStorage.isBiometricsEnabled();

      setState(() {
        _authToken = token;
        _apiKey = apiKey;
        _userEmail = credentials['email'];
        _userPassword = credentials['password'];
        _hasPinCode = hasPinCode;
        _biometricsEnabled = biometricsEnabled;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error loading secure data: $e');
    }
  }

  /// Popola dati demo
  Future<void> _populateDemoData() async {
    try {
      await _secureStorage.populateDemoData();
      _showSuccess('Demo data populated!');
      await _loadSecureData();
    } catch (e) {
      _showError('Error populating demo data: $e');
    }
  }

  /// Pulisce tutti i dati
  Future<void> _clearAllData() async {
    final confirm = await _showConfirmDialog(
      'Clear All Secure Data',
      'Are you sure you want to delete all securely stored data?',
    );

    if (confirm == true) {
      try {
        await _secureStorage.deleteAll();
        _showSuccess('All secure data cleared!');
        await _loadSecureData();
      } catch (e) {
        _showError('Error clearing data: $e');
      }
    }
  }

  /// Salva token di autenticazione
  Future<void> _saveAuthToken() async {
    final controller = TextEditingController(text: _authToken);
    final result = await _showInputDialog(
      'Auth Token',
      'Enter authentication token',
      controller,
    );

    if (result != null && result.isNotEmpty) {
      try {
        await _secureStorage.saveAuthToken(result);
        _showSuccess('Auth token saved securely!');
        await _loadSecureData();
      } catch (e) {
        _showError('Error saving auth token: $e');
      }
    }
  }

  /// Salva API Key
  Future<void> _saveApiKey() async {
    final controller = TextEditingController(text: _apiKey);
    final result = await _showInputDialog(
      'API Key',
      'Enter API key',
      controller,
    );

    if (result != null && result.isNotEmpty) {
      try {
        await _secureStorage.saveApiKey(result);
        _showSuccess('API key saved securely!');
        await _loadSecureData();
      } catch (e) {
        _showError('Error saving API key: $e');
      }
    }
  }

  /// Salva credenziali
  Future<void> _saveCredentials() async {
    final emailController = TextEditingController(text: _userEmail);
    final passwordController = TextEditingController(text: _userPassword);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Credentials'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, {
              'email': emailController.text,
              'password': passwordController.text,
            }),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null &&
        result['email']!.isNotEmpty &&
        result['password']!.isNotEmpty) {
      try {
        await _secureStorage.saveCredentials(
          email: result['email']!,
          password: result['password']!,
        );
        _showSuccess('Credentials saved securely!');
        await _loadSecureData();
      } catch (e) {
        _showError('Error saving credentials: $e');
      }
    }
  }

  /// Salva PIN code
  Future<void> _savePinCode() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set PIN Code'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'PIN (4 digits)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          maxLength: 4,
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result.length == 4) {
      try {
        await _secureStorage.savePinCode(result);
        _showSuccess('PIN code saved securely!');
        await _loadSecureData();
      } catch (e) {
        _showError('Error saving PIN code: $e');
      }
    } else if (result != null) {
      _showError('PIN must be exactly 4 digits');
    }
  }

  /// Verifica PIN code
  Future<void> _verifyPinCode() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify PIN Code'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Enter PIN',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          maxLength: 4,
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Verify'),
          ),
        ],
      ),
    );

    if (result != null) {
      final isValid = await _secureStorage.verifyPinCode(result);
      if (isValid) {
        _showSuccess('PIN code is correct! ✓');
      } else {
        _showError('Incorrect PIN code! ✗');
      }
    }
  }

  /// Toggle biometrics
  Future<void> _toggleBiometrics(bool value) async {
    try {
      await _secureStorage.setBiometricsEnabled(value);
      setState(() => _biometricsEnabled = value);
      _showSuccess('Biometrics ${value ? "enabled" : "disabled"}!');
    } catch (e) {
      _showError('Error toggling biometrics: $e');
    }
  }

  Future<String?> _showInputDialog(
    String title,
    String label,
    TextEditingController controller,
  ) async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showConfirmDialog(String title, String message) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Storage Demo'),
        actions: [
          IconButton(
            icon: Icon(_showPasswords ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _showPasswords = !_showPasswords),
            tooltip: 'Toggle Visibility',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSecureData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Warning Banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      border: Border.all(color: Colors.amber),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.security, color: Colors.amber),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'All data is encrypted and stored securely using platform-specific secure storage.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Auth Token Card
                  _buildDataCard(
                    title: 'Authentication Token',
                    icon: Icons.key,
                    color: Colors.blue,
                    value: _authToken,
                    onEdit: _saveAuthToken,
                    onDelete: () async {
                      await _secureStorage.deleteAuthToken();
                      _showSuccess('Auth token deleted');
                      _loadSecureData();
                    },
                  ),
                  const SizedBox(height: 12),

                  // API Key Card
                  _buildDataCard(
                    title: 'API Key',
                    icon: Icons.vpn_key,
                    color: Colors.orange,
                    value: _apiKey,
                    onEdit: _saveApiKey,
                    onDelete: () async {
                      await _secureStorage.deleteApiKey();
                      _showSuccess('API key deleted');
                      _loadSecureData();
                    },
                  ),
                  const SizedBox(height: 12),

                  // Credentials Card
                  _buildCredentialsCard(),
                  const SizedBox(height: 12),

                  // PIN Code Card
                  _buildPinCodeCard(),
                  const SizedBox(height: 12),

                  // Biometrics Card
                  _buildBiometricsCard(),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _populateDemoData,
                          icon: const Icon(Icons.add),
                          label: const Text('Demo Data'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _clearAllData,
                          icon: const Icon(Icons.delete_sweep, color: Colors.red),
                          label: const Text(
                            'Clear All',
                            style: TextStyle(color: Colors.red),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDataCard({
    required String title,
    required IconData icon,
    required Color color,
    required String? value,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            if (value != null) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _showPasswords ? value : _obscureValue(value),
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: value));
                      _showSuccess('Copied to clipboard!');
                    },
                    tooltip: 'Copy',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit,size: 16),
                      label: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                      label: const Text('Delete', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const Text('No data stored', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialsCard() {
    final hasCredentials = _userEmail != null && _userPassword != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.account_circle, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'User Credentials',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const Divider(),
            if (hasCredentials) ...[
              Text('Email: ${_userEmail ?? ""}'),
              Text('Password: ${_showPasswords ? _userPassword : "••••••••"}'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _saveCredentials,
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await _secureStorage.deleteCredentials();
                        _showSuccess('Credentials deleted');
                        _loadSecureData();
                      },
                      icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                      label: const Text('Delete', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const Text('No credentials stored', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _saveCredentials,
                icon: const Icon(Icons.add),
                label: const Text('Add Credentials'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPinCodeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.pin, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'PIN Code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(
              _hasPinCode == true ? 'PIN is set ✓' : 'No PIN set',
              style: TextStyle(
                color: _hasPinCode == true ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _savePinCode,
                    icon: Icon(_hasPinCode == true ? Icons.edit : Icons.add, size: 16),
                    label: Text(_hasPinCode == true ? 'Change' : 'Set PIN'),
                  ),
                ),
                if (_hasPinCode == true) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _verifyPinCode,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Verify'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.fingerprint, color: Colors.teal),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Biometric Authentication',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            Switch(
              value: _biometricsEnabled,
              onChanged: _toggleBiometrics,
            ),
          ],
        ),
      ),
    );
  }

  String _obscureValue(String value) {
    if (value.length <= 8) {
      return '•' * value.length;
    }
    return '${value.substring(0, 4)}${'•' * (value.length - 8)}${value.substring(value.length - 4)}';
  }
}
