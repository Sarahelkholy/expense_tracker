import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../expense_repository.dart';

class FirebaseUserRepo implements ExpenseRepository {
  final userCollection = FirebaseFirestore.instance.collection('user');

  @override
  Future<void> createUser(User user) async {
    try {
      await userCollection.doc(user.userId).set(user.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<User> getUser(String userId) async {
    try {
      final doc = await userCollection.doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return User.fromEntity(UserEntity.fromDocument(doc.data()!));
      } else {
        return User.empty;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateUser(User user) async {
    try {
      await userCollection
          .doc(user.userId)
          .update(user.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> addIncome(String userId, int amount) async {
    try {
      final userDoc = await userCollection.doc(userId).get();
      if (!userDoc.exists) return;

      final currentData = UserEntity.fromDocument(userDoc.data()!);
      final newTotal = currentData.totalIncome + amount;

      await userCollection.doc(userId).update({
        'lastIncome': amount,
        'totalIncome': newTotal,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
