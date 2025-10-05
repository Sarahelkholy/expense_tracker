import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../user_repository.dart';

class FirebaseUserRepo implements UserRepository {
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

  Future<void> addIncome(String userId, int amount) async {
    try {
      await userCollection.doc(userId).update({
        'lastIncome': amount,
        'totalIncome': FieldValue.increment(amount),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
