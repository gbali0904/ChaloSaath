import 'package:chalosaath/features/authorization/data/user_model.dart';

// Base class for all auth events
abstract class AuthEvent {
  const AuthEvent();
}

// User type related events
class LoadUserTypeData extends AuthEvent {
  const LoadUserTypeData();
}

class RoleChanged extends AuthEvent {
  final String role;
  
  const RoleChanged(this.role);
}

// Authentication events
class SignInWithEmail extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmail({
    required this.email,
    required this.password,
  });
}

class SignUpWithEmail extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String phone;
  final String role;
  final String? carNumber;

  const SignUpWithEmail({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.role,
    this.carNumber,
  });
}

class SignInWithGoogle extends AuthEvent {
  const SignInWithGoogle();
}

class SignInWithPhone extends AuthEvent {
  final String phoneNumber;
  final String verificationId;
  final String smsCode;

  const SignInWithPhone({
    required this.phoneNumber,
    required this.verificationId,
    required this.smsCode,
  });
}

class SendPhoneVerificationCode extends AuthEvent {
  final String phoneNumber;

  const SendPhoneVerificationCode(this.phoneNumber);
}

// User management events
class UpdateUserProfile extends AuthEvent {
  final UserModel user;
  final Map<String, dynamic> updates;

  const UpdateUserProfile({
    required this.user,
    required this.updates,
  });
}

class UpdateUserRole extends AuthEvent {
  final String userId;
  final String newRole;
  final String? carNumber;

  const UpdateUserRole({
    required this.userId,
    required this.newRole,
    this.carNumber,
  });
}

class UpdateUserAddresses extends AuthEvent {
  final String userId;
  final String? homeAddress;
  final String? officeAddress;

  const UpdateUserAddresses({
    required this.userId,
    this.homeAddress,
    this.officeAddress,
  });
}

class UpdateUserPreferences extends AuthEvent {
  final String userId;
  final Map<String, dynamic> preferences;

  const UpdateUserPreferences({
    required this.userId,
    required this.preferences,
  });
}

// Verification events
class SendEmailVerification extends AuthEvent {
  const SendEmailVerification();
}

class VerifyEmail extends AuthEvent {
  final String actionCode;

  const VerifyEmail(this.actionCode);
}

class VerifyPhone extends AuthEvent {
  final String phoneNumber;
  final String verificationCode;

  const VerifyPhone({
    required this.phoneNumber,
    required this.verificationCode,
  });
}

// Password management events
class SendPasswordResetEmail extends AuthEvent {
  final String email;

  const SendPasswordResetEmail(this.email);

  @override
  List<Object?> get props => [email];
}

class ChangePassword extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

// Session management events
class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

class RefreshUserData extends AuthEvent {
  const RefreshUserData();
}

class SignOut extends AuthEvent {
  const SignOut();
}

class DeleteAccount extends AuthEvent {
  final String password;

  const DeleteAccount(this.password);

  @override
  List<Object?> get props => [password];
}

// Error handling events
class ClearAuthError extends AuthEvent {
  const ClearAuthError();
}

class RetryAuthOperation extends AuthEvent {
  final AuthEvent originalEvent;

  const RetryAuthOperation(this.originalEvent);

  @override
  List<Object?> get props => [originalEvent];
}

// Profile image events
class UploadProfileImage extends AuthEvent {
  final String imagePath;

  const UploadProfileImage(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class RemoveProfileImage extends AuthEvent {
  const RemoveProfileImage();
}

// Car verification events
class VerifyCarDetails extends AuthEvent {
  final String carNumber;
  final String carModel;
  final String carColor;
  final String licenseNumber;

  const VerifyCarDetails({
    required this.carNumber,
    required this.carModel,
    required this.carColor,
    required this.licenseNumber,
  });

  @override
  List<Object?> get props => [carNumber, carModel, carColor, licenseNumber];
}

class UpdateCarVerificationStatus extends AuthEvent {
  final String userId;
  final bool isVerified;
  final String? verificationNotes;

  const UpdateCarVerificationStatus({
    required this.userId,
    required this.isVerified,
    this.verificationNotes,
  });

  @override
  List<Object?> get props => [userId, isVerified, verificationNotes];
}

class RegisterUser extends AuthEvent {
  final UserModel userData;
  const RegisterUser(this.userData);
}

class LoginIN extends AuthEvent {
  final String email;
  final String password;
  const LoginIN(this.email, this.password);
}

class CheckUser extends AuthEvent {
  final String email;
  const CheckUser(this.email);
}
 