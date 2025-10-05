import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<CreateUser>(_onCreateUser);
    on<GetUser>(_onGetUser);
    on<UpdateUser>(_onUpdateUser);
    on<AddIncome>(_onAddIncome);
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await userRepository.createUser(event.user);
      final createdUser = await userRepository.getUser(event.user.userId);
      emit(UserSuccess(createdUser));
    } catch (e) {
      emit(UserFailure());
    }
  }

  Future<void> _onGetUser(GetUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await userRepository.getUser(event.userId);
      emit(UserSuccess(user));
    } catch (e) {
      emit(UserFailure());
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await userRepository.updateUser(event.user);
      final updatedUser = await userRepository.getUser(event.user.userId);
      emit(UserSuccess(updatedUser));
    } catch (e) {
      emit(UserFailure());
    }
  }

  Future<void> _onAddIncome(AddIncome event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await userRepository.addIncome(event.userId, event.amount);
      final updatedUser = await userRepository.getUser(event.userId);
      emit(UserSuccess(updatedUser));
    } catch (e) {
      emit(UserFailure());
    }
  }
}
