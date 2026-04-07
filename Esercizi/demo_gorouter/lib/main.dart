import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/products/bloc/product_bloc.dart';
import 'router/router.dart';

/// Entry point dell'applicazione GoRouter Demo.
/// 
/// Questa applicazione dimostra le funzionalità avanzate di GoRouter:
/// - Navigazione dichiarativa e type-safe
/// - Route annidate (nested routes)
/// - Bottom navigation persistente con ShellRoute
/// - Auth guards e redirect automatici
/// - Deep linking (supporto URL)
/// - Integrazione con Bloc pattern per state management
void main() {
  runApp(const MyApp());
}

/// Widget principale dell'applicazione.
/// 
/// Configura i provider per i Bloc e inizializza GoRouter
/// con tutte le route e guards necessari.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Bloc per l'autenticazione - condiviso globalmente
        BlocProvider(
          create: (context) => AuthBloc()
            ..add(const AuthCheckRequested()),
        ),
        
        // Bloc per i prodotti - condiviso globalmente
        BlocProvider(
          create: (context) => ProductBloc(),
        ),
      ],
      child: Builder(
        builder: (context) {
          // Crea il router passando il Bloc di autenticazione
          // per gestire i redirect basati sullo stato
          final appRouter = AppRouter(
            authBloc: context.read<AuthBloc>(),
          );

          return MaterialApp.router(
            title: 'GoRouter Demo',
            debugShowCheckedModeBanner: false,
            
            // Applica il tema Material 3 personalizzato
            theme: AppTheme.lightTheme,
            
            // Configurazione del router
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}
