import 'package:equatable/equatable.dart';

/// Eventi per il Bloc di autenticazione.
/// 
/// Questi eventi vengono inviati al Bloc per gestire
/// le azioni di login, logout e controllo dello stato.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Evento per verificare lo stato di autenticazione iniziale
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Evento per effettuare il login
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Evento per effettuare il logout
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
