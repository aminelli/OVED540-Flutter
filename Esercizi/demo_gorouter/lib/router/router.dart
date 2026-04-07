import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/auth/bloc/auth_state.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/splash_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/products/presentation/products_page.dart';
import '../features/products/presentation/product_details_page.dart';
import '../features/orders/presentation/orders_page.dart';
import '../features/orders/presentation/order_details_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../core/widgets/main_scaffold.dart';
import '../core/widgets/error_page.dart';
import 'routes.dart';

/// Configurazione del router dell'applicazione usando GoRouter.
/// 
/// Gestisce tutte le route dell'app, inclusi:
/// - Navigazione dichiarativa
/// - Deep linking
/// - Route guards per l'autenticazione
/// - Bottom navigation persistente con ShellRoute
/// - Gestione errori 404
class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  /// Crea e restituisce la configurazione GoRouter
  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    
    // Redirect globale per gestire l'autenticazione
    redirect: (context, state) {
      final isAuthenticated = authBloc.state is AuthAuthenticated;
      final isAuthenticating = authBloc.state is AuthLoading || 
                               authBloc.state is AuthInitial;
      
      final isOnSplash = state.matchedLocation == AppRoutes.splash;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      // Se stiamo ancora caricando/verificando, rimani dove sei
      if (isAuthenticating) {
        // Se non siamo già sullo splash, vai allo splash
        if (!isOnSplash) {
          return AppRoutes.splash;
        }
        return null; // Rimani sullo splash mentre carica
      }

      // Autenticazione completata - determina dove andare
      if (isAuthenticated) {
        // Se autenticato e su login/splash, vai alla home
        if (isOnLogin || isOnSplash) {
          return AppRoutes.home;
        }
      } else {
        // Non autenticato - vai al login se non ci sei già
        if (!isOnLogin) {
          return AppRoutes.login;
        }
      }

      // Nessun redirect necessario
      return null;
    },
    
    // Listener per aggiornamenti dello stato di autenticazione
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    
    // Gestione errori - mostra pagina 404
    errorBuilder: (context, state) => ErrorPage(
      error: state.error.toString(),
    ),
    
    // Definizione delle routes
    routes: [
      // Splash screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      
      // Login
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      
      // Shell route per navigazione persistente con bottom bar
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          // Home / Dashboard
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
            ),
          ),
          
          // Prodotti
          GoRoute(
            path: AppRoutes.products,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProductsPage(),
            ),
            routes: [
              // Dettaglio prodotto (route annidata)
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final productId = state.pathParameters['id']!;
                  return ProductDetailsPage(productId: productId);
                },
              ),
            ],
          ),
          
          // Ordini
          GoRoute(
            path: AppRoutes.orders,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const OrdersPage(),
            ),
            routes: [
              // Dettaglio ordine (route annidata)
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final orderId = state.pathParameters['id']!;
                  return OrderDetailsPage(orderId: orderId);
                },
              ),
            ],
          ),
          
          // Profilo
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProfilePage(),
            ),
          ),
        ],
      ),
      
      // Settings (senza bottom bar)
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}

/// Helper class per ascoltare lo stream del Bloc e notificare GoRouter
/// quando lo stato di autenticazione cambia.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
