import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Modello che rappresenta un utente dell'applicazione.
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime registrationDate;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.registrationDate,
  });

  @override
  List<Object?> get props => [id, name, email, avatarUrl, registrationDate];

  /// Utente demo per l'applicazione
  static User get demoUser => User(
        id: 'aspanu',
        name: 'Andrew Andrew',
        email: 'Andrew.Andrew@example.com',
        avatarUrl: 'https://via.placeholder.com/200/4285F4/FFFFFF?text=MR',
        registrationDate: DateTime.now().subtract(const Duration(days: 90)),
      );
}