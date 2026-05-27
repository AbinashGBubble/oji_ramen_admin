import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loyalty_admin/common/app_spacing.dart';
import 'package:loyalty_admin/common/app_text_styles.dart';
import 'package:loyalty_admin/constant/app_colors.dart';
import 'package:loyalty_admin/constant/app_icons_constant.dart';

class OfferCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String points;
  final VoidCallback onTap;

  const OfferCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.points,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            offset: Offset(0, 0),
            blurRadius: 7.9,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Color(0xffF4F4F5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image(image: AssetImage(IconConsts.offer),height: 24,),
            ),
          ),

          const SizedBox(width: 16),

          // Title + Subtitle + Points
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.bold(
                    size: 12,
                    color: AppColors.black,
                  ),
                ),
                Gaps.h4,
                Text(
                  subtitle,
                  style: AppTextStyle.regular(
                    size: 12,
                    color: AppColors.black,
                  ),
                ),
                Gaps.h4,
                Text(
                  points,
                   style: AppTextStyle.medium(
                    size: 10,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Offer Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xffB3FFB7),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "Offer",
              style: AppTextStyle.medium(
                    size: 10,
                    color: AppColors.black,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
