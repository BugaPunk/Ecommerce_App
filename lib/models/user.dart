import 'user_profile_response.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final List<String> roles;
  final bool active;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.roles,
    required this.active,
  });

  String get nombre => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      roles: List<String>.from(json['roles']),
      active: json['active'],
    );
  }

  factory User.fromProfileResponse(UserProfileResponse profile, List<String> roles) {
    return User(
      id: profile.id,
      username: profile.username,
      email: profile.email,
      firstName: profile.firstName,
      lastName: profile.lastName,
      roles: roles,
      active: profile.active,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'roles': roles,
      'active': active,
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    List<String>? roles,
    bool? active,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      roles: roles ?? this.roles,
      active: active ?? this.active,
    );
  }
}