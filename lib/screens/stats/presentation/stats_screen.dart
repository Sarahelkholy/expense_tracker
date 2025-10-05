// stats_screen.dart
import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/home/presentation/widgets/transaction_card.dart';
import 'package:expense_tracker/screens/stats/presentation/widgets/my_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsScreen extends StatefulWidget {
  final List<Expense> expenses;

  const StatsScreen(this.expenses, {super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),

            AspectRatio(
              aspectRatio: 1.2,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 20.h,
                  ),
                  child: MyChart(expenses: widget.expenses),
                ),
              ),
            ),

            SizedBox(height: 10.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),

            Expanded(
              child: widget.expenses.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: 40.h),
                        Center(
                          child: Text(
                            'No transactions yet',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(top: 4.h, bottom: 12.h),
                      itemCount: widget.expenses.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final tObj = widget.expenses[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.w),
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
