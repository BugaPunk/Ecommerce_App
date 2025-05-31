class UserProfileResponse {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final bool active;

  UserProfileResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.active,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      active: json['active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'active': active,
    };
  }
}
