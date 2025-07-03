import 'package:chalosaath/features/helper/CustomScaffold.dart';
import 'package:flutter/material.dart';

import '../../../core/storage/app_key.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../services/service_locator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        profile: true,
        backpress: true,
        body: InkWell(
            onTap: () async =>{
            await getX<AppPreference>().clearAllExceptOnboardingSeen(),
              Navigator.pushReplacementNamed(context, "/auth")
            },
            child: Text("LogOUt")));
  }
}
