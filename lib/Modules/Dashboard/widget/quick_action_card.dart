import 'package:flutter/material.dart';
import 'package:loyalty_admin/common/app_text_styles.dart';
import 'package:loyalty_admin/constant/app_colors.dart';

class DashboardCard extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 130,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1A000000),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(image),height: 30,),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.regular(size: 10, color: AppColors.black),
            ),
          ],
        ),
      ),
    );
  }
}
