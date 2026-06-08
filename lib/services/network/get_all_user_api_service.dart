// import 'package:loyalty_admin/services/base_api/base_api_service.dart';
// import 'package:loyalty_admin/services/config/api_endpoints.dart';

// class GetAllUserApiService extends BaseApiService {

//   Future<Map<String, dynamic>?> getAllUser({
//     required int offset,
//     required int limit,
//     String? search,
//   }) {

//     final queryParams = <String, String>{
//       'offset': offset.toString(),
//       'limit': limit.toString(),
//     };

//     /// add search if exists
//     if (search != null && search.isNotEmpty) {
//       queryParams['search'] = search;
//     }

//     final queryString =
//         queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');

//     return get(
//       '${ApiEndpoints.getAllUsers}?$queryString',
//       authRequired: true,
//     );
//   }
// }
