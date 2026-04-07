import 'package:flutter/material.dart';

/// Pagina di errore personalizzata.
/// 
/// Visualizzata quando si verifica un errore di navigazione
/// o quando l'utente tenta di accedere a una route non esistente (404).
class ErrorPage extends StatelessWidget {
  final String? error;

  const ErrorPage({
    super.key,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Errore'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                'Ops! Qualcosa è andato storto',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                error ?? 'Pagina non trovata',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  // Torna indietro o alla home
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    // Naviga alla home se non c'è history
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                icon: const Icon(Icons.home),
                label: const Text('Torna alla Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
