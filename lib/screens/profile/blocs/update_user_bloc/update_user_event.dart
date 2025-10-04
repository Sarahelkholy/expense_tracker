part of 'update_user_bloc.dart';

sealed class UpdateUserEvent extends Equatable {
  const UpdateUserEvent();

  @override
  List<Object> get props => [];
}

class UpdateUser extends UpdateUserEvent {
  final User user;

  const UpdateUser(this.user);
  @override
  List<Object> get props => [user];
}
