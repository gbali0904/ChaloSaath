import 'dart:convert';

import 'package:chalosaath/features/helper/CustomScaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../core/storage/app_key.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/service_locator.dart';
import '../../loader/CustomLoader.dart';
import '../data/auth_event.dart';
import '../data/auth_state.dart';
import '../data/user_model.dart';
import 'auth_bloc.dart';

class SignUpScreen extends StatefulWidget {
  final AuthorizationBloc bloc;
  final bool args;

  const SignUpScreen({super.key, required this.bloc, required this.args});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedUserType;
  List<String> userTypedata = [];
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final carNumberController = TextEditingController();
  bool isLoading = false;

  var uid = "";

  late UserModel user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.bloc.add(LoadUserTypeData());
    try {
      final userJson = widget.args == false
          ? getX<AppPreference>().getString(AppKey.googleData)
          : getX<AppPreference>().getString(AppKey.userData);
      if (userJson != null && userJson.isNotEmpty) {
        final map = jsonDecode(userJson);
        user = UserModel.fromMap(map);
      } else {
        user = UserModel.empty();
      }
    } catch (e) {
      print('Error loading user data in signup: $e');
      user = UserModel.empty();
    }
    emailController.text = user.email;
    fullNameController.text = user.fullName;
    uid = user.uid;
    phoneController.text = user.phone != "null" ? user.phone : "";
    if (widget.args == true) {
      selectedUserType = user.role;
    }
    if (widget.args == true && user.role == "Pilot") {
      carNumberController.text = user.carNumber.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => widget.bloc,
      child: BlocListener<AuthorizationBloc, AuthState>(
        listener: (context, state) async {
          if (state is UserTypeLoaded) {
            setState(() {
              isLoading = false;
              userTypedata = state.data;
            });
          } else if (state is RoleChangedData) {
            setState(() {
              isLoading = false;
              selectedUserType = state.data;
            });
          } else if (state is AuthLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is AuthSuccess) {
            setState(() {
              isLoading = false;
            });
            await getX<AppPreference>().setString(
              AppKey.userData,
              state.userCredential!.toJson(),
            );
            await getX<AppPreference>().setBool(AppKey.isLogin, true);
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
    return CustomScaffold(
      backpress: widget.args,
      profile: true,
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
                    SizedBox(height: 50),
                    Center(
                      child: Text(
                        "Update Account",
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 35,
                        ),
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.underline),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 14,
                        ),
                      ),
                      value: selectedUserType,
                      hint: Text(
                        'Select Role',
                        style: TextStyle(color: Colors.grey),
                      ),
                      items: userTypedata.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedUserType = value);
                        widget.bloc.add(RoleChanged(value!));
                        carNumberController.text = "";
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a role';
                        }
                        return null;
                      },
                    ),

                    Visibility(
                      visible: selectedUserType == "Pilot",
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          TextFormField(
                            controller: carNumberController,
                            decoration: InputDecoration(
                              hintText: "Car Number",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(
                                  'assets/car.png',
                                  height: 10,
                                  width: 10,
                                  color: Colors
                                      .black, // optional: apply color overlay
                                ),
                              ),

                              hintStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.underline,
                                ), // default underline
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                ), // underline on focus
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter car number';
                              }
                              if (!RegExp(
                                r'^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$',
                              ).hasMatch(value.trim().toUpperCase())) {
                                return 'Invalid car number format';
                              }
                              return null;
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      enabled: false,
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
                      controller: fullNameController,
                      decoration: InputDecoration(
                        hintText: "Full Name",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            'assets/name.png',
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
                      validator: (value) =>
                          value!.isEmpty ? "Enter full name" : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: phoneController,
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: "Mobile Number",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            'assets/mobile.png',
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
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) return "Enter mobile number";
                        if (value.length != 10) return "Enter 10 digit number";
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final user = UserModel(
                              uid: uid,
                              fullName: fullNameController.text.trim(),
                              email: emailController.text.trim(),
                              phone: phoneController.text.trim(),
                              role: selectedUserType ?? '',
                              carNumber: selectedUserType == "Pilot"
                                  ? carNumberController.text.trim()
                                  : '',
                              isRegister: true,
                              isCarVerified: false,
                              isEmailVerified: true,
                            );
                            widget.bloc.add(RegisterUser(user));
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
                          "Save",
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
