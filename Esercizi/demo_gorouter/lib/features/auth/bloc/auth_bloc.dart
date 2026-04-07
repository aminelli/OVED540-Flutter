import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Bloc per la gestione dell'autenticazione utente.
/// 
/// Gestisce il flusso di login, logout e verifica dello stato
/// di autenticazione. In questa demo, simula un'autenticazione
/// con un delay per mostrare stati di caricamento.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  
  AuthBloc() : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  /// Verifica lo stato di autenticazione iniziale
  /// In una vera app, controllerebbe il token salvato
  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    // Simula il controllo del token
    await Future.delayed(const Duration(seconds: 1));
    
    // Per questa demo, iniziamo sempre come non autenticati
    emit(const AuthUnauthenticated());
  }

  /// Gestisce la richiesta di login
  /// Simula l'autenticazione con credenziali
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      // Simula una chiamata API
      await Future.delayed(const Duration(seconds: 2));
      
      // Validazione semplice per la demo
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const AuthError(message: 'Email e password sono obbligatori'));
        return;
      }
      
      if (event.password.length < 4) {
        emit(const AuthError(message: 'Password troppo corta (min 4 caratteri)'));
        return;
      }
      
      // Login riuscito - restituisce l'utente demo
      emit(AuthAuthenticated(user: User.demoUser));
    } catch (e) {
      emit(AuthError(message: 'Errore durante il login: ${e.toString()}'));
    }
  }

  /// Gestisce il logout
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    // Simula la rimozione del token
    await Future.delayed(const Duration(milliseconds: 500));
    
    emit(const AuthUnauthenticated());
  }

  /// Controlla se l'utente è attualmente autenticato
  bool get isAuthenticated => state is AuthAuthenticated;
  
  /// Restituisce l'utente corrente se autenticato
  User? get currentUser {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      return currentState.user;
    }
    return null;
  }

}
