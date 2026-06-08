// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:loyalty_admin/Modules/redeem/get_all_user_model.dart';
// import 'package:loyalty_admin/services/network/get_all_user_api_service.dart';

// class GetAllUserController extends GetxController {

//   final _api = GetAllUserApiService();

//   final isLoading = false.obs;
//   final isLoadingMore = false.obs;
//   final errorMessage = ''.obs;

//   final users = <UserData>[].obs;

//   final searchController = TextEditingController();

//   int limit = 10;
//   int offset = 0;
//   bool hasMore = true;

//   /// search query
//   final searchQuery = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();

//     /// debounce search
//     debounce(searchQuery, (_) {
//       resetPagination();
//       fetchUsers();
//     }, time: const Duration(milliseconds: 500));

//     fetchUsers();
//   }

//   void onSearchChanged(String value) {
//     searchQuery.value = value;
//   }

//   /// reset pagination when searching
//   void resetPagination() {
//     offset = 0;
//     hasMore = true;
//     users.clear();
//   }

//   /// fetch users
//   Future<void> fetchUsers() async {

//     if (!hasMore) return;

//     try {

//       if (offset == 0) {
//         isLoading.value = true;
//       } else {
//         isLoadingMore.value = true;
//       }

//       final response = await _api.getAllUser(
//         search: searchQuery.value,
//         limit: limit,
//         offset: offset,
//       );

//       if (response == null) {
//         errorMessage.value = "Unable to load users";
//         return;
//       }

//       final result = GetAllUsersResponse.fromJson(response);

//       if (result.success == true) {

//         users.addAll(result.data ?? []);

//         hasMore = result.pagination?.hasMore ?? false;

//         offset += limit;

//       } else {
//         errorMessage.value = result.message ?? "Something went wrong";
//       }

//     } catch (e) {
//       errorMessage.value = "Something went wrong";
//     } finally {
//       isLoading.value = false;
//       isLoadingMore.value = false;
//     }
//   }

//   /// load more when scrolling
//   void loadMore() {
//     if (!isLoadingMore.value && hasMore) {
//       fetchUsers();
//     }
//   }
// }
