import '../user_repository.dart';

abstract class UserRepository {
  Future<void> createUser(User user);

  Future<User> getUser(String userId);

  Future<void> updateUser(User user);

  Future<void> addIncome(String userId, int amount);
}
