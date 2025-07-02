import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/storage/app_key.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/service_locator.dart';
import '../../helper/CustomScaffold.dart';
import '../../loader/CustomLoader.dart';
import '../data/authEvent.dart';
import '../data/authState.dart';
import 'auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  final AuthorizationBloc bloc;

  const AuthScreen({super.key, required this.bloc});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  bool isLoading = false;
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
            print("userData ${state.userCredential.user?.email}");
            String? email =  state.userCredential.user!.email.toString();
            String? uid =  state.userCredential.user!.uid.toString();
            await getX<AppPreference>().setString(AppKey.email,email);
            await getX<AppPreference>().setString(AppKey.uid,uid);
            final isLogin = getX<AppPreference>().getBool(AppKey.isLogin);
            Navigator.pushReplacementNamed(context,  isLogin == false ? "/signup" :"/home");

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
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => widget.bloc.add(SignInWithGoogle()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text("Login with Google"),
                      ),
                    ),
                    SizedBox(height: 20),

                    /*ElevatedButton(
                    onPressed: () {
                      final phoneNumber = "9876543210"; // From input field
                      widget.bloc.add(SignInWithWhatsApp(phoneNumber));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text("Login with WhatsApp"),
                  ),*/
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
