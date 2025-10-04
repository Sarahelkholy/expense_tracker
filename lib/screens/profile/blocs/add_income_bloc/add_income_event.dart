part of 'add_income_bloc.dart';

sealed class AddIncomeEvent extends Equatable {
  const AddIncomeEvent();

  @override
  List<Object> get props => [];
}

class AddIncome extends AddIncomeEvent {
  final String userId;
  final int amount;

  const AddIncome(this.userId, this.amount);
  @override
  List<Object> get props => [userId, amount];
}
