part of 'create_user_bloc.dart';

sealed class CreateUserEvent extends Equatable {
  const CreateUserEvent();

  @override
  List<Object> get props => [];
}

class CreateUser extends CreateUserEvent {
  final User user;

  const CreateUser(this.user);

  @override
  List<Object> get props => [user];
}
