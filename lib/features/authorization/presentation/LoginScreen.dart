import 'package:chalosaath/features/helper/CustomScaffold.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/login_bac.png"),
            fit: BoxFit.cover, // or BoxFit.fill / BoxFit.contain
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              SizedBox(height: 100),
              Image.asset("assets/logo.png", height: 90, width: 90),
              Center(
                child: Text(
                  "Login",
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/email.png',
                      height: 10,
                      width: 10,
                      color: Colors.black, // optional: apply color overlay
                    ),
                  ),
                  iconColor: Colors.black,
                  hintStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color:AppColors.underline,
                    ), // default underline
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary,
                    ), // underline on focus
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/password.png',
                      height: 10,
                      width: 10,
                      color: Colors.black, // optional: apply color overlay
                    ),
                  ),
                  iconColor: Colors.black,
                  hintStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.underline,
                    ), // default underline
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary,
                    ), // underline on focus
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle tap
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    "Login",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: "Don’t have an account ? ",
                  style: GoogleFonts.inter(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: GoogleFonts.inter(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        Navigator.pushReplacementNamed(context, "/signup");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
