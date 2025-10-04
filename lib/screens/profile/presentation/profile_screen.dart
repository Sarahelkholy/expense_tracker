import 'package:expense_tracker/screens/add_expense/presentation/widgets/save_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ProfileScreen UI (local-only behavior)
// This screen focuses on UI and local state. Later we'll wire it to Firestore.

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController incomeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // final List<Income> _incomes = [];

  // double get totalIncome => _incomes.fold(0.0, (s, i) => s + i.amount);

  @override
  void dispose() {
    nameController.dispose();
    incomeController.dispose();
    super.dispose();
  }

  void _addIncome() {
    if (incomeController.text.trim().isEmpty) return;
    final value = double.tryParse(incomeController.text.trim());
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    // setState(() {
    //   _incomes.add(Income(amount: value, date: DateTime.now()));
    //   _incomeController.clear();
    // });
  }

  // void _removeIncomeAt(int index) {
  //   setState(() => _incomes.removeAt(index));
  // }

  void _saveName() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Name cannot be empty')));
      return;
    }

    // TODO: replace with Firestore save
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Name saved: $name')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            Form(
              key: _formKey,
              // name
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    CupertinoIcons.person,
                    size: 16.w,
                    color: Colors.grey,
                  ),
                  hintText: 'Enter your name',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Add income input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: incomeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        FontAwesomeIcons.dollarSign,
                        size: 16.w,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter income amount',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // TODO: handle when loading
                SizedBox(
                  height: kToolbarHeight,
                  width: MediaQuery.of(context).size.width / 4,
                  child:
                      // isloading == true
                      //     ? Center(child: CircularProgressIndicator())
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                ),
              ],
            ),

            SizedBox(height: 18.h),

            // Summary card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Income', style: TextStyle(fontSize: 10.sp)),
                        SizedBox(height: 6.h),
                        // Text(
                        // totalIncome.toStringAsFixed(2),
                        //   style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                        // ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Entries', style: TextStyle(fontSize: 10.sp)),
                        SizedBox(height: 6.h),
                        // Text(
                        //   _incomes.length.toString(),
                        //   style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Income history
            // Expanded(
            //   child: _incomes.isEmpty
            //       ? Center(child: Text('No incomes yet. Add one using the form above.'))
            //       : ListView.separated(
            //           itemCount: _incomes.length,
            //           separatorBuilder: (_, __) => SizedBox(height: 8.h),
            //           itemBuilder: (context, index) {
            //             final inc = _incomes.reversed.toList()[index];
            //             final realIndex = _incomes.length - 1 - index;
            //             return Dismissible(
            //               key: ValueKey(inc.date.toIso8601String()),
            //               direction: DismissDirection.endToStart,
            //               onDismissed: (_) => _removeIncomeAt(realIndex),
            //               background: Container(
            //                 padding: EdgeInsets.only(right: 20.w),
            //                 alignment: Alignment.centerRight,
            //                 color: Colors.redAccent,
            //                 child: const Icon(Icons.delete, color: Colors.white),
            //               ),
            //               child: ListTile(
            //                 leading: const Icon(Icons.arrow_upward),
            //                 title: Text(inc.amount.toStringAsFixed(2)),
            //                 subtitle: Text('${inc.date.toLocal()}'),
            //               ),
            //             );
            //           },
            //         ),
            // ),
            SaveButton(onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
