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

  Future<void> updateUser(User user) async {
    try {
      final docRef = userCollection.doc(user.userId);

      // Only update the fields that should change via "updateUser" (eg. name).
      // Avoid writing totalIncome/lastIncome here unless explicitly intended.
      await docRef.update({
        'name': user.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      log('updateUser failed: $e', stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> addIncome(String userId, int amount) async {
    try {
      final docRef = userCollection.doc(userId);

      await FirebaseFirestore.instance.runTransaction((tx) async {
        final snapshot = await tx.get(docRef);

        if (!snapshot.exists) {
          // If user doc doesn't exist, create it with initial values
          tx.set(docRef, {
            'userId': userId,
            'name': '',
            'totalIncome': amount,
            'lastIncome': amount,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          return;
        }

        final data = snapshot.data();
        // handle data possibly being null
        final currentTotalRaw = data?['totalIncome'] ?? 0;
        // safe conversion: allow int or double
        final currentTotal = (currentTotalRaw is num)
            ? currentTotalRaw.toInt()
            : int.tryParse('$currentTotalRaw') ?? 0;

        final newTotal = currentTotal + amount;

        tx.update(docRef, {
          'lastIncome': amount,
          'totalIncome': newTotal,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }, timeout: const Duration(seconds: 15));
    } catch (e, st) {
      log('addIncome failed: $e', stackTrace: st);
      rethrow;
    }
  }
}
