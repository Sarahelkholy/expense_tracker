import 'package:expense_tracker/simple_bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/app_view.dart';
import 'package:user_repository/user_repository.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/home/blocs/get_expense_bloc/get_expense_bloc.dart';
import 'package:expense_tracker/screens/profile/blocs/user_bloc/user_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(FirebaseUserRepo()),
        ),
        BlocProvider<GetExpenseBloc>(
          create: (context) =>
              GetExpenseBloc(FirebaseExpenseRepo())..add(GetExpense()),
        ),
      ],
      child: const AppView(),
    ),
  );
}
