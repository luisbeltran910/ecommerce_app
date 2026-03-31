// UserModel to handle my data coming from the Gin API and translates it between the User entity.
// Author: Luis Angel Beltran Sanchez
// Version: 1.0.0

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String, 
      name: json['name'] as String, 
      email: json['email'] as String, 
      role: json['role'] as String,
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id, 
      name: user.name, 
      email: user.email, 
      role: user.role,
      );
  }

  User toEntity() => User(
    id: id, 
    name: name, 
    email: email, 
    role: role,
    );
}