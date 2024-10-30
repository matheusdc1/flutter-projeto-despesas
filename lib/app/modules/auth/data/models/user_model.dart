import 'package:controle_despesas/app/modules/auth/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
    );
  }

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  static User toEntity(UserModel model) {
    return User(
      id: model.id,
      email: model.email,
      firstName: model.firstName,
      lastName: model.lastName,
    );
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName];
}
