import 'package:chalosaath/features/authorization/data/authEvent.dart';
import 'package:chalosaath/features/authorization/data/authState.dart';
import 'package:chalosaath/features/helper/CustomScaffold.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../theme/app_colors.dart';
import '../../loader/CustomLoader.dart';
import '../data/user_model.dart';
import 'auth_bloc.dart';

class SignUpScreen extends StatefulWidget {
  final AuthorizationBloc bloc;

  const SignUpScreen({super.key, required this.bloc});

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.bloc.add(LoadUserTypeData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => widget.bloc,
      child: BlocListener<AuthorizationBloc, AuthState>(
        listener: (context, state) {
          if (state is UserTypeLoaded) {
            setState(() {
              isLoading= false;
              userTypedata = state.data;
            });
          } else if (state is RoleChangedData) {
            setState(() {
              isLoading= false;
              selectedUserType = state.data;
            });
          } else if (state is AuthLoading) {
            setState(() {
              isLoading= true;
            });
          } else if (state is AuthSuccess) {
            setState(() {
              isLoading= false;
            });

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Registration successful")));
            Navigator.pop(context);
          } else if (state is AuthFailure) {
            setState(() {
              isLoading= false;
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
      backpress: true,
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
                        "Create an account",
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
                    SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
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
                    SizedBox(height: 10),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
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
                        if (value != passwordController.text) {
                          return "Passwords do not match";
                        }

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
                              uid: Uuid().v4(),
                              fullName: fullNameController.text.trim(),
                              email: emailController.text.trim(),
                              phone: phoneController.text.trim(),
                              role: selectedUserType ?? '',
                              carNumber: selectedUserType == "Pilot"
                                  ? carNumberController.text.trim()
                                  : '',
                              password: passwordController.text,
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
                          "Sign UP",
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account ? ",
                          style: GoogleFonts.inter(color: Colors.black),
                          children: [
                            TextSpan(
                              text: " Login Up",
                              style: GoogleFonts.inter(
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    "/login",
                                  );
                                },
                            ),
                          ],
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
