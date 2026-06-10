class ProfileLookupResponse {
  final bool success;

  final String message;

  final ProfileLookupData? data;

  ProfileLookupResponse({
    required this.success,

    required this.message,

    this.data,
  });

  factory ProfileLookupResponse.fromJson(Map<String, dynamic> json) {
    return ProfileLookupResponse(
      success: json["success"] ?? false,

      message: json["message"] ?? '',

      data: json["data"] != null
          ? ProfileLookupData.fromJson(json["data"])
          : null,
    );
  }
}

class ProfileLookupData {
  final int id;

  final String? name;

  final String firstName;

  final String lastName;

  final String uid;

  final String email;

  final String mobile;

  final DateTime? dob;

  final String? gender;

  final String countryCode;

  final int visits;

  final String? imgKey;

  final bool phoneVerified;

  final bool isActive;

  final bool isDeleted;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  final List<UserTierModel> userTiers;

  final List<LoginSessionModel> loginSessions;

  final List<ActivityModel> activities;

  final List<UserRewardModel> rewards;

  ProfileLookupData({
    required this.id,

    this.name,

    required this.firstName,

    required this.lastName,

    required this.uid,

    required this.email,

    required this.mobile,

    this.dob,

    this.gender,

    required this.countryCode,

    required this.visits,

    this.imgKey,

    required this.phoneVerified,

    required this.isActive,

    required this.isDeleted,

    this.createdAt,

    this.updatedAt,

    required this.userTiers,

    required this.loginSessions,

    required this.activities,

    required this.rewards,
  });

  factory ProfileLookupData.fromJson(Map<String, dynamic> json) {
    return ProfileLookupData(
      id: json["id"] ?? 0,

      name: json["name"] ?? '',

      firstName: json["firstName"] ?? '',

      lastName: json["lastName"] ?? '',

      uid: json["uid"] ?? '',

      email: json["email"] ?? '',

      mobile: json["mobile"] ?? '',

      dob: json["dob"] != null ? DateTime.parse(json["dob"]) : null,

      gender: json["gender"],

      countryCode: json["countryCode"] ?? '',

      visits: json["visits"] ?? 0,

      imgKey: json["imgKey"],

      phoneVerified: json["phoneVerified"] ?? false,

      isActive: json["isActive"] ?? false,

      isDeleted: json["isDeleted"] ?? false,

      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,

      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,

      userTiers:
          (json["userTiers"] as List?)
              ?.map((e) => UserTierModel.fromJson(e))
              .toList() ??
          [],

      loginSessions:
          (json["loginSessions"] as List?)
              ?.map((e) => LoginSessionModel.fromJson(e))
              .toList() ??
          [],

      activities:
          (json["activities"] as List?)
              ?.map((e) => ActivityModel.fromJson(e))
              .toList() ??
          [],

      rewards:
          (json["rewards"] as List?)
              ?.map((e) => UserRewardModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  ProfileLookupData copyWith({int? visits}) {
    return ProfileLookupData(
      id: id,
      name: name,
      firstName: firstName,
      lastName: lastName,
      uid: uid,
      email: email,
      mobile: mobile,
      dob: dob,
      gender: gender,
      countryCode: countryCode,
      visits: visits ?? this.visits,
      imgKey: imgKey,
      phoneVerified: phoneVerified,
      isActive: isActive,
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userTiers: userTiers,
      loginSessions: loginSessions,
      activities: activities,
      rewards: rewards,
    );
  }
}

class UserTierModel {
  final int id;

  final int userId;

  final int tierId;

  final bool isActive;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  final TierModel tier;

  UserTierModel({
    required this.id,

    required this.userId,

    required this.tierId,

    required this.isActive,

    this.createdAt,

    this.updatedAt,

    required this.tier,
  });

  factory UserTierModel.fromJson(Map<String, dynamic> json) {
    return UserTierModel(
      id: json["id"] ?? 0,

      userId: json["userId"] ?? 0,

      tierId: json["tierId"] ?? 0,

      isActive: json["isActive"] ?? false,

      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,

      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,

      tier: TierModel.fromJson(json["tier"] ?? {}),
    );
  }
}

class TierModel {
  final int id;

  final String name;

  final int minVisit;

  final String minSpend;

  final bool isActive;

  TierModel({
    required this.id,

    required this.name,

    required this.minVisit,

    required this.minSpend,

    required this.isActive,
  });

  factory TierModel.fromJson(Map<String, dynamic> json) {
    return TierModel(
      id: json["id"] ?? 0,

      name: json["name"] ?? '',

      minVisit: json["minVisit"] ?? 0,

      minSpend: json["minSpend"] ?? '',

      isActive: json["isActive"] ?? false,
    );
  }
}

class LoginSessionModel {
  final int id;

  final String deviceType;

  final String appVersion;

  final String buildNumber;

  final String? fcmToken;

  final bool isActive;

  final DateTime? loginAt;

  final DateTime? logoutAt;

  LoginSessionModel({
    required this.id,

    required this.deviceType,

    required this.appVersion,

    required this.buildNumber,

    this.fcmToken,

    required this.isActive,

    this.loginAt,

    this.logoutAt,
  });

  factory LoginSessionModel.fromJson(Map<String, dynamic> json) {
    return LoginSessionModel(
      id: json["id"] ?? 0,

      deviceType: json["deviceType"] ?? '',

      appVersion: json["appVersion"] ?? '',

      buildNumber: json["buildNumber"] ?? '',

      fcmToken: json["fcmToken"],

      isActive: json["isActive"] ?? false,

      loginAt: json["loginAt"] != null ? DateTime.parse(json["loginAt"]) : null,

      logoutAt: json["logoutAt"] != null
          ? DateTime.parse(json["logoutAt"])
          : null,
    );
  }
}

class ActivityModel {
  final int id;

  final String activity;

  final int activityTypeId;

  final int userId;

  final int? rewardId;

  final DateTime? createdAt;

  ActivityModel({
    required this.id,

    required this.activity,

    required this.activityTypeId,

    required this.userId,

    this.rewardId,

    this.createdAt,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json["id"] ?? 0,

      activity: json["activity"] ?? '',

      activityTypeId: json["activityTypeId"] ?? 0,

      userId: json["userId"] ?? 0,

      rewardId: json["rewardId"],

      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,
    );
  }
}

class UserRewardModel {
  final int id;

  final int userId;

  final int rewardId;

  final String redeemCode;

  final String uid;

  final bool isClaimed;

  final DateTime? expiresAt;

  final DateTime? createdAt;

  UserRewardModel({
    required this.id,

    required this.userId,

    required this.rewardId,

    required this.redeemCode,

    required this.uid,

    required this.isClaimed,

    this.expiresAt,

    this.createdAt,
  });

  factory UserRewardModel.fromJson(Map<String, dynamic> json) {
    return UserRewardModel(
      id: json["id"] ?? 0,

      userId: json["userId"] ?? 0,

      rewardId: json["rewardId"] ?? 0,

      redeemCode: json["redeemCode"] ?? '',

      uid: json["uid"] ?? '',

      isClaimed: json["isClaimed"] ?? false,

      expiresAt: json["expiresAt"] != null
          ? DateTime.parse(json["expiresAt"])
          : null,

      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,
    );
  }
}