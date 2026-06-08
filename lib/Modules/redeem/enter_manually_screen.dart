import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/Modules/Auth/login_controller.dart';
import 'package:loyalty_admin/Modules/Dashboard/common_bottom_bar.dart';
import 'package:loyalty_admin/Modules/ScanQr/scan_qr_controller.dart';
import 'package:loyalty_admin/common/app_spacing.dart';
import 'package:loyalty_admin/common/app_text_styles.dart';

class EnterCodeManuallyScreen extends StatelessWidget {
  const EnterCodeManuallyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScanQrController>();
    final LoginController loginController = Get.put(LoginController());
    //final loginController = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),

        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,

            boxShadow: [
              BoxShadow(
                color: Color(0x14000000),

                blurRadius: 10,

                offset: Offset(0, 4),
              ),
            ],
          ),

          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),

              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,

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

                          fontSize: 22,
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

                        style: AppTextStyle.semiBold(
                          size: 20,

                          color: Colors.black,
                        ),
                      ),

                      Text(
                        "Restaurant Management",

                        style: AppTextStyle.regular(
                          size: 13,

                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  GestureDetector(
                    onTap: () {
                      //loginController.logOut();
                      Get.offAll(() => const CommonBottomBar());
                    },

                    child: Container(
                      padding: const EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),

                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: const Icon(Icons.logout),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(18),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 10),

              Text(
                "QR Scanner",

                style: AppTextStyle.bold(size: 32, color: Colors.black),
              ),

              const SizedBox(height: 4),

              Text(
                "Scan customer QR to view profile or redeem reward.",

                style: AppTextStyle.regular(size: 14, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              //----------------------------------
              // TABS
              //----------------------------------
              Container(
                padding: const EdgeInsets.all(4),

                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),

                  borderRadius: BorderRadius.circular(14),
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: tabButton(
                        title: "Check Profile",

                        icon: Icons.person_outline,

                        selected: !controller.isRedeem.value,

                        onTap: () {
                          controller.isRedeem.value = false;

                          controller.showData.value = false;
                        },
                      ),
                    ),

                    Expanded(
                      child: tabButton(
                        title: "Redeem Reward",

                        icon: Icons.card_giftcard,

                        selected: controller.isRedeem.value,

                        onTap: () {
                          controller.isRedeem.value = true;

                          controller.showData.value = false;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              //----------------------------------
              // SEARCH
              //----------------------------------
              Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(18),

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
                    Text(
                      controller.isRedeem.value
                          ? "Enter Reward UID"
                          : "Enter Profile UID",

                      style: AppTextStyle.medium(size: 14, color: Colors.black),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            // controller:
                            // controller
                            //     .textController,
                            decoration: InputDecoration(
                              hintText: "Enter UID",

                              filled: true,

                              fillColor: const Color(0xFFF5F5F5),

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        SizedBox(
                          height: 52,

                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD92D67),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            onPressed: controller.isLoading.value
                                ? null
                                : () async {
                                    // await controller
                                    //     .manualSearch();
                                  },

                            icon: controller.isLoading.value
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,

                                    child: CircularProgressIndicator(
                                      color: Colors.white,

                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.search, color: Colors.white),

                            label: const Text(
                              "Search",

                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              //----------------------------------
              // DATA CARD
              //----------------------------------
              if (controller.showData.value) buildDataCard(controller),
            ],
          ),
        );
      }),
    );
  }

  //----------------------------------
  // DATA CARD
  //----------------------------------

  Widget buildDataCard(ScanQrController controller) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),

            blurRadius: 12,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          //----------------------------------
          // PROFILE UI
          //----------------------------------
          if (!controller.isRedeem.value)
            Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF22C55E)),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        "User Profile",

                        style: AppTextStyle.bold(
                          size: 28,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),

                        borderRadius: BorderRadius.circular(30),
                      ),

                      child: const Text(
                        "ACTIVE",

                        style: TextStyle(
                          color: Colors.white,

                          fontWeight: FontWeight.w700,

                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                infoRow(
                  "UID",
                  controller.profileUid,

                  "Mobile",
                  controller.profileMobile,
                ),

                const SizedBox(height: 24),

                infoRow(
                  "Name",
                  controller.profileName,

                  "Tier",
                  controller.profileTier,
                ),

                const SizedBox(height: 24),

                infoRow(
                  "Visits",
                  controller.profileVisits,

                  "Rewards",
                  controller.profileRewards,
                ),

                const SizedBox(height: 26),

                //----------------------------------
                // ADD VISIT CARD
                //----------------------------------
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBFC),

                    borderRadius: BorderRadius.circular(20),

                    border: Border.all(color: const Color(0xFFF3D6E1)),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.insert_chart_outlined,

                            color: Color(0xFFD92D67),
                          ),

                          const SizedBox(width: 10),

                          Text(
                            "Add Visits",

                            style: AppTextStyle.bold(
                              size: 24,

                              color: const Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Record this visit on the customer's app",

                        style: AppTextStyle.regular(
                          size: 13,

                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 52,

                        child: ElevatedButton(
                          onPressed: () {},

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD94B63),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),

                          child: const Text(
                            "+ Add 1 Visit",

                            style: TextStyle(
                              color: Colors.white,

                              fontWeight: FontWeight.w700,

                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          //----------------------------------
          // REWARD UI
          //----------------------------------
          if (controller.isRedeem.value)
            Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF22C55E)),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        "Valid Reward",

                        style: AppTextStyle.bold(
                          size: 28,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                rewardItem("Code", controller.rewardCode),

                const SizedBox(height: 22),

                rewardItem("Reward", controller.rewardName),

                const SizedBox(height: 22),

                rewardItem("User", controller.rewardUser),

                const SizedBox(height: 22),

                rewardItem("Tier", controller.rewardTier),

                const SizedBox(height: 30),

                //----------------------------------
                // CONFIRM BUTTON
                //----------------------------------
                SizedBox(
                  width: double.infinity,

                  height: 56,

                  child: Obx(() {
                    return ElevatedButton.icon(
                     onPressed: (){},
                      // onPressed: controller.isRedeeming.value
                      //     ? null
                      //     : () {
                      //         controller.confirmReward();
                      //       },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD94B63),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      // icon: controller.isRedeeming.value
                      //     ? const SizedBox(
                      //         width: 18,
                      //         height: 18,

                      //         child: CircularProgressIndicator(
                      //           color: Colors.white,

                      //           strokeWidth: 2,
                      //         ),
                      //       )
                      //     : const Icon(Icons.check_circle, color: Colors.white),

                      label: Text(
                       "Confirm Visits",

                        style: const TextStyle(
                          color: Colors.white,

                          fontWeight: FontWeight.w700,

                          fontSize: 16,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 40,)
        ],
      ),
    );
  }

  //----------------------------------
  // TAB
  //----------------------------------

  Widget tabButton({
    required String title,

    required IconData icon,

    required bool selected,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: const EdgeInsets.symmetric(vertical: 14),

        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,

          borderRadius: BorderRadius.circular(12),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 18, color: selected ? Colors.black : Colors.grey),

            const SizedBox(width: 8),

            Text(
              title,

              style: TextStyle(
                color: selected ? Colors.black : Colors.grey,

                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //----------------------------------
  // INFO ROW
  //----------------------------------

  Widget infoRow(String title1, String value1, String title2, String value2) {
    return Row(
      children: [
        Expanded(child: rewardItem(title1, value1)),

        Expanded(child: rewardItem(title2, value2)),
      ],
    );
  }

  //----------------------------------
  // ITEM
  //----------------------------------

  Widget rewardItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        ),

        const SizedBox(height: 6),

        Text(
          value,

          style: const TextStyle(
            color: Color(0xFF111827),

            fontSize: 18,

            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
