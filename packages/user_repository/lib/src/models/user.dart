// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../entites/user_entity.dart';

class User {
  String userId;
  String name;
  int totalIncome;
  int lastIncome;
  DateTime updatedAt;

  User({
    required this.userId,
    required this.name,
    required this.totalIncome,
    required this.lastIncome,
    required this.updatedAt,
  });

  static final empty = User(
    userId: '',
    name: '',
    totalIncome: 0,
    lastIncome: 0,
    updatedAt: DateTime.now(),
  );

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      name: name,
      totalIncome: totalIncome,
      lastIncome: lastIncome,
      updatedAt: updatedAt,
    );
  }

  static User fromEntity(UserEntity entity) {
    return User(
      userId: entity.userId,
      name: entity.name,
      totalIncome: entity.totalIncome,
      lastIncome: entity.lastIncome,
      updatedAt: entity.updatedAt,
    );
  }
}
