import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_despesas/app/core/errors/exceptions.dart';
import 'package:controle_despesas/app/modules/expense/application/dtos/create_expense_dto.dart';
import 'package:controle_despesas/app/modules/expense/application/dtos/update_expense_dto.dart';
import 'package:controle_despesas/app/modules/expense/data/models/expense_model.dart';

abstract interface class ExpenseRemoteDatasource {
  Future<ExpenseModel> createExpense({required CreateExpenseReq req});

  Future<List<ExpenseModel>> getExpenses({required String userId});

  Future<ExpenseModel> getExpense({required String id, required String userId});

  Future<List<ExpenseModel>> deleteExpense(
      {required String id, required String userId});

  Future<List<ExpenseModel>> getExpensesFilteredSorted({
    required String userId,
    String? category,
    required String sortBy,
  });

  Future<ExpenseModel> editExpense({required UpdateExpenseReq req});
}

class ExpenseRemoteDatasourceImpl implements ExpenseRemoteDatasource {
  final FirebaseFirestore firestore;

  ExpenseRemoteDatasourceImpl({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<ExpenseModel> createExpense({required CreateExpenseReq req}) async {
    try {
      final collection = firestore.collection('Expenses');
      final docRef = collection.doc();
      await docRef.set({
        ...req.toJson(),
        'id': docRef.id,
      }).timeout(const Duration(seconds: 30));

      final response = await docRef.get();
      if (!response.exists) {
        throw const ServerException("Erro ao encontrar a despesa criada.");
      }
      final data = response.data();
      if (data == null || data.isEmpty) {
        throw const ServerException("Erro ao carregar despesa criada.");
      }
      return ExpenseModel.fromJson(data);
    } on TimeoutException {
      throw const ServerException(
          "A requisição demorou demais para ser concluída.");
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ExpenseModel>> getExpenses({required String userId}) async {
    try {
      final response = await firestore
          .collection('Expenses')
          .where('userId', isEqualTo: userId)
          .get();

      final docs = response.docs;
      if (docs.isEmpty)
        throw const ServerException("Nenhuma despesa encontrada.");
      return docs.map((doc) => ExpenseModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ExpenseModel> getExpense(
      {required String id, required String userId}) async {
    try {
      final response = await firestore
          .collection('Expenses')
          .where('id', isEqualTo: id)
          .where('userId', isEqualTo: userId)
          .get();

      if (response.docs.isEmpty)
        throw const ServerException("Despesa não encontrada.");
      return ExpenseModel.fromJson(response.docs.first.data());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ExpenseModel>> deleteExpense(
      {required String id, required String userId}) async {
    try {
      final querySnapshot = await firestore
          .collection('Expenses')
          .where('id', isEqualTo: id)
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw const ServerException("Despesa não encontrada ou acesso negado.");
      }

      await querySnapshot.docs.first.reference.delete();

      final updatedExpenses = await firestore
          .collection('Expenses')
          .where('userId', isEqualTo: userId)
          .get();

      final docs = updatedExpenses.docs;
      if (docs.isEmpty)
        throw const ServerException("Nenhuma despesa encontrada.");
      return docs.map((doc) => ExpenseModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ExpenseModel>> getExpensesFilteredSorted({
    required String userId,
    String? category,
    required String sortBy,
  }) async {
    try {
      Query<Map<String, dynamic>> collection =
          firestore.collection('Expenses').where('userId', isEqualTo: userId);

      if (category != null) {
        collection = collection.where('category', isEqualTo: category);
      }
      if (sortBy == 'value') {
        collection = collection.orderBy('value', descending: true);
      } else if (sortBy == 'date') {
        collection = collection.orderBy('date', descending: true);
      } else {
        throw const ServerException("Critério de ordenação inválido.");
      }

      final response = await collection.get();
      final docs = response.docs;
      if (docs.isEmpty)
        throw const ServerException("Nenhuma despesa encontrada.");
      return docs.map((doc) => ExpenseModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ExpenseModel> editExpense({required UpdateExpenseReq req}) async {
    try {
      final collection = firestore.collection('Expenses');

      final querySnapshot = await collection
          .where('id', isEqualTo: req.id)
          .where('userId', isEqualTo: req.userId)
          .get()
          .timeout(const Duration(seconds: 30));

      if (querySnapshot.docs.isEmpty) {
        throw const ServerException("Despesa não encontrada ou acesso negado.");
      }

      final docRef = querySnapshot.docs.first.reference;

      await docRef.update(req.toJson()).timeout(const Duration(seconds: 30));

      final updatedDoc = await docRef.get();
      if (!updatedDoc.exists) {
        throw const ServerException("Erro ao encontrar a despesa atualizada.");
      }

      final data = updatedDoc.data();
      if (data == null || data.isEmpty) {
        throw const ServerException("Erro ao carregar a despesa atualizada.");
      }

      return ExpenseModel.fromJson(data);
    } on TimeoutException {
      throw const ServerException(
          "A requisição demorou demais para ser concluída.");
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
