import 'package:flutter/material.dart';
import 'package:loyalty_admin/constant/app_colors.dart';
import 'package:loyalty_admin/common/app_text_styles.dart';
import 'package:loyalty_admin/modules/ScanQr/scan_qr_controller.dart';

class QrSearchSection extends StatelessWidget {
  final ScanQrController controller;
  final TextEditingController uidController;
  final VoidCallback onSearch;

  const QrSearchSection({
    super.key,
    required this.controller,
    required this.uidController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TABS
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: _tabButton(
                  title: "Check Profile",
                  icon: Icons.person_outline,
                  selected: !controller.isRedeem.value,
                  onTap: () {
                    controller.isRedeem.value = false;
                    uidController.clear(); 
                  },
                ),
              ),
              Expanded(
                child: _tabButton(
                  title: "Redeem Reward",
                  icon: Icons.card_giftcard_outlined,
                  selected: controller.isRedeem.value,
                  onTap: () {
                    controller.isRedeem.value = true;
                    uidController.clear(); 
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // SEARCH INPUT
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.isRedeem.value
                    ? "Enter Reward Code"
                    : "Enter Mobile Number",
                style: AppTextStyle.regular(size: 13, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: uidController,
                      decoration: InputDecoration(
                        hintText: "USR-XXXX",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                      ),
                      onPressed: controller.isLoading.value ? null : onSearch,
                      icon: controller.isLoading.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.search,
                              color: Colors.white, size: 18),
                      label: Text(
                        controller.isLoading.value ? "" : "Search",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tabButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? const Color(0xFF1F2937) : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: selected ? const Color(0xFF1F2937) : Colors.grey,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}