// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  String userId;
  String name;
  int totalIncome;
  int lastIncome;
  DateTime updatedAt;

  UserEntity({
    required this.userId,
    required this.name,
    required this.totalIncome,
    required this.lastIncome,
    required this.updatedAt,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'name': name,
      'totalIncome': totalIncome,
      'lastIncome': lastIncome,
      'updatedAt': updatedAt,
    };
  }

  static UserEntity fromDocument(Map<String, dynamic> doc) {
    return UserEntity(
      userId: doc['userId'],
      name: doc['name'],
      totalIncome: doc['totalIncome'],
      lastIncome: doc['lastIncome'],
      updatedAt: (doc['updatedAt'] as Timestamp).toDate(),
    );
  }
}
