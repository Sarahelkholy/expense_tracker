import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final isloading;
  const SaveButton({super.key, required this.onPressed, this.isloading});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: kToolbarHeight,
      child: isloading == true
          ? Center(child: CircularProgressIndicator())
          : TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(15.r),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(fontSize: 20.sp, color: Colors.white),
              ),
            ),
    );
  }
}
