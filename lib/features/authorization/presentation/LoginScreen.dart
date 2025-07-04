import 'dart:convert';

import 'package:chalosaath/features/helper/CustomScaffoldScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/storage/app_key.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/service_locator.dart';
import '../../loader/CustomLoader.dart';
import '../data/authEvent.dart';
import '../data/authState.dart';
import 'auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  final AuthorizationBloc bloc;

  const LoginScreen({super.key, required this.bloc});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => widget.bloc,
      child: BlocListener<AuthorizationBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is LoginSuccess) {
            setState(() {
              isLoading = false;
            });
            await getX<AppPreference>().setBool(AppKey.isLogin, true);
            String data = jsonEncode( state.userCredential);
            await getX<AppPreference>().setString(AppKey.userData,data);
          Navigator.pushReplacementNamed(context, "/home");
          } else if (state is AuthFailure) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            print("${state.message}");
          }
        },
        child: buildUI(),
      ),
    );
  }

  buildUI() {
    return CustomScaffoldScreen(
      body: Stack(
        children: [
          Container(
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
              child: Form(
                key: _formKey,
                child: ListView(
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
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            'assets/email.png',
                            height: 10,
                            width: 10,
                            color:
                                Colors.black, // optional: apply color overlay
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
                      validator: (value) {
                        if (value!.isEmpty) return "Enter email";
                        if (!value.contains("@")) return "Enter valid email";
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            'assets/password.png',
                            height: 10,
                            width: 10,
                            color:
                                Colors.black, // optional: apply color overlay
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
                      validator: (value) {
                        if (value!.isEmpty) return "Enter valid Password";
                        if (value.length != 6)
                          return "Password should be at least 6 characters";

                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.bloc.add(
                              LoginIN(
                                emailController.text,
                                passwordController.text,
                              ),
                            );
                          }
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
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, "/signup",arguments: false);
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          isLoading == true ? CustomLoader() : Container(),
        ],
      ),
    );
  }
}
