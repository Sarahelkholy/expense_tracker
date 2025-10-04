// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_expense_bloc.dart';

sealed class GetExpenseEvent extends Equatable {
  const GetExpenseEvent();

  @override
  List<Object> get props => [];
}

class GetExpense extends GetExpenseEvent {}
