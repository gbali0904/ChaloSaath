import 'dart:async';
import 'package:chalosaath/features/helper/CustomScaffoldScreen.dart';
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
    final isLogin = getX<AppPreference>().getBool(AppKey.isLogin);
    Timer(Duration(seconds: 1), () {
     Navigator.pushReplacementNamed(context,  seen == false ? "/onboarding" :isLogin == false? "/auth":"/home");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
        height: double.maxFinite,
        width: double.infinity,
        child: Image.asset("assets/splash.png",fit: BoxFit.cover),
      ),
    );
  }
}
