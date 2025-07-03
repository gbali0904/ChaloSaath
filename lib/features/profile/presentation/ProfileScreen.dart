import 'dart:convert';

import 'package:chalosaath/features/helper/CustomScaffold.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/storage/app_key.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../services/service_locator.dart';
import '../../authorization/data/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var user_data;

  @override
  void initState() {
    super.initState();
    final userJson = getX<AppPreference>().getString(AppKey.userData);
    final map = jsonDecode(userJson);
    user_data = UserModel.fromMap(map);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      profile: true,
      backpress: true,
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                    "assets/profile_user.png",
                  ),
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
              const SizedBox(width: 12),
              Center(
                child: Text(
                  user_data.fullName,
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Divider(),
              Visibility(
                visible: user_data.role == "Pilot",
                child: Row(
                  children: [
                    Text('Car Number: ${user_data.carNumber}'),
                    SizedBox(width: 6),
                    Icon(
                      user_data.isCarVerified == true
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: user_data.isCarVerified == true
                          ? Colors.green
                          : Colors.red,
                      size: 18,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: ()=>{
                  Navigator.pushNamed(context, '/signup',arguments: true)
                },
                child: Text('Edit Profile', style: GoogleFonts.inter(
                  fontSize: 20,
                  color: Colors.black,
                ),),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: ()=>{
                  Navigator.pushNamed(context, "/address",arguments: true)
                },
                child: Text('Address', style: GoogleFonts.inter(
                  fontSize: 20,
                  color: Colors.black,
                ),),
              ),
              const SizedBox(height: 10),
              Text('Timing', style: GoogleFonts.inter(
                fontSize: 20,
                color: Colors.black,
              ),),
              SizedBox(height: 10,),
              InkWell(
                onTap: () async => {
                  await getX<AppPreference>().clearAllExceptOnboardingSeen(),
                  Navigator.pushReplacementNamed(context, "/auth"),
                },
                child: Text("LogOut" ,style: GoogleFonts.inter(
                  fontSize: 20,
                  color: Colors.black,
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
