// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:loyalty_admin/Modules/ScanQr/earn_redeem_controller.dart';
// import 'package:loyalty_admin/Modules/ScanQr/upload_bill.dart';
// import 'package:loyalty_admin/common/app_spacing.dart';
// import 'package:loyalty_admin/common/app_text_styles.dart';
// import 'package:loyalty_admin/common/common_button.dart';
// import 'package:loyalty_admin/constant/app_colors.dart';

// class EarnRedeemScreen extends StatefulWidget {
//   const EarnRedeemScreen({super.key});

//   @override
//   State<EarnRedeemScreen> createState() => _EarnRedeemScreenState();
// }

// class _EarnRedeemScreenState extends State<EarnRedeemScreen> {
//   bool isEarn = false;

//   final EarnRedeemController controller = Get.find<EarnRedeemController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(
//           MediaQuery.of(context).size.height * 0.1,
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0x1C000000),
//                 offset: const Offset(0, 4),
//                 blurRadius: 9.9,
//                 spreadRadius: 0,
//               ),
//             ],
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Top Logo + Text Row (replaced AppBar)
//                   Row(
//                     children: [
//                       Container(
//                         height: 50,
//                         width: 50,
//                         decoration: BoxDecoration(
//                           color: AppColors.secondary,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "LA",
//                             style: AppTextStyle.semiBold(
//                               size: 20,
//                               color: AppColors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Gaps.w12,
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Loyalty Admin",
//                             style: AppTextStyle.semiBold(
//                               size: 20,
//                               color: AppColors.black,
//                             ),
//                           ),
//                           Text(
//                             "Restaurant Management",
//                             style: AppTextStyle.regular(
//                               size: 14,
//                               color: AppColors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: ListView(
//           children: [
//             Obx(() {
//               /// LOADING STATE
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               /// NULL DATA
//               if (controller.userData.value == null) {
//                 return const Center(child: Text("User data not available"));
//               }

//               /// SAFE DATA
//               final user = controller.userData.value!;

//               return Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: const Color(0xffFF7C0A)),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           /// USER IMAGE
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(30),
//                             child: Image.asset(
//                               "assets/adminUser.png",
//                               height: 60,
//                               width: 60,
//                               fit: BoxFit.cover,
//                             ),
//                           ),

//                           Gaps.w16,

//                           /// USER INFO
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 user.name ?? '',
//                                 style: AppTextStyle.semiBold(
//                                   size: 16,
//                                   color: AppColors.black,
//                                 ),
//                               ),

//                               Text(
//                                 "${user.countryCode ?? ''} ${user.mobile ?? ''}",
//                                 style: AppTextStyle.regular(
//                                   size: 14,
//                                   color: AppColors.black,
//                                 ),
//                               ),

//                               Text(
//                                 "ID: ${user.cardcode ?? ''}",
//                                 style: AppTextStyle.regular(
//                                   size: 12,
//                                   color: AppColors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Gaps.h12,
//                       Container(
//                         height: 25,
//                         width: 90,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [Color(0xFFFF7C0A), Color(0xFFFE9A36)],
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             user.nextTier?.name ?? '',
//                             style: AppTextStyle.bold(
//                               size: 12,
//                               color: AppColors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Gaps.h12,
//                     ],
//                   ),
//                 ),
//               );
//             }),

//             Gaps.h20,
//             Container(
//               height: 55,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(5),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0x1A000000),
//                     offset: const Offset(0, 0),
//                     blurRadius: 15,
//                     spreadRadius: 0,
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isEarn = true;
//                         });
//                       },
//                       child: Container(
//                         height: 45,
//                         decoration: BoxDecoration(
//                           color: isEarn ? AppColors.secondary : AppColors.white,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Earn",
//                             style: AppTextStyle.semiBold(
//                               color: isEarn ? AppColors.white : AppColors.black,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isEarn = false;
//                         });
//                       },
//                       child: Container(
//                         height: 45,
//                         decoration: BoxDecoration(
//                           color: !isEarn
//                               ? AppColors.secondary
//                               : AppColors.white,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Redeem",
//                             style: AppTextStyle.semiBold(
//                               color: !isEarn
//                                   ? AppColors.white
//                                   : AppColors.black,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Gaps.h24,

