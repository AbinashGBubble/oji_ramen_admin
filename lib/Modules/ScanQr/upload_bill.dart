import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:loyalty_admin/common/app_spacing.dart';
import 'package:loyalty_admin/common/app_text_styles.dart';
import 'package:loyalty_admin/constant/app_colors.dart';

class UploadBox extends StatelessWidget {
  const UploadBox({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.grey.shade300,
      strokeWidth: 2,
      dashPattern: const [8, 6],
      borderType: BorderType.RRect,
      radius: const Radius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xfff7f7f7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/gallery.png")),
            Gaps.h16,
            Text(
              "Click to upload",
              style: AppTextStyle.bold(size: 18, color: Color(0xff0EA5E9)),
            ),

            Gaps.h12,
            Text(
              "JPG, JPEG, PDF less than 1MB",
              style: AppTextStyle.regular(size: 16, color: Color(0xffA3A3A3)),
            ),
          ],
        ),
      ),
    );
  }
}
