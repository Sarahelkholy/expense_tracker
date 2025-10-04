part of 'add_income_bloc.dart';

sealed class AddIncomeState extends Equatable {
  const AddIncomeState();

  @override
  List<Object> get props => [];
}

final class AddIncomeInitial extends AddIncomeState {}

final class AddIncomeLoading extends AddIncomeState {}

final class AddIncomeFailure extends AddIncomeState {}

final class AddIncomeSuccess extends AddIncomeState {
  final User user;
  const AddIncomeSuccess(this.user);
  @override
  List<Object> get props => [user];
}
