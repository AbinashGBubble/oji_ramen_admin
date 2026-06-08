import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:loyalty_admin/models/add_visits_response.dart';
import 'package:loyalty_admin/models/profile_scan_qr_model.dart';
import 'package:loyalty_admin/models/rewards_scan_qr_response.dart';

import 'package:loyalty_admin/services/network/add_visits_api_service.dart';
import 'package:loyalty_admin/services/network/scan_reward_qr_api_service.dart';
import 'package:loyalty_admin/services/network/scan_user_qr_api_service.dart';

class ScanQrController extends GetxController {
  //----------------------------------
  // SERVICES
  //----------------------------------

  final ScanUserQrApiService _userApi = ScanUserQrApiService();

  final ScanRewardQrApiService _rewardApi = ScanRewardQrApiService();

  final AddvisistsApiService _addVisitsApi = AddvisistsApiService();

  //----------------------------------
  // STATES
  //----------------------------------

  final RxBool isLoading = false.obs;

  final RxBool isRedeem = false.obs;

  /// FIX #1 — separate show flags so switching tabs never hides existing data
  final RxBool showProfileData = false.obs;

  final RxBool showRewardData = false.obs;

  final RxBool isAddingVisit = false.obs;

  final RxBool isRedeeming = false.obs;

  /// FIX #2 — tracks whether a visit was already added for the current profile
  /// Reset to false every time a new profile is loaded
  final RxBool visitAdded = false.obs;

  //----------------------------------
  // PROFILE RESPONSE
  //----------------------------------

  final Rxn<ProfileLookupResponse> profileResponse =
      Rxn<ProfileLookupResponse>();

  //----------------------------------
  // REWARD RESPONSE
  //----------------------------------

  final Rxn<RewardLookupResponse> rewardResponse = Rxn<RewardLookupResponse>();

  //----------------------------------
  // HANDLE QR
  //----------------------------------

  Future<bool> handleQrCode(String rawQr) async {
    try {
      if (isLoading.value) return false;

      isLoading.value = true;

      final decoded = jsonDecode(rawQr);

      final String uid = decoded["uid"] ?? '';

      final String type = decoded["type"] ?? '';

      if (uid.isEmpty || type.isEmpty) {
        Get.snackbar("Error", "Invalid QR");
        return false;
      }

      debugPrint("QR UID => $uid");
      debugPrint("QR TYPE => $type");

      //----------------------------------
      // PROFILE QR
      //----------------------------------

      if (type == "profile") {
        isRedeem.value = false;

        final response = await _userApi.userLookUp(identifier: uid);

        debugPrint("PROFILE RESPONSE => $response");

        if (response == null) {
          Get.snackbar("Error", "User not found");
          return false;
        }

        if (response['success'] == true) {
          profileResponse.value = ProfileLookupResponse.fromJson(response);

          // Reset visit button for new profile
          visitAdded.value = false;

          showProfileData.value = true;

          return true;
        }

        Get.snackbar("Error", response['message'] ?? "User not found");
        return false;
      }

      //----------------------------------
      // REWARD QR
      //----------------------------------

      else if (type == "rewards") {
        isRedeem.value = true;

        final response = await _rewardApi.rewardLookUp(identifier: uid);

        debugPrint("REWARD RESPONSE => $response");

        if (response == null) {
          Get.snackbar("Error", "Reward not found");
          return false;
        }

        if (response['success'] == true) {
          rewardResponse.value = RewardLookupResponse.fromJson(response);

          showRewardData.value = true;

          return true;
        }

        Get.snackbar("Error", response['message'] ?? "Reward not found");
        return false;
      }

      //----------------------------------
      // INVALID TYPE
      //----------------------------------

      else {
        Get.snackbar("Error", "Invalid QR type");
        return false;
      }
    } catch (e) {
      debugPrint("QR ERROR => $e");
      Get.snackbar("Error", "Invalid QR format");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  //----------------------------------
  // PROFILE GETTERS
  //----------------------------------

  ProfileLookupData? get profileData => profileResponse.value?.data;

  String get profileName =>
      "${profileData?.firstName ?? ''} "
      "${profileData?.lastName ?? ''}";

  String get profileUid => profileData?.uid ?? '';

  String get profileMobile => profileData?.mobile ?? '';

  String get profileTier =>
      profileData?.userTiers.firstOrNull?.tier.name ?? '-';

  String get profileVisits => profileData?.visits.toString() ?? '0';

  String get profileRewards => profileData?.rewards.length.toString() ?? '0';

  //----------------------------------
  // REWARD GETTERS
  //----------------------------------

  RewardLookupData? get rewardData => rewardResponse.value?.data;

  String get rewardCode => rewardData?.redeemCode ?? '';

  String get rewardName => rewardData?.reward.name ?? '';

  String get rewardUser =>
      "${rewardData?.user.firstName ?? ''} "
      "${rewardData?.user.lastName ?? ''}";

  String get rewardTier =>
      rewardData?.user.userTiers.firstOrNull?.tier.name ?? '-';

  //----------------------------------
  // ADD VISIT
  //----------------------------------

  Future<void> addVisit() async {
    try {
      if (profileData == null) {
        Get.snackbar("Error", "Profile not found");
        return;
      }

      isAddingVisit.value = true;

      final response = await _addVisitsApi.addvisits(id: profileData!.id);

      debugPrint("ADD VISIT RESPONSE => $response");

      if (response?['success'] == true) {
        final parsed = AddVisitResponse.fromJson(response!);

        final updatedVisits = parsed.data.user.visits;

        // FIX: use copyWith instead of assigning to final field
        if (profileResponse.value != null &&
            profileResponse.value!.data != null) {
          profileResponse.value = ProfileLookupResponse(
            success: profileResponse.value!.success,
            message: profileResponse.value!.message,
            data: profileResponse.value!.data!.copyWith(
              visits: updatedVisits,
            ),
          );
        }

        // FIX: mark visit as done — disables the button
        visitAdded.value = true;

        Get.snackbar(
          "Success",
          parsed.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          response?['message'] ?? "Failed to add visit",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint("ADD VISIT ERROR => $e");
      Get.snackbar(
        "Error",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isAddingVisit.value = false;
    }
  }

  //----------------------------------
  // CONFIRM REWARD REDEEM
  //----------------------------------

  Future<void> confirmReward() async {
    try {
      if (rewardData == null) {
        Get.snackbar("Error", "Reward not found");
        return;
      }

      isRedeeming.value = true;

      final response =
          await _rewardApi.rewardLookUp(identifier: rewardData!.redeemCode);

      if (response?['success'] == true) {
        showRewardData.value = false;
        rewardResponse.value = null;
        Get.snackbar(
          "Success",
          "Reward redeemed successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          response?['message'] ?? "Failed to redeem reward",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint("CONFIRM REWARD ERROR => $e");
      Get.snackbar(
        "Error",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isRedeeming.value = false;
    }
  }

  //----------------------------------
  // RESET (called on logout / re-scan)
  //----------------------------------

  void reset() {
    profileResponse.value = null;
    rewardResponse.value = null;
    showProfileData.value = false;
    showRewardData.value = false;
    visitAdded.value = false;
    isRedeem.value = false;
  }

  @override
  void onClose() {
    reset();
    super.onClose();
  }
}