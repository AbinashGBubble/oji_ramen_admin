import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/constant/app_colors.dart';
import 'package:loyalty_admin/common/app_text_styles.dart';
import 'package:loyalty_admin/modules/ScanQr/scan_qr_controller.dart';

class ProfileCard extends StatelessWidget {
  final ScanQrController controller;

  const ProfileCard({super.key, required this.controller});

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
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF6EA),
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
                "User Profile",
                style: AppTextStyle.bold(size: 22, color: const Color(0xFF1F2937)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "ACTIVE",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 20),

          // UID + MOBILE
          _infoGrid(
            label1: "UID",
            value1: controller.profileUid,
            label2: "Mobile",
            value2: controller.profileMobile,
            truncateFirst: true,
          ),

          const SizedBox(height: 18),

          // NAME + TIER
          _infoGrid(
            label1: "Name",
            value1: controller.profileName,
            label2: "Tier",
            value2: controller.profileTier,
          ),

          const SizedBox(height: 18),

          // VISITS + REWARDS
          _infoGrid(
            label1: "Visits",
            value1: controller.profileVisits,
            label2: "Rewards",
            value2: controller.profileRewards,
          ),

          const SizedBox(height: 24),

          // ADD VISIT SECTION
          _AddVisitSection(controller: controller),
        ],
      ),
    );
  }

  Widget _infoGrid({
    required String label1,
    required String value1,
    required String label2,
    required String value2,
    bool truncateFirst = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: _infoItem(
            label: label1,
            value: value1,
            truncate: truncateFirst,
          ),
        ),
        Expanded(
          child: _infoItem(label: label2, value: value2),
        ),
      ],
    );
  }

  Widget _infoItem({
    required String label,
    required String value,
    bool truncate = false,
  }) {
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
          value,
          maxLines: truncate ? 1 : null,
          overflow: truncate ? TextOverflow.ellipsis : null,
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

// ─────────────────────────────────────────
// ADD VISIT SECTION (separate widget)
// ─────────────────────────────────────────

class _AddVisitSection extends StatelessWidget {
  final ScanQrController controller;

  const _AddVisitSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3D6E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                "Add Visits",
                style: AppTextStyle.bold(size: 18, color: const Color(0xFF1F2937)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Record this visit on the customer's app",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
          const SizedBox(height: 16),

          Obx(() {
            final isDisabled =
                controller.isAddingVisit.value || controller.visitAdded.value;

            return SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isDisabled ? null : () => controller.addVisit(),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDisabled ? Colors.grey.shade300 : AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isAddingVisit.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        controller.visitAdded.value
                            ? "✓  Visit Added"
                            : "+ Add 1 Visit",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }
}