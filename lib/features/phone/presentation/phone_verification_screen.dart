import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/phone_verification_event.dart';
import '../data/phone_verification_state.dart';
import 'phone_verification_bloc.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final PhoneVerificationBloc bloc;
  const PhoneVerificationScreen({Key? key, required this.bloc}) : super(key: key);

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: Scaffold(
        body: BlocListener<PhoneVerificationBloc, PhoneVerificationState>(
          listener: (context, state) {
            if (!state.isSubmitting && state.error == null && state.otpSent && state.otp.length == 6) {
              Navigator.pushReplacementNamed(context, '/profile-setup', arguments: state.phoneNumber);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: BlocBuilder<PhoneVerificationBloc, PhoneVerificationState>(
                builder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xFF0D1526),
                          child: Icon(Icons.phone, color: Colors.white, size: 40),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Phone Verification',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D1526),
                          ),
                        ),
                        const SizedBox(height: 32),
                        if (state.isSubmitting && !state.otpSent) ...[
                          // Show only loader while sending OTP
                          const SizedBox(height: 32),
                          const CircularProgressIndicator(),
                        ] else if (!state.otpSent) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Phone Number',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: const Text(
                                  '+91',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    hintText: '9876543210',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  ),
                                  onChanged: (value) {
                                    // Only allow digits
                                    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
                                    widget.bloc.add(PhoneNumberChanged(digits));
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: state.isValid && !state.isSubmitting
                                  ? () {
                                      final phone = '+91${state.phoneNumber}';
                                      widget.bloc.add(SendOtp(phone));
                                    }
                                  : null,
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 8),
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter OTP',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) =>    widget.bloc
                                .add(OtpChanged(value)),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state.otp.length == 6 && !state.isSubmitting
                                  ? () =>    widget.bloc
                                      .add(VerifyOtp())
                                  : null,
                              child: state.isSubmitting
                                  ? const CircularProgressIndicator()
                                  : const Text('Verify OTP'),
                            ),
                          ),
                        ],
                        if (state.error != null) ...[
                          const SizedBox(height: 16),
                          Text(state.error!, style: TextStyle(color: Colors.red)),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
} 