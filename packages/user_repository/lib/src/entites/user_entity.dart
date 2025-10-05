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
    final totalRaw = doc['totalIncome'] ?? 0;
    final lastRaw = doc['lastIncome'] ?? 0;
    final updatedAtRaw = doc['updatedAt'];

    return UserEntity(
      userId: doc['userId'] as String? ?? '',
      name: doc['name'] as String? ?? '',
      totalIncome: (totalRaw is num)
          ? totalRaw.toInt()
          : int.tryParse('$totalRaw') ?? 0,
      lastIncome: (lastRaw is num)
          ? lastRaw.toInt()
          : int.tryParse('$lastRaw') ?? 0,
      updatedAt: updatedAtRaw is Timestamp
          ? (updatedAtRaw as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
