class RegisterRequestModel {
  final String role;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? password;
  final String? phone;
  final String? address;
  final List<String>? specialization;
  final String? description;
  final String? orgName;
  final String? bin;
  final String? city;

  RegisterRequestModel({
    required this.role,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.phone,
    this.address,
    this.specialization,
    this.description,
    this.orgName,
    this.bin,
    this.city,
  });
  Map<String, dynamic> toFormData() {
    final data = <String, dynamic>{
      'role': role,
    };

    if (email != null) data['email'] = email;
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (password != null) data['password'] = password;
    if (phone != null) data['phone'] = phone;
    if (address != null) data['address'] = address;
    if (specialization != null) {
      data['specialization'] = specialization!.isEmpty
          ? '[]'
          : specialization.toString();
    }
    if (description != null) data['description'] = description;
    if (orgName != null) data['org_name'] = orgName;
    if (bin != null) data['bin'] = bin;
    if (city != null) data['city'] = city;

    return data;
  }
}
