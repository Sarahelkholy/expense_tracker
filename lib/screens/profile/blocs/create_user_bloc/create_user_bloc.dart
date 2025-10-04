import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'create_user_event.dart';
part 'create_user_state.dart';

class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState> {
  UserRepository userRepository;
  CreateUserBloc(this.userRepository) : super(CreateUserInitial()) {
    on<CreateUser>((event, emit) async {
      emit(CreateUserLoading());
      try {
        await userRepository.createUser(event.user);
        emit(CreateUserSuccess());
      } catch (e) {
        emit(CreateUserFailure());
      }
    });
  }
}
