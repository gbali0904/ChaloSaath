import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data_providers/domain/base_firebase_service.dart';
import '../data/phone_verification_event.dart';
import '../data/phone_verification_state.dart';

class PhoneVerificationBloc extends Bloc<PhoneVerificationEvent, PhoneVerificationState> {
  final BaseFirebaseService firebaseService;

  PhoneVerificationBloc(this.firebaseService) : super(const PhoneVerificationState()) {
    on<PhoneNumberChanged>((event, emit) {
      emit(state.copyWith(
        phoneNumber: event.phoneNumber,
        isValid: _validatePhone(event.phoneNumber),
      ));
    });

    on<SendOtp>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, error: null));
      // Dummy/test number logic
      if (event.phoneNumber == '+911234567890') {
        await Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(
          isSubmitting: false,
          otpSent: true,
          verificationId: 'dummy-verification-id',
        ));
        return;
      }
      await firebaseService.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        codeSent: (verificationId) {
          emit(state.copyWith(
            isSubmitting: false,
            otpSent: true,
            verificationId: verificationId,
          ));
        },
        verificationFailed: (error) {
          emit(state.copyWith(isSubmitting: false, error: error.message));
        },
        codeAutoRetrievalTimeout: (verificationId, _) {
          emit(state.copyWith(verificationId: verificationId));
        },
        verificationCompleted: (credential) async {
          try {
            await firebaseService.signInWithPhoneCredential(credential);
            emit(state.copyWith(isSubmitting: false));
            // Handle auto sign-in if needed
          } catch (e) {
            emit(state.copyWith(isSubmitting: false, error: e.toString()));
          }
        },
      );
    });

    on<OtpChanged>((event, emit) {
      emit(state.copyWith(otp: event.otp));
    });

    on<VerifyOtp>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, error: null));
      // Dummy/test number logic
      if (state.phoneNumber == '+911234567890' && state.otp == '123456') {
        await Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(isSubmitting: false));
        // Navigate or show success
        return;
      }
      try {
        final credential = firebaseService.getPhoneCredential(state.verificationId, state.otp);
        await firebaseService.signInWithPhoneCredential(credential);
        emit(state.copyWith(isSubmitting: false));
        // Navigate or show success
      } catch (e) {
        emit(state.copyWith(isSubmitting: false, error: e.toString()));
      }
    });
  }

  bool _validatePhone(String phone) {
    // Simple validation for Indian phone numbers
    return RegExp(r'^\d{10}$').hasMatch(phone);

  }
} 