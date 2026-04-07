import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/routes.dart';

/// Scaffold principale con Bottom Navigation Bar persistente.
/// 
/// Questo widget utilizza ShellRoute di GoRouter per mantenere
/// la bottom navigation bar visibile attraverso le diverse schermate.
class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Prodotti',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Ordini',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilo',
          ),
        ],
      ),
    );
  }

  /// Calcola l'indice della tab selezionata in base alla route corrente
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    
    if (location.startsWith(AppRoutes.products)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.orders)) {
      return 2;
    }
    if (location.startsWith(AppRoutes.profile)) {
      return 3;
    }
    return 0; // Default: Home
  }

  /// Gestisce il tap su una tab della bottom navigation
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.products);
        break;
      case 2:
        context.go(AppRoutes.orders);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }
}
