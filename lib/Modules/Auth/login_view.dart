import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/modules/Auth/login_controller.dart';
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
          padding: EdgeInsets.only(left: 30.dg, right: 30.dg),
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
                  color: const Color(0xff434343),
                ),
              ),
              Gaps.h20,

              // ── Email Field ──────────────────────────────────────────────
              Container(
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: "Email",
                      hintStyle: AppTextStyle.regular(
                        size: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),

              Gaps.h20,

              // ── Password Field (reactive) ────────────────────────────────
              Obx(
                () => Container(
                  height: 60.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(                          // ← add this
                    child: TextField(
                      controller: controller.passWordController,
                      obscureText: !controller.isPasswordVisible.value,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: "Password",
                        hintStyle: AppTextStyle.regular(
                          size: 14.sp,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                            size: 20.sp,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Gaps.h20,

              // ── Sign In Button ───────────────────────────────────────────
              CommonButton(
                text: "Sign In",
                backgroundColor: const Color(0xffD7425B),
                onPressed: () => controller.loginUser(),
              ),

              Gaps.h20,
            ],
          ),
        ),
      ),
    );
  }
}