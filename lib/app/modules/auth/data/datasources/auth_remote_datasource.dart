import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_despesas/app/core/errors/exceptions.dart';
import 'package:controle_despesas/app/modules/auth/application/dtos/login_dto.dart';
import 'package:controle_despesas/app/modules/auth/application/dtos/register_dto.dart';
import 'package:controle_despesas/app/modules/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDatasource {
  Future<void> register({required RegisterReq req});

  Future<void> login({required LoginReq req});

  Future<void> logout();

  Future<bool> getIsAuthenticated();

  Future<UserModel> getUser();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  @override
  Future<void> register({
    required RegisterReq req,
  }) async {
    try {
      final response = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: req.email, password: req.password);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(response.user!.uid)
          .set({
        'email': req.email,
        'firstName': req.firstName,
        'lastName': req.lastName,
        'id': response.user!.uid,
      });
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'invalid-email')
        message = "User was not found for that Email.";
      if (e.code == 'invalid-credential') message = "Invalid Credentials.";
      throw ServerException(message);
    }
  }

  @override
  Future<void> login({required LoginReq req}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: req.email, password: req.password);
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'invalid-email')
        message = "User was not found for that Email.";
      if (e.code == 'invalid-credential') message = "Invalid Credentials.";
      throw ServerException(message);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> getIsAuthenticated() async {
    try {
      return FirebaseAuth.instance.currentUser != null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw const ServerException("Nenhum usuário autenticado.");
      }
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (!docSnapshot.exists) {
        throw const ServerException(
            "Usuário não encontrado no banco de dados.");
      }

      final data = docSnapshot.data()!;
      return UserModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
