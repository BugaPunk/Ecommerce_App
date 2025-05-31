class UpdateProfileRequest {
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;

  UpdateProfileRequest({
    this.username,
    this.email,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (username != null && username!.isNotEmpty) {
      data['username'] = username;
    }
    if (email != null && email!.isNotEmpty) {
      data['email'] = email;
    }
    if (firstName != null && firstName!.isNotEmpty) {
      data['firstName'] = firstName;
    }
    if (lastName != null && lastName!.isNotEmpty) {
      data['lastName'] = lastName;
    }
    
    return data;
  }

  bool get isEmpty => 
    (username == null || username!.isEmpty) &&
    (email == null || email!.isEmpty) &&
    (firstName == null || firstName!.isEmpty) &&
    (lastName == null || lastName!.isEmpty);
}