//             // earn
//             Text(
//               "Bill Amount (₹)",
//               style: AppTextStyle.semiBold(size: 16, color: AppColors.black),
//             ),
//             Gaps.h12,
//             Container(
//               height: 50,
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(6.r),
//               ),
//               child: TextField(
//                 controller: controller.billAmountController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   hintText: "Enter your bill amount",
//                   hintStyle: AppTextStyle.regular(size: 11, color: Colors.grey),
//                 ),
//               ),
//             ),
//             // redeem
//             if (isEarn == false) ...[
//               Gaps.h20,
//               Text(
//                 "Coupon code",
//                 style: AppTextStyle.semiBold(size: 16, color: AppColors.black),
//               ),
//               Gaps.h12,
//               Container(
//                 height: 50,
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade200,
//                   borderRadius: BorderRadius.circular(6.r),
//                 ),
//                 child: TextField(
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     hintText: "Enter your coupon code here",
//                     hintStyle: AppTextStyle.regular(
//                       size: 11,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//             Gaps.h20,
//             Text(
//               "Upload Bill Here",
//               style: AppTextStyle.semiBold(size: 16, color: AppColors.black),
//             ),
//             Gaps.h20,
//             UploadBox(),
//             Gaps.h20,
//             //in this data show after calculate bill succes show the calculate bill api response data
//             // Container(
//             //   width: double.infinity,
//             //   decoration: BoxDecoration(
//             //     color: const Color(0xffFFF1E7),
//             //     borderRadius: BorderRadius.circular(12),
//             //     border: const Border(
//             //       top: BorderSide(color: Color(0xffF9D8C1), width: 6),
//             //     ),
//             //   ),
//             //   child: Padding(
//             //     padding: const EdgeInsets.all(20),
//             //     child: Column(
//             //       crossAxisAlignment: CrossAxisAlignment.start,
//             //       children: [
//             //         Row(
//             //           crossAxisAlignment: CrossAxisAlignment.start,
//             //           children: [
//             //             const Image(
//             //               image: AssetImage('assets/reward.png'),
//             //               height: 20,
//             //             ),
//             //             Gaps.w8,
//             //             Text(
//             //               isEarn ? 'Points to be earned' : "Potential Rewards",
//             //               style: AppTextStyle.bold(
//             //                 size: 16,
//             //                 color: AppColors.black,
//             //               ),
//             //             ),
//             //           ],
//             //         ),
//             //         Gaps.h12,
//             //         if (!isEarn) ...[
//             //           _rewardRow("Coupon Code", "NEW1BUY"),
//             //           Gaps.h4,
//             //         ],
//             //         _rewardRow("Bill Amount", "₹570.00"),
//             //         Gaps.h4,
//             //         _rewardRow("Discount Amount", "₹75.00"),
//             //         Gaps.h4,
//             //         _rewardRow("Redeem Rewards", "Qty : 1"),
//             //         Gaps.h4,
//             //         _rewardRow("Points", "120 pts"),
//             //         Gaps.h16,
//             //         Row(
//             //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //           children: [
//             //             Text(
//             //               "Total Credited",
//             //               style: AppTextStyle.bold(
//             //                 size: 14,
//             //                 color: AppColors.black,
//             //               ),
//             //             ),
//             //             Text(
//             //               "120 Points",
//             //               style: AppTextStyle.bold(
//             //                 size: 14,
//             //                 color: const Color(0xffFF9900),
//             //               ),
//             //             ),
//             //           ],
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             Obx(() {
//               /// 🔄 LOADING
//               if (controller.isCalculating.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               /// ❌ ERROR
//               if (controller.isError.value) {
//                 return Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.red.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     controller.errorText.value,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 );
//               }

//               /// 🚫 BEFORE API CALL → HIDE CARD
//               final bill = controller.billData.value;
//               if (bill == null) {
//                 return const SizedBox(); // 👈 IMPORTANT
//               }

//               /// ✅ SUCCESS → SHOW CARD
//               return Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: const Color(0xffFFF1E7),
//                   borderRadius: BorderRadius.circular(12),
//                   border: const Border(
//                     top: BorderSide(color: Color(0xffF9D8C1), width: 6),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           const Image(
//                             image: AssetImage('assets/reward.png'),
//                             height: 20,
//                           ),
//                           Gaps.w8,
//                           Text(
//                             isEarn
//                                 ? 'Points to be earned'
//                                 : "Potential Rewards",
//                             style: AppTextStyle.bold(size: 16,color: AppColors.black),
//                           ),
//                         ],
//                       ),

//                       Gaps.h12,

//                       /// Coupon
//                       if (!isEarn && bill.couponCode != null)
//                         _rewardRow("Coupon Code", bill.couponCode!),

//                       Gaps.h4,

//                       /// Bill Amount
//                       _rewardRow(
//                         "Bill Amount",
//                         "₹${bill.originalBillAmount ?? 0}",
//                       ),

//                       Gaps.h4,

//                       /// Discount
//                       _rewardRow("Discount Amount", "₹${bill.discount ?? 0}"),

//                       Gaps.h4,

//                       /// Final Amount
//                       _rewardRow(
//                         "Final Amount",
//                         "₹${bill.finalBillAmount ?? 0}",
//                       ),

//                       Gaps.h4,

//                       /// Free Item
//                       if (bill.hasClaimableItems == true)
//                         _rewardRow(
//                           "Free Item",
//                           "${bill.freeItemName ?? ''} (Qty: ${bill.freeItemQuantity ?? 0})",
//                         ),

//                       Gaps.h4,

//                       /// Points
//                       _rewardRow("Points", "${bill.pointsEarned ?? 0} pts"),

//                       Gaps.h16,

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text("Total Credited"),
//                           Text(
//                             "${bill.pointsEarned ?? 0} Points",
//                             style: const TextStyle(color: Colors.orange),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//             Gaps.h32,
//             // CommonButton(
//             //   text: isEarn ? 'Credit Points' : 'Calculate Rewards',
//             //   onPressed: () {
//             //     controller.calculateBill(couponCode: controller.couponCodeController.text, billAmount: controller.billAmountController.text);
//             //   },
//             // ),
//             Obx(
//               () => CommonButton(
//                 text: isEarn ? 'Credit Points' : 'Calculate Rewards',

//                 isLoading: controller.isCalculating.value,

//                 onPressed: () {
//                   // prevent multiple clicks
//                   if (controller.isCalculating.value) return;

//                   controller.calculateBill(
//                     couponCode: controller.couponCodeController.text,
//                     billAmount: controller.billAmountController.text,
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _rewardRow(String title, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: AppTextStyle.regular(size: 14, color: const Color(0xff64748B)),
//         ),
//         Text(
//           value,
//           style: AppTextStyle.semiBold(size: 14, color: AppColors.black),
//         ),
//       ],
//     );
//   }
// }
