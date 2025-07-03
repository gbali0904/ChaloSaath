class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String? carNumber;
  final String? password;
  final String? homeAddress;
  final String? officeAddress;
  final bool? isRegister;
  final bool? isAddress;
  final bool? isCarVerified;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.carNumber,
    this.homeAddress,
    this.officeAddress,
    this.password,
    this.isRegister,
    this.isAddress,
    this.isCarVerified,
  });
  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    String? homeAddress,
    String? officeAddress,
    String? carNumber,
    bool? isRegister,
    bool? isAddress,
    bool? isCarVerified,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      carNumber: carNumber ?? this.carNumber,
      homeAddress: homeAddress ?? this.homeAddress,
      officeAddress: officeAddress ?? this.officeAddress,
      isRegister: isRegister ?? this.isRegister,
      isAddress: isAddress ?? this.isAddress,
      isCarVerified: isCarVerified ?? this.isCarVerified,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "fullName": fullName,
      "email": email,
      "phone": phone,
      "role": role,
      "homeAddress": homeAddress,
      "officeAddress": officeAddress,
      "carNumber": carNumber,
      "isRegister": isRegister,
      "isAddress": isAddress,
      "isCarVerified": isCarVerified,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
      carNumber: map['carNumber'],
      homeAddress: map['homeAddress'],
      officeAddress: map['officeAddress'],
      password: map['password'],
      isRegister: map['isRegister'],
      isAddress: map['isAddress'],
      isCarVerified: map['isCarVerified'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'carNumber': carNumber ?? '',
      'homeAddress': homeAddress ?? '',
      'officeAddress': officeAddress ?? '',
      'password': password,
      'isRegister': isRegister,
      'isAddress': isAddress,
      'isCarVerified': isCarVerified,
    };
  }
}
