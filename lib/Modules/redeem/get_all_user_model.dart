class GetAllUsersResponse {
  bool? success;
  String? message;
  List<UserData>? data;
  Pagination? pagination;

  GetAllUsersResponse({
    this.success,
    this.message,
    this.data,
    this.pagination,
  });

  GetAllUsersResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
      });
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['success'] = success;
    data['message'] = message;

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }

    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }

    return data;
  }
}

class UserData {
  int? id;
  String? cardcode;
  String? name;
  String? mobile;
  String? countryCode;
  bool? isActive;
  String? tier;
  int? tierId;

  UserData({
    this.id,
    this.cardcode,
    this.name,
    this.mobile,
    this.countryCode,
    this.isActive,
    this.tier,
    this.tierId,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardcode = json['cardcode'];
    name = json['name'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    isActive = json['is_active'];
    tier = json['tier'];
    tierId = json['tier_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['cardcode'] = cardcode;
    data['name'] = name;
    data['mobile'] = mobile;
    data['country_code'] = countryCode;
    data['is_active'] = isActive;
    data['tier'] = tier;
    data['tier_id'] = tierId;

    return data;
  }
}

class Pagination {
  int? total;
  int? limit;
  int? offset;
  bool? hasMore;

  Pagination({
    this.total,
    this.limit,
    this.offset,
    this.hasMore,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    limit = json['limit'];
    offset = json['offset'];
    hasMore = json['hasMore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['total'] = total;
    data['limit'] = limit;
    data['offset'] = offset;
    data['hasMore'] = hasMore;

    return data;
  }
}
