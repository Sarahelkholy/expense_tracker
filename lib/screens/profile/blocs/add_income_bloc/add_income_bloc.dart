import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'add_income_event.dart';
part 'add_income_state.dart';

class AddIncomeBloc extends Bloc<AddIncomeEvent, AddIncomeState> {
  UserRepository userRepository;
  AddIncomeBloc(this.userRepository) : super(AddIncomeInitial()) {
    on<AddIncome>((event, emit) async {
      emit(AddIncomeLoading());
      try {
        await userRepository.addIncome(event.userId, event.amount);

        final updated = await userRepository.getUser(event.userId);

        emit(AddIncomeSuccess(updated));
      } catch (e) {
        emit(AddIncomeFailure());
      }
    });
  }
}
