class CreateVendorRequest {
  final String username;
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;

  CreateVendorRequest({
    required this.username,
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'username': username,
      'email': email,
      'password': password,
    };
    
    if (firstName != null && firstName!.isNotEmpty) {
      data['firstName'] = firstName;
    }
    if (lastName != null && lastName!.isNotEmpty) {
      data['lastName'] = lastName;
    }
    
    return data;
  }
}