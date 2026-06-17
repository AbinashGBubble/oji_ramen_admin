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
     if (!controller.isRedeem.value && uid.length < 10) {
      Get.snackbar("Invalid Number", "Please enter a valid 10-digit mobile number");
      
      return;
    }
    await controller.handleQrCode('{"uid":"$uid","type":"$qrType"}');
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: AssetImage('assets/icons/Oji_log.png'),
              height: 40,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Oji Ramen',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Rewards Admin',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade200),
        ),
      ),
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
}