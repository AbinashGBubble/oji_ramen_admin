class GetUserResponse {
  bool? success;
  String? message;
  UserData? data;

  GetUserResponse({this.success, this.message, this.data});

  GetUserResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? cardcode;
  String? name;
  String? mobile;
  String? email;
  String? countryCode;
  String? joinedAt;
  TierInfo? tierInfo;
  int? pointBalance;
  int? allTimeSpends;
  int? spendsOnCurrentTier;
  int? redeemedCoupons;
  NextTier? nextTier;
  int? mileStoneSpends;

  UserData({
    this.id,
    this.cardcode,
    this.name,
    this.mobile,
    this.email,
    this.countryCode,
    this.joinedAt,
    this.tierInfo,
    this.pointBalance,
    this.allTimeSpends,
    this.spendsOnCurrentTier,
    this.redeemedCoupons,
    this.nextTier,
    this.mileStoneSpends,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardcode = json['cardcode'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    countryCode = json['country_code'];
    joinedAt = json['joined_at'];
    tierInfo =
        json['tier_info'] != null ? TierInfo.fromJson(json['tier_info']) : null;
    pointBalance = json['point_balance'];
    allTimeSpends = json['allTimeSpends'];
    spendsOnCurrentTier = json['spendsOnCurrentTier'];
    redeemedCoupons = json['redeemedCoupons'];
    nextTier =
        json['next_tier'] != null ? NextTier.fromJson(json['next_tier']) : null;
    mileStoneSpends = json['mileStoneSpends'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['cardcode'] = cardcode;
    data['name'] = name;
    data['mobile'] = mobile;
    data['email'] = email;
    data['country_code'] = countryCode;
    data['joined_at'] = joinedAt;
    data['point_balance'] = pointBalance;
    data['allTimeSpends'] = allTimeSpends;
    data['spendsOnCurrentTier'] = spendsOnCurrentTier;
    data['redeemedCoupons'] = redeemedCoupons;
    data['mileStoneSpends'] = mileStoneSpends;

    if (tierInfo != null) {
      data['tier_info'] = tierInfo!.toJson();
    }

    if (nextTier != null) {
      data['next_tier'] = nextTier!.toJson();
    }

    return data;
  }
}

class TierInfo {
  int? tierId;
  String? startAt;
  String? expireAt;
  String? tier;
  String? tierSpends;

  TierInfo({
    this.tierId,
    this.startAt,
    this.expireAt,
    this.tier,
    this.tierSpends,
  });

  TierInfo.fromJson(Map<String, dynamic> json) {
    tierId = json['tier_id'];
    startAt = json['start_at'];
    expireAt = json['expire_at'];
    tier = json['tier'];
    tierSpends = json['tier_spends'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['tier_id'] = tierId;
    data['start_at'] = startAt;
    data['expire_at'] = expireAt;
    data['tier'] = tier;
    data['tier_spends'] = tierSpends;
    return data;
  }
}

class NextTier {
  int? id;
  String? name;
  String? spends;

  NextTier({this.id, this.name, this.spends});

  NextTier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    spends = json['spends'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['spends'] = spends;
    return data;
  }
}
