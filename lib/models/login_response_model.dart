class LoginResponse {
  final bool success;
  final String message;
  final LoginData? data;

  LoginResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class LoginData {
  final String accessToken;
  final String refreshToken;
  final Admin admin;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
    required this.admin,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['accessToken'] ?? "",
      refreshToken: json['refreshToken'] ?? "",
      admin: Admin.fromJson(json['admin']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'admin': admin.toJson(),
    };
  }
}

class Admin {
  final int id;
  final String name;
  final String email;
  final String role;
  final int restaurantId;
  final int? roleId;

  Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.restaurantId,
    this.roleId,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      role: json['role'] ?? "",
      restaurantId: json['restaurant_id'] ?? 0,
      roleId: json['roleId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'restaurant_id': restaurantId,
      if (roleId != null) 'roleId': roleId,
    };
  }
}
