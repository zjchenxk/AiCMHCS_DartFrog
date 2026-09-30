/// 登录用户（对应后端 SYS_USER）。
class User {
  const User({
    required this.id,
    required this.username,
    required this.realName,
    required this.roleCode,
    required this.roleName,
    this.phone,
    this.lastLoginAt,
  });

  final int id;
  final String username;
  final String realName;
  final String roleCode;
  final String roleName;
  final String? phone;
  final String? lastLoginAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        username: json['username'] as String,
        realName: json['realName'] as String,
        roleCode: json['roleCode'] as String,
        roleName: json['roleName'] as String? ?? '',
        phone: json['phone'] as String?,
        lastLoginAt: json['lastLoginAt'] as String?,
      );
}

/// 登录成功返回的会话信息。
class LoginResult {
  const LoginResult({required this.token, required this.expiresIn, required this.user});

  final String token;
  final int expiresIn;
  final User user;

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
        token: json['token'] as String,
        expiresIn: json['expiresIn'] as int,
        user: User.fromJson(json['user'] as Map<String, dynamic>),
      );
}
