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

  @override
  Stream<User> userStream(String userId) {
    return userCollection.doc(userId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return User.empty;
      final data = snap.data()!;
      // convert fire-store map -> UserEntity -> User (adapt to your entity code)
      return User.fromEntity(UserEntity.fromDocument(data));
    });
  }
}
