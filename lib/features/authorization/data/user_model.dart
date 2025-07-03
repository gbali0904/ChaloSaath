class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String? carNumber;
  final String? password;
  final String? home_address;
  final String? office_address;
  final bool? isRegister;
  final bool? isAddress;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.carNumber,
    this.home_address,
    this.office_address,
    this.password,
    this.isRegister,
    this.isAddress,
  });
  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    String? home_address,
    String? office_address,
    String? carNumber,
    bool? isRegister,
    bool? isAddress,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      carNumber: carNumber ?? this.carNumber,
      home_address: home_address ?? this.home_address,
      office_address: office_address ?? this.office_address,
      isRegister: isRegister ?? this.isRegister,
      isAddress: isAddress ?? this.isAddress,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "fullName": fullName,
      "email": email,
      "phone": phone,
      "role": role,
      "home_address": home_address,
      "office_address": office_address,
      "carNumber": carNumber,
      "isRegister": isRegister,
      "isAddress": isAddress,
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
      home_address: map['home_address'],
      office_address: map['office_address'],
      password: map['password'],
      isRegister: map['isRegister'],
      isAddress: map['isAddress'],
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
      'home_address': home_address ?? '',
      'office_address': office_address ?? '',
      'password': password,
      'isRegister': isRegister,
      'isAddress': isAddress,
    };
  }
}
