import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:user_repository/user_repository.dart';
import 'package:expense_tracker/screens/add_expense/presentation/widgets/save_button.dart';
import 'package:expense_tracker/screens/profile/blocs/user_bloc/user_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();
  bool _isLoading = false;
  bool _isCreating = false;
  bool _initialCheckDone = false;
  bool _userExists = false;
  late String _userId;
  late User _user;

  static const _kLocalUserIdKey = 'local_user_id';

  @override
  void initState() {
    super.initState();
    _user = User.empty;
    _prepareUserIdAndLoad();
  }

  @override
  void dispose() {
    incomeController.dispose();
    super.dispose();
  }

  Future<void> _prepareUserIdAndLoad() async {
    setState(() => _isLoading = true);

    // Determine userId: prefer firebase auth uid
    final fbUid = fb_auth.FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    String? localId = prefs.getString(_kLocalUserIdKey);

    if (fbUid != null && fbUid.isNotEmpty) {
      _userId = fbUid;
    } else if (localId != null && localId.isNotEmpty) {
      _userId = localId;
    } else {
      _userId = const Uuid().v4();
      await prefs.setString(_kLocalUserIdKey, _userId);
    }

    try {
      final repo = RepositoryProvider.of<UserRepository>(context);
      final fetched = await repo.getUser(_userId);
      if (fetched != User.empty) {
        _userExists = true;
        _user = fetched;
        nameController.text = _user.name;
      } else {
        _userExists = false;
        _user = User.empty..userId = _userId;
      }
    } catch (_) {
      _userExists = false;
      _user = User.empty..userId = _userId;
    } finally {
      setState(() {
        _initialCheckDone = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _onSavePressed() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Name cannot be empty')));
      return;
    }

    final incomeText = incomeController.text.trim();
    final parsedIncome = incomeText.isEmpty ? 0 : int.tryParse(incomeText) ?? 0;

    if (incomeText.isNotEmpty && int.tryParse(incomeText) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final bloc = context.read<UserBloc>();

    if (!_userExists) {
      // Create user
      _isCreating = true;
      final newUser = User(
        userId: _userId,
        name: name,
        totalIncome: parsedIncome,
        lastIncome: parsedIncome,
        updatedAt: DateTime.now(),
      );
      bloc.add(CreateUser(newUser));
    } else {
      // Update name if changed
      if (_user.name != name) {
        final updated = User(
          userId: _user.userId,
          name: name,
          totalIncome: _user.totalIncome,
          lastIncome: _user.lastIncome,
          updatedAt: DateTime.now(),
        );
        bloc.add(UpdateUser(updated));
        _user = updated;
      }
      // Add income if provided
      if (parsedIncome > 0) {
        bloc.add(AddIncome(_user.userId, parsedIncome));
      } else {
        // Just name change: show message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile updated')));
        // optionally pop
      }
    }
  }

  Widget _withListeners({required Widget child}) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }

        if (state is UserSuccess) {
          if (_isCreating) {
            _isCreating = false;
            _userExists = true;
            _user = state.user;

            Navigator.of(context).pop();
          }
        }
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialCheckDone) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _withListeners(
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
              TextField(
                controller: incomeController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    FontAwesomeIcons.dollarSign,
                    size: 16.w,
                    color: Colors.grey,
                  ),
                  hintText: 'Enter income amount (optional)',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              SaveButton(isloading: _isLoading, onPressed: _onSavePressed),
            ],
          ),
        ),
      ),
    );
  }
}
