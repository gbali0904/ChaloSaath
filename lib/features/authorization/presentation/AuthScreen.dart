import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/app_colors.dart';
import '../../helper/CustomScaffold.dart';
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
  @override
  Widget build(BuildContext context) {
    return   BlocProvider(
      create: (_) => widget.bloc,
      child: BlocListener<AuthorizationBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // Show loading spinner
          } else if (state is AuthSuccess) {
            print("data ${state.data.user?.uid}");

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Registration successful")),
            );
            Navigator.pop(context);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            print("${state.message}");
          }
        },
        child: buildUI(),
      ),
    );



  }

  buildUI() {
    return   CustomScaffold(
      body :Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/login_bac.png"),
            fit: BoxFit.cover, // or BoxFit.fill / BoxFit.contain
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ElevatedButton(
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
            SizedBox(height: 20,),
            ElevatedButton(
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
            ),


          ],),
        ),

      ),
    );
  }
}
