import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pagina delle impostazioni dell'applicazione.
/// 
/// Questa pagina è accessibile dal profilo e non ha la bottom navigation
/// (è fuori dalla ShellRoute).
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _emailUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          // Sezione notifiche
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Notifiche',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Abilita notifiche push'),
            subtitle: const Text('Ricevi notifiche per ordini e novità'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary: const Icon(Icons.notifications),
          ),
          SwitchListTile(
            title: const Text('Aggiornamenti via email'),
            subtitle: const Text('Ricevi newsletter e offerte'),
            value: _emailUpdates,
            onChanged: (value) {
              setState(() {
                _emailUpdates = value;
              });
            },
            secondary: const Icon(Icons.email),
          ),
          const Divider(),
          
          // Sezione aspetto
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Aspetto',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Modalità scura'),
            subtitle: const Text('Usa tema scuro (non implementato)'),
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tema scuro non implementato in questa demo'),
                ),
              );
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),
          
          // Sezione privacy e sicurezza
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Privacy e Sicurezza',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Cambia password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funzionalità non disponibile in questa demo'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Autenticazione a due fattori'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funzionalità non disponibile in questa demo'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Gestione dati personali'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funzionalità non disponibile in questa demo'),
                ),
              );
            },
          ),
          const Divider(),
          
          // Sezione informazioni
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Informazioni',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Informazioni sull\'app'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Termini e condizioni'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funzionalità non disponibile in questa demo'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text('Privacy policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funzionalità non disponibile in questa demo'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'GoRouter Demo',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.shopping_bag,
        size: 48,
      ),
      children: [
        const Text(
          'Applicazione dimostrativa che illustra l\'utilizzo di GoRouter '
          'per la navigazione in Flutter.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Funzionalità implementate:\n'
          '• Navigazione dichiarativa\n'
          '• Route annidate\n'
          '• Bottom navigation persistente\n'
          '• Auth guards e redirect\n'
          '• Deep linking\n'
          '• State management con Bloc',
        ),
      ],
    );
  }
}
