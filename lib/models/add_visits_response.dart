class AddVisitResponse {
  final bool success;

  final String message;

  final AddVisitData data;

  AddVisitResponse({
    required this.success,

    required this.message,

    required this.data,
  });

  factory AddVisitResponse.fromJson(Map<String, dynamic> json) {
    return AddVisitResponse(
      success: json['success'] ?? false,

      message: json['message'] ?? '',

      data: AddVisitData.fromJson(json['data']),
    );
  }
}

class AddVisitData {
  final int id;

  final String activity;

  final int activityTypeId;

  final int userId;

  final dynamic rewardId;

  final String createdAt;

  final String updatedAt;

  final AddVisitUser user;

  AddVisitData({
    required this.id,

    required this.activity,

    required this.activityTypeId,

    required this.userId,

    required this.rewardId,

    required this.createdAt,

    required this.updatedAt,

    required this.user,
  });

  factory AddVisitData.fromJson(Map<String, dynamic> json) {
    return AddVisitData(
      id: json['id'] ?? 0,

      activity: json['activity'] ?? '',

      activityTypeId: json['activityTypeId'] ?? 0,

      userId: json['userId'] ?? 0,

      rewardId: json['rewardId'],

      createdAt: json['createdAt'] ?? '',

      updatedAt: json['updatedAt'] ?? '',

      user: AddVisitUser.fromJson(json['user']),
    );
  }
}

class AddVisitUser {
  final int visits;

  AddVisitUser({required this.visits});

  factory AddVisitUser.fromJson(Map<String, dynamic> json) {
    return AddVisitUser(visits: json['visits'] ?? 0);
  }
}
