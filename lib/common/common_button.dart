import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed; // ✅ NON-NULL
  final Color backgroundColor;
  final double height;
  final double fontSize;
  final bool isLoading; // ✅ for loader

  const CommonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.orange,
    this.height = 50,
    this.fontSize = 15,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading
              ? Colors.grey // ✅ disabled look
              : backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        onPressed: isLoading ? () {} : onPressed, // ✅ NEVER NULL
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: fontSize.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}