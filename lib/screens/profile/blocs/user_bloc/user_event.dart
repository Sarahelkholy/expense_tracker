part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class CreateUser extends UserEvent {
  final User user;
  const CreateUser(this.user);

  @override
  List<Object> get props => [user];
}

class GetUser extends UserEvent {
  final String userId;
  const GetUser(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateUser extends UserEvent {
  final User user;
  const UpdateUser(this.user);

  @override
  List<Object> get props => [user];
}

class AddIncome extends UserEvent {
  final String userId;
  final int amount;
  const AddIncome(this.userId, this.amount);

  @override
  List<Object> get props => [userId, amount];
}
