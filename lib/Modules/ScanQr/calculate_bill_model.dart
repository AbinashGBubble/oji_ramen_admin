class BillResponse {
  bool? success;
  String? message;
  BillData? data;

  BillResponse({this.success, this.message, this.data});

  BillResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? BillData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class BillData {
  bool? offerApplied;
  String? source;
  String? couponCode;
  String? offerTitle;
  int? offerTypeId;
  int? originalBillAmount;
  int? discount;
  int? finalBillAmount;
  int? pointsEarned;
  int? multiplier;
  bool? hasClaimableItems;
  int? freeItemQuantity;
  String? freeItemType;
  String? freeItemId;
  String? freeItemName;
  String? freeItemEntityType;
  Status? status; // ✅ NEW (nested object)

  BillData({
    this.offerApplied,
    this.source,
    this.couponCode,
    this.offerTitle,
    this.offerTypeId,
    this.originalBillAmount,
    this.discount,
    this.finalBillAmount,
    this.pointsEarned,
    this.multiplier,
    this.hasClaimableItems,
    this.freeItemQuantity,
    this.freeItemType,
    this.freeItemId,
    this.freeItemName,
    this.freeItemEntityType,
    this.status,
  });

  BillData.fromJson(Map<String, dynamic> json) {
    offerApplied = json['offerApplied'];
    source = json['source'];
    couponCode = json['couponCode'];
    offerTitle = json['offerTitle'];
    offerTypeId = json['offerTypeId'];
    originalBillAmount = json['originalBillAmount'];
    discount = json['discount'];
    finalBillAmount = json['finalBillAmount'];
    pointsEarned = json['pointsEarned'];
    multiplier = json['multiplier'];
    hasClaimableItems = json['hasClaimableItems'];
    freeItemQuantity = json['freeItemQuantity'];
    freeItemType = json['freeItemType'];
    freeItemId = json['freeItemId'];
    freeItemName = json['freeItemName'];
    freeItemEntityType = json['freeItemEntityType'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'offerApplied': offerApplied,
      'source': source,
      'couponCode': couponCode,
      'offerTitle': offerTitle,
      'offerTypeId': offerTypeId,
      'originalBillAmount': originalBillAmount,
      'discount': discount,
      'finalBillAmount': finalBillAmount,
      'pointsEarned': pointsEarned,
      'multiplier': multiplier,
      'hasClaimableItems': hasClaimableItems,
      'freeItemQuantity': freeItemQuantity,
      'freeItemType': freeItemType,
      'freeItemId': freeItemId,
      'freeItemName': freeItemName,
      'freeItemEntityType': freeItemEntityType,
      'status': status?.toJson(),
    };
  }
}

class Status {
  bool? ok;
  String? billingReason;
  String? earningReason;

  Status({this.ok, this.billingReason, this.earningReason});

  Status.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    billingReason = json['billingReason'];
    earningReason = json['earningReason'];
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'billingReason': billingReason,
      'earningReason': earningReason,
    };
  }
}
