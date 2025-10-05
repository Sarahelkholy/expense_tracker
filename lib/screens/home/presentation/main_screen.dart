import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/home/presentation/widgets/total_balance_container.dart';
import 'package:expense_tracker/screens/home/presentation/widgets/transaction_card.dart';
import 'package:expense_tracker/screens/profile/presentation/profile_screen.dart';
import 'package:expense_tracker/screens/profile/blocs/user_bloc/user_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  final List<Expense> expenses;
  const MainScreen(this.expenses, {super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final double totalExpenses;
  String? _uid; // will hold firebase uid OR local persisted id
  static const _kLocalUserIdKey = 'local_user_id';

  @override
  void initState() {
    super.initState();
    totalExpenses = widget.expenses.fold(0.0, (sum, e) => sum + e.amount);
    _initUserIdAndLoad();
  }

  Future<void> _initUserIdAndLoad() async {
    // Determine id: prefer firebase uid
    final fbUid = fb_auth.FirebaseAuth.instance.currentUser?.uid;

    if (fbUid != null && fbUid.isNotEmpty) {
      _uid = fbUid;
    } else {
      // read local persisted id (may be null)
      final prefs = await SharedPreferences.getInstance();
      final localId = prefs.getString(_kLocalUserIdKey);
      _uid = localId;
      // if still null, nothing to load (user hasn't created a profile yet)
    }

    // dispatch GetUser only if an id exists
    if (_uid != null && _uid!.isNotEmpty) {
      // we dispatch after the first frame to ensure context.read<UserBloc>() is available
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<UserBloc>().add(GetUser(_uid!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                String displayName = 'User';
                double totalIncome = 0.0;

                double lastIncome = 0.0;

                if (state is UserSuccess) {
                  final user = state.user;
                  displayName = user.name.isNotEmpty ? user.name : displayName;
                  totalIncome = user.totalIncome.toDouble();
                  lastIncome = user.lastIncome.toDouble();
                }

                final balance = totalIncome - totalExpenses;

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 45.w,
                                  height: 45.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.yellow[700],
                                  ),
                                ),
                                Icon(
                                  CupertinoIcons.person_fill,
                                  color: Colors.yellow[800],
                                ),
                              ],
                            ),
                            SizedBox(width: 6.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                                ),
                                Text(
                                  displayName,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(CupertinoIcons.settings),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const ProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    TotalBalanceContainer(
                      totalExpenses: totalExpenses,
                      lastIncome: lastIncome,
                      balance: balance,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: ListView.builder(
                itemCount: widget.expenses.length,
                itemBuilder: (context, index) {
                  final tObj = widget.expenses[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: TransactionCard(tObj: tObj),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
