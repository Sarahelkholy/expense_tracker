import 'package:expense_tracker/screens/add_expense/presentation/widgets/save_button.dart';
import 'package:expense_tracker/screens/profile/blocs/user_bloc/user_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController incomeController = TextEditingController();
  bool isLoading = false;
  late User user;

  @override
  void initState() {
    user = User.empty;
    user.userId = Uuid().v1();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    incomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserSuccess) {
          Navigator.pop(context);
        } else if (state is UserLoading) {
          isLoading = true;
        }
      },
      child: Scaffold(
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
              TextFormField(
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

              SizedBox(height: 20.h),

              // Add income input
              TextField(
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

              SizedBox(height: 18.h),

              SaveButton(
                isloading: isLoading,
                onPressed: () {
                  setState(() {
                    user.userId = Uuid().v1();
                    user.name = nameController.text;
                    user.totalIncome = user.totalIncome + user.lastIncome;
                    user.lastIncome = int.parse(incomeController.text);
                  });
                  context.read<UserBloc>().add(UpdateUser(user));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
