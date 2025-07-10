import 'package:equatable/equatable.dart';

abstract class PhoneVerificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PhoneNumberChanged extends PhoneVerificationEvent {
  final String phoneNumber;
  PhoneNumberChanged(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class SendOtp extends PhoneVerificationEvent {
  final String phoneNumber;
  SendOtp(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class OtpChanged extends PhoneVerificationEvent {
  final String otp;
  OtpChanged(this.otp);

  @override
  List<Object?> get props => [otp];
}

class VerifyOtp extends PhoneVerificationEvent {} 