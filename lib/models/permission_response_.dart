class PermissionResponse {
  bool? success;
  String? message;

  List<PermissionData> data;

  PermissionResponse({
    this.success,
    this.message,
    this.data = const [],
  });

  factory PermissionResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return PermissionResponse(
      success: json['success'],
      message: json['message'],
      data:
          ((json['data']) as List? ?? [])
              .map(
                (e) => PermissionData.fromJson(e),
              )
              .toList(),
    );
  }
}

class PermissionData {
  final int id;

  final String name;

  PermissionData({
    required this.id,
    required this.name,
  });

  factory PermissionData.fromJson(
    Map<String, dynamic> json,
  ) {
    return PermissionData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}