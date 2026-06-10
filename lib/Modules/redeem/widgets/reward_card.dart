import 'package:flutter/material.dart';
import 'package:loyalty_admin/constant/app_colors.dart';
import 'package:loyalty_admin/common/app_text_styles.dart';
import 'package:loyalty_admin/modules/ScanQr/scan_qr_controller.dart';

class RewardCard extends StatelessWidget {
  final ScanQrController controller;

  const RewardCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF6EA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF22C55E),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Valid Reward",
                style: AppTextStyle.bold(size: 22, color: const Color(0xFF1F2937)),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 20),

          // CODE
          _rewardRow(label: "Code", value: controller.rewardCode),
          const SizedBox(height: 16),

          // REWARD NAME
          _rewardRow(label: "Reward", value: controller.rewardName),
          const SizedBox(height: 16),

          // USER
          _rewardRow(label: "User", value: controller.rewardUser),
          const SizedBox(height: 16),

          // TIER
          _rewardRow(label: "Tier", value: controller.rewardTier),

          const SizedBox(height: 28),

          // CONFIRM BUTTON
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => controller.confirmReward(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.check_circle_outline,
                  color: Colors.white, size: 18),
              label: const Text(
                "Confirm Visits",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rewardRow({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? '—' : value,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}