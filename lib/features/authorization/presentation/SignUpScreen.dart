import 'package:chalosaath/features/authorization/data/authEvent.dart';
import 'package:chalosaath/features/authorization/data/authState.dart';
import 'package:chalosaath/features/helper/CustomScaffold.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'auth_bloc.dart';

class SignUpScreen extends StatefulWidget {
  final AuthorizationBloc bloc;

  const SignUpScreen({super.key, required this.bloc});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? selectedUserType;
  List<String> userTypedata = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.bloc.add(LoadUserTypeData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: widget.bloc,
      builder: (context, state) {
        if (state is UserTypeLoaded) {
          userTypedata = state.data;
          return buildUI();
        } else if (state is RoleChangedData) {
          selectedUserType = state.data;
        }
        return buildUI();
      },
    );
  }

  buildUI() {
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
                  prefixIcon: Icon(Icons.person, color: Colors.black, size: 35),
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
                hint: Text('Select Role', style: TextStyle(color: Colors.grey)),
                items: userTypedata.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  widget.bloc.add(RoleChanged(value!));
                },
              ),

              Visibility(
                visible: selectedUserType == "Pilot",
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Car Number",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            'assets/car.png',
                            height: 10,
                            width: 10,
                            color: Colors.black, // optional: apply color overlay
                          ),
                        ),

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
                  ],
                ),
              ),
              SizedBox(height: 10),
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

              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: "Confirm Password",
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
              RichText(
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
                      recognizer: TapGestureRecognizer()..onTap = () {
                        Navigator.pushReplacementNamed(context, "/login");
                        
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
