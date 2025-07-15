import 'dart:convert';

import 'package:chalosaath/core/theme/app_colors.dart';
import 'package:chalosaath/features/helper/custome_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late UserModel user_data;
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    try {
      final userJson = getX<AppPreference>().getString(AppKey.userData);
      if (userJson != null && userJson.isNotEmpty) {
        final map = jsonDecode(userJson);
        user_data = UserModel.fromMap(map);
      } else {
        user_data = UserModel.empty();
      }
    } catch (e) {
      print('Error loading user data in profile: $e');
      user_data = UserModel.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      context: context,
      title: "Profile",
      appbarstatus: false,
      body: _buildBody(context),
    );
  }
  _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Profile Card
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: const Color(0xFFE5E7EB),
                      child: Text(
                        user_data.fullName.isNotEmpty ? user_data.fullName[0].toUpperCase() : '',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF232B3B)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user_data.fullName,
                                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE5F6EA),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.verified, color: Color(0xFF2ECC71), size: 16),
                                    SizedBox(width: 2),
                                    Text('Verified', style: TextStyle(fontSize: 12, color: Color(0xFF2ECC71), fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user_data.homeAddress ?? '',
                            style: const TextStyle(color: Color(0xFF8A94A6)),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                              SizedBox(width: 4),
                              Text('4.8 ', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('(156 rides)', style: TextStyle(color: Color(0xFF8A94A6), fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: const [
                            Text('89', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            SizedBox(height: 2),
                            Text('Rides Hosted', style: TextStyle(color: Color(0xFF8A94A6), fontSize: 13)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: const [
                            Text('67', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            SizedBox(height: 2),
                            Text('Rides Booked', style: TextStyle(color: Color(0xFF8A94A6), fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        // Contact Information
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Contact Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 18, color: Color(0xFF8A94A6)),
                    const SizedBox(width: 8),
                    Text(user_data.phone ?? '', style: const TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.email, size: 18, color: Color(0xFF8A94A6)),
                    const SizedBox(width: 8),
                    Text(user_data.email ?? '', style: const TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18, color: Color(0xFF8A94A6)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(user_data.homeAddress ?? '', style: const TextStyle(fontSize: 15))),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Vehicle Information
        Visibility(
          visible: user_data.isCarVerified ?? false,
          child: Column(
            children: [
              const SizedBox(height: 18),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Vehicle Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text('Model', style: TextStyle(color: Color(0xFF8A94A6))),
                          const Spacer(),
                          Text('Honda City', style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Color', style: TextStyle(color: Color(0xFF8A94A6))),
                          const Spacer(),
                          Text('Silver', style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Number Plate', style: TextStyle(color: Color(0xFF8A94A6))),
                          const Spacer(),
                          Text(user_data.carNumber ?? 'HR26 DK 1234', style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),
        // Settings
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                SwitchListTile(
                  value: notificationsEnabled,
                  onChanged: (val) => setState(() => notificationsEnabled = val),
                  title: const Text('Notifications'),
                  subtitle: const Text('Ride alerts and updates'),
                ),
                SwitchListTile(
                  value: darkModeEnabled,
                  onChanged: (val) => setState(() => darkModeEnabled = val),
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Change app appearance'),
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & Support'),
                  subtitle: const Text('FAQs and contact support'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy & Safety'),
                  subtitle: const Text('Data and safety settings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log Out'),
                  subtitle: const Text('Sign out of your account'),
                  onTap: () async {
                    await getX<AppPreference>().clearAllExceptOnboardingSeen();
                    Navigator.pushReplacementNamed(context, "/auth");
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
