import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_admin/models/permission_response_.dart';
import 'package:loyalty_admin/services/network/get_permission_api_service.dart';


class PermissionController
    extends GetxController {
  final api =
      GetAppPermissionApiService();

  final permissions =
      <PermissionData>[].obs;

  final isLoading =
      false.obs;

  Future<void> loadPermissions() async {
    try {
      isLoading.value = true;

      final response =
          await api.getAppManagement();

      if (response == null) {
        return;
      }

      final parsed =
          PermissionResponse.fromJson(
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