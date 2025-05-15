class AuthResponse {
  final String token;
  final String type;
  final int id;
  final String username;
  final String email;
  final List<String> roles;

  AuthResponse({
    required this.token,
    required this.type,
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      type: json['type'],
      id: json['id'],
      username: json['username'],
      email: json['email'],
      roles: List<String>.from(json['roles']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'type': type,
      'id': id,
      'username': username,
      'email': email,
      'roles': roles,
    };
  }
}