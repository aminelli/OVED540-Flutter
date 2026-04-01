import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/todo_bloc.dart';
import 'screens/todo_list_screen.dart';

/// Punto di ingresso dell'applicazione
/// 
/// Inizializza e avvia l'app Flutter
void main() {
  runApp(const MyApp());
}

/// Widget principale dell'applicazione
/// 
/// Configura il tema e fornisce il TodoBloc a tutta l'applicazione
/// utilizzando BlocProvider
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider: fornisce un'istanza di TodoBloc a tutti i widget figli
    // In questo modo, qualsiasi widget nell'albero può accedere al Bloc
    // usando context.read<TodoBloc>() o context.watch<TodoBloc>()
    return BlocProvider(
      // Crea un'istanza di TodoBloc quando l'app viene avviata
      create: (context) => TodoBloc(),
      
      child: MaterialApp(
        // Configurazione dell'applicazione
        title: 'Todo List con Bloc',
        debugShowCheckedModeBanner: false,
        
        // Schermata iniziale dell'app
        home: const TodoListScreen(),
        
        // Tema dell'applicazione
        theme: ThemeData(
          // Usa Material 3 (design system più recente di Google)
          useMaterial3: true,
          
          // Schema di colori basato su un colore primario
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          
          // Configurazione della AppBar
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
          ),
        ),
        
        
      ),
    );
  }
}
