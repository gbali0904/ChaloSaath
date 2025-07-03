class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String? carNumber;
  final String? password;
  final bool? isRegister;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.carNumber,
    this.password,
    this.isRegister,
  });
  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    String? carNumber,
    bool? isRegister,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      carNumber: carNumber ?? this.carNumber,
      isRegister: isRegister ?? this.isRegister,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "fullName": fullName,
      "email": email,
      "phone": phone,
      "role": role,
      "carNumber": carNumber,
      "isRegister": isRegister,
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
      password: map['password'],
      isRegister: map['isRegister'],
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
      'password': password,
      'isRegister': isRegister,
    };
  }
}
