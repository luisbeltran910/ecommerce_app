// This is just my user entity for the app
// Author: Luis Angel Beltran Sanchez
// Version: 1.0.0

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  bool get isAdmin => role == 'admin';
  bool get isCustomer => role == 'customer';

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
  }) {
    return User(
      id: id ?? this.id, 
      name: name ?? this.name, 
      email: email ?? this.email, 
      role: role ?? this.role,
      );
  }

  @override
  List<Object> get props => [id, name, email, role];
}