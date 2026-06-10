import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/modules/Dashboard/common_bottom_bar.dart';
import 'package:loyalty_admin/modules/ScanQr/scan_qr_controller.dart';
import 'package:loyalty_admin/modules/redeem/widgets/profile_card.dart';
import 'package:loyalty_admin/modules/redeem/widgets/reward_card.dart';
import 'package:loyalty_admin/modules/redeem/widgets/qr_search_section.dart';
import 'package:loyalty_admin/common/app_spacing.dart';
import 'package:loyalty_admin/common/app_text_styles.dart';

class EnterCodeManuallyScreen extends StatefulWidget {
  const EnterCodeManuallyScreen({super.key});

  @override
  State<EnterCodeManuallyScreen> createState() =>
      _EnterCodeManuallyScreenState();
}

class _EnterCodeManuallyScreenState extends State<EnterCodeManuallyScreen> {
  final _uidController = TextEditingController();
  late final ScanQrController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ScanQrController>();
  }

  @override
  void dispose() {
    _uidController.dispose();
    super.dispose();
  }

  void _onSearch() async {
    final uid = _uidController.text.trim();
    if (uid.isEmpty) return;
    final qrType = controller.isRedeem.value ? 'rewards' : 'profile';
    await controller.handleQrCode('{"uid":"$uid","type":"$qrType"}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: _buildAppBar(),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE
              Text(
                "QR Scanner",
                style: AppTextStyle.bold(size: 28, color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                "Scan customer QR to view profile or redeem reward.",
                style: AppTextStyle.regular(size: 13, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // TABS + SEARCH
              QrSearchSection(
                controller: controller,
                uidController: _uidController,
                onSearch: _onSearch,
              ),

              const SizedBox(height: 24),

              // RESULT CARD
              if (!controller.isRedeem.value &&
                  controller.showProfileData.value)
                ProfileCard(controller: controller),

              if (controller.isRedeem.value && controller.showRewardData.value)
                RewardCard(controller: controller),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                // LOGO
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD92D67),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "LA",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                Gaps.w12,

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Loyalty Admin",
                      style: AppTextStyle.semiBold(size: 18, color: Colors.black),
                    ),
                    Text(
                      "Restaurant Management",
                      style: AppTextStyle.regular(size: 12, color: Colors.grey),
                    ),
                  ],
                ),

                const Spacer(),

                // LOGOUT
                GestureDetector(
                  onTap: () => Get.offAll(() => const CommonBottomBar()),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.logout, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}