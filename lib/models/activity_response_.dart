class ActivityTypeResponse {
  bool? success;
  String? message;

  List<ActivityData> data;

  ActivityTypeResponse({
    this.success,
    this.message,
    this.data = const [],
  });

  factory ActivityTypeResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return ActivityTypeResponse(
      success: json['success'],
      message: json['message'],
      data:
          ((json['data']) as List? ?? [])
              .map(
                (e) => ActivityData.fromJson(e),
              )
              .toList(),
    );
  }
}

class ActivityData {
  final int id;
  final String name;

  ActivityData({
    required this.id,
    required this.name,
  });

  factory ActivityData.fromJson(
    Map<String, dynamic> json,
  ) {
    return ActivityData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}