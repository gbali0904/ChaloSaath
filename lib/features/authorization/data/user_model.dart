import 'dart:convert';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String phone;
  final String role;
  final String? carNumber;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final Map<String, dynamic>? preferences;
  final bool? isAddress;
  final bool? isRegister;
  final bool? isCarVerified;
  final String? homeAddress;
  final String? officeAddress;

  const UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
    this.carNumber,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.preferences,
    this.isAddress,
    this.isRegister,
    this.isCarVerified,
    this.homeAddress,
    this.officeAddress,
  });

  // Factory constructor from JSON
  factory UserModel.fromJson(String json) {
    try {
      final Map<String, dynamic> data = jsonDecode(json);
      return UserModel.fromMap(data);
    } catch (e) {
      throw FormatException('Invalid JSON format: $e');
    }
  }

  // Factory constructor from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      fullName: map['fullName']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      role: map['role']?.toString() ?? '',
      carNumber: map['carNumber']?.toString(),
      profileImage: map['profileImage']?.toString(),
      createdAt: map['createdAt'] != null 
          ? DateTime.tryParse(map['createdAt'].toString()) 
          : null,
      updatedAt: map['updatedAt'] != null 
          ? DateTime.tryParse(map['updatedAt'].toString()) 
          : null,
      isEmailVerified: map['isEmailVerified'] ?? false,
      isPhoneVerified: map['isPhoneVerified'] ?? false,
      preferences: map['preferences'] != null
          ? Map<String, dynamic>.from(map['preferences'])
          : null,
      isAddress: map['isAddress'],
      isRegister: map['isRegister'],
      isCarVerified: map['isCarVerified'],
      homeAddress: map['homeAddress']?.toString(),
      officeAddress: map['officeAddress']?.toString(),
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'role': role,
      'carNumber': carNumber,
      'profileImage': profileImage,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'preferences': preferences,
      'isAddress': isAddress,
      'isRegister': isRegister,
      'isCarVerified': isCarVerified,
      'homeAddress': homeAddress,
      'officeAddress': officeAddress,
    };
  }

  // Convert to JSON
  String toJson() => jsonEncode(toMap());

  // Create a copy with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? phone,
    String? role,
    String? carNumber,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    Map<String, dynamic>? preferences,
    bool? isAddress,
    bool? isRegister,
    bool? isCarVerified,
    String? homeAddress,
    String? officeAddress,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      carNumber: carNumber ?? this.carNumber,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      preferences: preferences ?? this.preferences,
      isAddress: isAddress ?? this.isAddress,
      isRegister: isRegister ?? this.isRegister,
      isCarVerified: isCarVerified ?? this.isCarVerified,
      homeAddress: homeAddress ?? this.homeAddress,
      officeAddress: officeAddress ?? this.officeAddress,
    );
  }

  // Validation methods
  bool get isValid {
    return uid.isNotEmpty && 
           email.isNotEmpty && 
           fullName.isNotEmpty && 
           phone.isNotEmpty && 
           role.isNotEmpty;
  }

  bool get isDriver => role.toLowerCase() == 'driver' || role.toLowerCase() == 'pilot';
  bool get isPassenger => role.toLowerCase() == 'passenger';
  bool get hasCarNumber => carNumber != null && carNumber!.isNotEmpty;

  // Equality and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, fullName: $fullName, role: $role)';
  }

  // Static methods for validation
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phone);
  }

  static bool isValidName(String name) {
    return name.trim().isNotEmpty && name.trim().length <= 50;
  }

  static bool isValidRole(String role) {
    final validRoles = ['driver', 'passenger', 'pilot'];
    return validRoles.contains(role.toLowerCase());
  }

  // Create empty user
  static UserModel empty() {
    return const UserModel(
      uid: '',
      email: '',
      fullName: '',
      phone: '',
      role: '',
      isAddress: null,
      isRegister: null,
      isCarVerified: null,
      homeAddress: null,
      officeAddress: null,
    );
  }

  // Check if user is empty
  bool get isEmpty => uid.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
