import 'package:equatable/equatable.dart';

class PhoneVerificationState extends Equatable {
  final String phoneNumber;
  final bool isValid;
  final bool isSubmitting;
  final bool otpSent;
  final String otp;
  final String verificationId;
  final String? error;

  const PhoneVerificationState({
    this.phoneNumber = '',
    this.isValid = false,
    this.isSubmitting = false,
    this.otpSent = false,
    this.otp = '',
    this.verificationId = '',
    this.error,
  });

  PhoneVerificationState copyWith({
    String? phoneNumber,
    bool? isValid,
    bool? isSubmitting,
    bool? otpSent,
    String? otp,
    String? verificationId,
    String? error,
  }) {
    return PhoneVerificationState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isValid: isValid ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      otpSent: otpSent ?? this.otpSent,
      otp: otp ?? this.otp,
      verificationId: verificationId ?? this.verificationId,
      error: error,
    );
  }

  @override
  List<Object?> get props => [phoneNumber, isValid, isSubmitting, otpSent, otp, verificationId, error];
} 