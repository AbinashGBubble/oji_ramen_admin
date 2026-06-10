class RewardLookupResponse {
  final bool success;

  final String message;

  final RewardLookupData? data;

  RewardLookupResponse({
    required this.success,

    required this.message,

    this.data,
  });

  factory RewardLookupResponse.fromJson(Map<String, dynamic> json) {
    return RewardLookupResponse(
      success: json["success"] ?? false,

      message: json["message"] ?? '',

      data: json["data"] != null
          ? RewardLookupData.fromJson(json["data"])
          : null,
    );
  }
}

class RewardLookupData {
  final int id;

  final int userId;

  final int rewardId;

  final String redeemCode;

  final String uid;

  final bool isClaimed;

  final DateTime? expiresAt;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  final RewardLookupReward reward;

  final RewardLookupUser user;

  RewardLookupData({
    required this.id,

    required this.userId,

    required this.rewardId,

    required this.redeemCode,

    required this.uid,

    required this.isClaimed,

    this.expiresAt,

    this.createdAt,

    this.updatedAt,

    required this.reward,

    required this.user,
  });

  factory RewardLookupData.fromJson(Map<String, dynamic> json) {
    return RewardLookupData(
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

      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,

      reward: RewardLookupReward.fromJson(json["reward"] ?? {}),

      user: RewardLookupUser.fromJson(json["user"] ?? {}),
    );
  }
}

class RewardLookupReward {
  final int id;

  final int tierId;

  final int rewardType;

  final String name;

  final String title;

  final String description;

  final DateTime? expiresAt;

  final int minVisit;

  final String? imgKey;

  final bool isActive;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  RewardLookupReward({
    required this.id,

    required this.tierId,

    required this.rewardType,

    required this.name,

    required this.title,

    required this.description,

    this.expiresAt,

    required this.minVisit,

    this.imgKey,

    required this.isActive,

    this.createdAt,

    this.updatedAt,
  });

  factory RewardLookupReward.fromJson(Map<String, dynamic> json) {
    return RewardLookupReward(
      id: json["id"] ?? 0,

      tierId: json["tierId"] ?? 0,

      rewardType: json["rewardType"] ?? 0,

      name: json["name"] ?? '',

      title: json["title"] ?? '',

      description: json["description"] ?? '',

      expiresAt: json["expiresAt"] != null
          ? DateTime.parse(json["expiresAt"])
          : null,

      minVisit: json["minVisit"] ?? 0,

      imgKey: json["imgKey"],

      isActive: json["isActive"] ?? false,

      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,

      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,
    );
  }
}

class RewardLookupUser {
  final int id;

  final String name;

  final String firstName;

  final String lastName;

  final String uid;

  final String email;

  final String mobile;

  final String? gender;

  final String countryCode;

  final int visits;

  final String? imgKey;

  final bool phoneVerified;

  final bool isActive;

  final bool isDeleted;

  final DateTime? dob;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  final List<UserTierModel> userTiers;

  RewardLookupUser({
    required this.id,

    required this.firstName,

    required this.lastName,

    required this.name,

    required this.uid,

    required this.email,

    required this.mobile,

    this.gender,

    required this.countryCode,

    required this.visits,

    this.imgKey,

    required this.phoneVerified,

    required this.isActive,

    required this.isDeleted,

    this.dob,

    this.createdAt,

    this.updatedAt,

    required this.userTiers,
  });

  factory RewardLookupUser.fromJson(Map<String, dynamic> json) {
    return RewardLookupUser(
      id: json["id"] ?? 0,

      firstName: json["firstName"] ?? '',

      lastName: json["lastName"] ?? '',

      name: json["name"] ?? '',

      uid: json["uid"] ?? '',

      email: json["email"] ?? '',

      mobile: json["mobile"] ?? '',

      gender: json["gender"],

      countryCode: json["countryCode"] ?? '',

      visits: json["visits"] ?? 0,

      imgKey: json["imgKey"],

      phoneVerified: json["phoneVerified"] ?? false,

      isActive: json["isActive"] ?? false,

      isDeleted: json["isDeleted"] ?? false,

      dob: json["dob"] != null ? DateTime.parse(json["dob"]) : null,

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

  final DateTime? createdAt;

  final DateTime? updatedAt;

  TierModel({
    required this.id,

    required this.name,

    required this.minVisit,

    required this.minSpend,

    required this.isActive,

    this.createdAt,

    this.updatedAt,
  });

  factory TierModel.fromJson(Map<String, dynamic> json) {
    return TierModel(
      id: json["id"] ?? 0,

      name: json["name"] ?? '',

      minVisit: json["minVisit"] ?? 0,

      minSpend: json["minSpend"] ?? '',

      isActive: json["isActive"] ?? false,

      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,

      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,
    );
  }
}
