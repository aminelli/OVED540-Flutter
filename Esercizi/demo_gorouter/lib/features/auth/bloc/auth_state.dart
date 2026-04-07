import 'package:equatable/equatable.dart';
import '../../../models/user.dart';

/// Stati per il Bloc di autenticazione.
/// 
/// Rappresentano i diversi stati in cui può trovarsi
/// il processo di autenticazione dell'utente.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Stato iniziale - autenticazione in fase di controllo
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Stato di caricamento durante operazioni di autenticazione
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Utente autenticato con successo
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Utente non autenticato
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Errore durante l'autenticazione
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
