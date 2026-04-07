import 'package:flutter/material.dart';

/// Home page - Dashboard principale dell'applicazione.
/// 
/// Mostra una panoramica delle funzionalità disponibili
/// e fornisce accesso rapido alle sezioni principali.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Benvenuto
            Text(
              'Benvenuto!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Esplora le funzionalità della navigazione con GoRouter',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),
            
            // Card con statistiche o informazioni
            _buildInfoCard(
              context,
              title: 'Navigazione Dichiarativa',
              description: 'GoRouter permette di definire tutte le route in modo centralizzato e type-safe',
              icon: Icons.route,
              color: Colors.blue,
            ),
            
            _buildInfoCard(
              context,
              title: 'Nested Routes',
              description: 'Le route annidate permettono una struttura gerarchica della navigazione',
              icon: Icons.account_tree,
              color: Colors.green,
            ),
            
            _buildInfoCard(
              context,
              title: 'Deep Linking',
              description: 'Supporto nativo per aprire route specifiche tramite URL esterni',
              icon: Icons.link,
              color: Colors.orange,
            ),
            
            _buildInfoCard(
              context,
              title: 'Auth Guards',
              description: 'Redirect automatici basati sullo stato di autenticazione',
              icon: Icons.security,
              color: Colors.purple,
            ),
            
            const SizedBox(height: 24),
            
            // Sezione istruzioni
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Come usare questa demo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '• Usa la bottom navigation per spostarti tra le sezioni\n'
                    '• Vai su Prodotti per vedere la lista e i dettagli\n'
                    '• Controlla gli Ordini per vedere route annidate\n'
                    '• Il Profilo mostra le impostazioni utente\n'
                    '• Prova a fare logout per testare l\'auth guard',
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
