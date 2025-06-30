import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/storage/app_key.dart';
import '../../core/storage/app_preferences.dart';
import '../../services/service_locator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final seen = getX<AppPreference>().getBool(AppKey.onboardingSeen);
    Timer(Duration(seconds: 1), () {
     Navigator.pushReplacementNamed(context,  seen == false ? "/onboarding" : "/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        color: Colors.orange, // Background color
        width: double.infinity,
        child: Image.asset("assets/splash.png"),
      ),
    );
  }
}
