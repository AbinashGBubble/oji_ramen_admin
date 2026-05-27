import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/Modules/Dashboard/analytics_screen.dart';
import 'package:loyalty_admin/Modules/Dashboard/widget/analytics_card.dart';
import 'package:loyalty_admin/Modules/Dashboard/widget/offer_list_card.dart';
import 'package:loyalty_admin/Modules/Dashboard/widget/quick_action_card.dart';
import 'package:loyalty_admin/Modules/ScanQr/qr_screen.dart';
import 'package:loyalty_admin/Modules/redeem/enter_manually_screen.dart';
import 'package:loyalty_admin/common/app_spacing.dart';
import 'package:loyalty_admin/common/app_text_styles.dart';
import 'package:loyalty_admin/constant/app_colors.dart';
import 'package:loyalty_admin/constant/app_icons_constant.dart';
import 'package:loyalty_admin/services/storage/secure_storage_service.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  List<String> dummyData = ["a", "b", "c"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.2,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0x1C000000),
                offset: const Offset(0, 4),
                blurRadius: 9.9,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Logo + Text Row (replaced AppBar)
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "LA",
                            style: AppTextStyle.semiBold(
                              size: 20,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      Gaps.w12,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Loyalty Admin",
                            style: AppTextStyle.semiBold(
                              size: 20,
                              color: AppColors.black,
                            ),
                          ),
                          Text(
                            "Restaurant Management",
                            style: AppTextStyle.regular(
                              size: 14,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gaps.h16,
                  // Greeting Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good Morning, Admin",
                        style: AppTextStyle.bold(
                          size: 24,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        "Here's what's happening with your loyalty program today",
                        style: AppTextStyle.regular(
                          size: 13,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 20),
        child: ListView(
          children: [
            //quick actions cards
            Gaps.h20,
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Quick Actions",
                style: AppTextStyle.bold(size: 20, color: AppColors.black),
              ),
            ),
            Gaps.h24,
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: GridView.count(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
                children: [
                  DashboardCard(
                    image: IconConsts.qrCodeScan,
                    title: "Scan QR",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnterCodeManuallyScreen(),
                        ),
                      );
                    },
                  ),
                  DashboardCard(
                    image: IconConsts.campain,
                    title: "Create Campaign",
                    onTap: () {},
                  ),
                  DashboardCard(
                    image: IconConsts.tiers,
                    title: "Manage Tiers",
                    onTap: () {},
                  ),
                  DashboardCard(
                    image: IconConsts.points,
                    title: "Manage Point Rules",
                    onTap: () {},
                  ),
                  DashboardCard(
                    image: IconConsts.notification,
                    title: "Send Notifications",
                    onTap: () {},
                  ),
                  DashboardCard(
                    image: IconConsts.transactions,
                    title: "View Transactions",
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Gaps.h24,
            //analytics card
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Analytics",
                    style: AppTextStyle.bold(size: 20, color: AppColors.black),
                  ),
                  GestureDetector(
                    onTap: openAnalyticsPage,
                    child: Row(
                      children: [
                        Text(
                          "View All",
                          style: AppTextStyle.medium(
                            size: 15,
                            color: AppColors.primary,
                          ),
                        ),
                        Gaps.w4,
                        Icon(Icons.arrow_forward, color: AppColors.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //
            Gaps.h16,
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: AnalyticsDataCard(
                title: "Daily Data",
                value: "2,246",
                //points: [0.2, 0.35, 0.33, 0.45, 0.40, 0.60, 0.50],
              ),
            ),
            Gaps.h16,
            //recent activity
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Activity",
                    style: AppTextStyle.bold(size: 20, color: AppColors.black),
                  ),
                  Row(
                    children: [
                      Text(
                        "View All",
                        style: AppTextStyle.medium(
                          size: 15,
                          color: AppColors.primary,
                        ),
                      ),
                      Gaps.w4,
                      Icon(Icons.arrow_forward, color: AppColors.primary),
                    ],
                  ),
                ],
              ),
            ),
            //
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                height: dummyData.length * 150,
                child: ListView.builder(
                  shrinkWrap: false,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: dummyData.length,
                  itemBuilder: (context, index) {
                    return OfferCard(
                      title: "20% Off Next Order",
                      subtitle: "Classic Tomato and Mozzarella",
                      points: "200 Points",
                      onTap: () {},
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openAnalyticsPage() async {
    Get.to(() => const AnalyticsScreen());
  }
}
