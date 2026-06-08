import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/Modules/Auth/login_controller.dart';
import 'package:loyalty_admin/common/app_spacing.dart';
import 'package:loyalty_admin/common/app_text_styles.dart';
import 'package:loyalty_admin/common/common_button.dart';
import 'package:loyalty_admin/constant/app_colors.dart';
import 'package:loyalty_admin/constant/app_icons_constant.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(IconConsts.loginBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 30.dg,right: 30.dg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome Back",
                style: AppTextStyle.semiBold(
                  size: 28.sp,
                  color: AppColors.primary,
                ),
              ),
              Gaps.h8,
              Text(
                "Sign in to manage your rewards platform",
                style: AppTextStyle.regular(
                  size: 13.sp,
                  color: Color(0xff434343),
                ),
              ),
              Gaps.h20,
              Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email",
                    hintStyle: AppTextStyle.regular(
                      size: 11,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Gaps.h20,
              Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextField(
                  controller: controller.passWordController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    hintStyle: AppTextStyle.regular(
                      size: 11,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              //login button
              Gaps.h20,
              CommonButton(text: "Sign In", 
              backgroundColor: Color(0xffD7425B),
              onPressed: () {

                controller.loginUser();

                // Navigator.push(context, MaterialPageRoute(builder: (context) => CommonBottomBar()));

              }),
              Gaps.h20,
            ],
          ),
        ),
      ),
    );
  }
}
