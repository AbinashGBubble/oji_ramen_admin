import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loyalty_admin/common/app_text_styles.dart';
import 'package:loyalty_admin/constant/app_colors.dart';
import 'package:loyalty_admin/constant/app_icons_constant.dart';

class AnalyticsDataCard extends StatelessWidget {
  final String title;
  final String value;
  //final List<double> points;

  const AnalyticsDataCard({
    super.key,
    required this.title,
    required this.value,
    //required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFFDF3E9)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          // LEFT TEXT
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.regular(
                    size: 14.sp,
                    color: AppColors.black,
                  ),),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: AppTextStyle.semiBold(
                    size: 28.sp,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),

          Image(image: AssetImage(IconConsts.analyticsGraph), height: 80),

          // RIGHT LINE GRAPH
          // Expanded(
          //   flex: 5,
          //   child: CustomPaint(
          //     painter: LineGraph(points),
          //   ),
          // ),
        ],
      ),
    );
  }
}

// Custom Painter for the orange line graph
class LineGraph extends CustomPainter {
  final List<double> points;

  LineGraph(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();

    double gap = size.width / (points.length - 1);

    for (int i = 0; i < points.length; i++) {
      double x = i * gap;
      double y = size.height - (points[i] * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
