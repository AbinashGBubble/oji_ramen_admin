import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/Modules/ScanQr/earn_redeem_screen.dart';
import 'package:loyalty_admin/Modules/redeem/get_all_user_controller.dart';
import 'package:loyalty_admin/Modules/redeem/get_all_user_model.dart';
import 'package:loyalty_admin/common/app_spacing.dart';
import 'package:loyalty_admin/common/app_text_styles.dart';
import 'package:loyalty_admin/constant/app_colors.dart';
import 'package:loyalty_admin/routes/app_routes.dart';

class EnterCodeManuallyScreen extends StatelessWidget {
  EnterCodeManuallyScreen({super.key});

  final GetAllUserController controller = Get.put(GetAllUserController());

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        controller.loadMore();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x1C000000),
                offset: Offset(0, 4),
                blurRadius: 9.9,
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
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
                            size: 20, color: AppColors.white),
                      ),
                    ),
                  ),
                  Gaps.w12,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Loyalty Admin",
                          style: AppTextStyle.semiBold(
                              size: 20, color: AppColors.black)),
                      Text("Restaurant Management",
                          style: AppTextStyle.regular(
                              size: 14, color: AppColors.grey)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            /// BACK BUTTON
            Row(
              children: [
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back)),
                Gaps.w12,
                Text("Select User",
                    style: AppTextStyle.semiBold(
                        size: 16, color: AppColors.black)),
              ],
            ),

            Gaps.h20,

            /// SEARCH BAR
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x20000000),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                  )
                ],
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Search user or ID",
                  hintStyle:
                      AppTextStyle.regular(size: 14, color: Colors.grey),
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel_outlined,
                        color: Colors.grey),
                    onPressed: () {
                      controller.searchController.clear();
                      controller.onSearchChanged('');
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            Gaps.h20,

            /// USER LIST
            Expanded(
              child: Obx(() {

                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (controller.users.isEmpty) {
                  return const Center(child: Text("No users found"));
                }

                return ListView.builder(
                  controller: scrollController,
                  itemCount: controller.users.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {

                    if (index == controller.users.length) {
                      return const Padding(
                        padding: EdgeInsets.all(15),
                        child: Center(
                            child: CircularProgressIndicator()),
                      );
                    }

                    final UserData user = controller.users[index];

                    return UserCard(user: user);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatefulWidget {

  final UserData user;

  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {

  //bool isSelected = false;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.earnRedeem, arguments: widget.user.cardcode ?? '');

        // setState(() {
        //   isSelected = !isSelected;
        // });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),

          // border: Border.all(
          //   color: isSelected ? Colors.orange : Colors.transparent,
          //   width: 2,
          // ),

          boxShadow: const [
            BoxShadow(
              color: Color(0x20000000),
              offset: Offset(0, 2),
              blurRadius: 8,
            )
          ],
        ),

        child: Row(
          children: [

            /// USER IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                "assets/adminUser.png",
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),

            Gaps.w16,

            /// USER INFO
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(widget.user.name ?? '',
                    style: AppTextStyle.semiBold(
                        size: 16, color: AppColors.black)),

                Text(
                    "${widget.user.countryCode ?? ''} ${widget.user.mobile ?? ''}",
                    style: AppTextStyle.regular(
                        size: 14, color: AppColors.black)),

                Text(
                    "ID: ${widget.user.cardcode ?? ''}",
                    style: AppTextStyle.regular(
                        size: 12, color: AppColors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
