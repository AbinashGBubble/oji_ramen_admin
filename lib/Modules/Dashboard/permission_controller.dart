import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_admin/models/activity_response_.dart';
import 'package:loyalty_admin/services/network/get_activityType_api_service.dart';


class ActivityTypeController
    extends GetxController {
  final api =
      GetActivityTypeApiService();

  final permissions =
      <ActivityData>[].obs;

  final isLoading =
      false.obs;

  Future<void> loadPermissions() async {
    try {
      isLoading.value = true;

      final response =
          await api.getActivityType();

      if (response == null) {
        return;
      }

      final parsed =
          ActivityTypeResponse.fromJson(
        response,
      );

      permissions.assignAll(
        parsed.data,
      );

      debugPrint(
        'Permissions loaded '
        '${permissions.length}',
      );
    } catch (e) {
      debugPrint(
        'Permission error $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool hasPermission(
    String name,
  ) {
    return permissions.any(
      (e) =>
          e.name
              .toLowerCase() ==
          name.toLowerCase(),
    );
  }
}