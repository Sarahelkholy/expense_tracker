import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'update_user_event.dart';
part 'update_user_state.dart';

class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserState> {
  UserRepository userRepository;
  UpdateUserBloc(this.userRepository) : super(UpdateUserInitial()) {
    on<UpdateUser>((event, emit) async {
      emit(UpdateUserLoading());
      try {
        await userRepository.updateUser(event.user);
        emit(UpdateUserSuccess(event.user));
      } catch (e) {
        emit(UpdateUserFailure());
      }
    });
  }
}
