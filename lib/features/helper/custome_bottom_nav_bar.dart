import 'package:chalosaath/core/routes/route_constants.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Widget? body;
  final bool backpress;
  final AppBar? appbar;
  final bool? appbarstatus;
  final bool profile;
  final String? title;
  final VoidCallback? onBackPress;
  final BuildContext? context;
  final bool showBottomBar;

  const CustomBottomNavBar({
    super.key,
    required this.context,
    this.title,
    this.body,
    this.backpress = false,
    this.appbarstatus = false,
    this.appbar,
    this.profile = false,
    this.onBackPress,
    this.showBottomBar = true,
  });

  @override
  Widget build(BuildContext context) {
    var currentIndex = 2;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appbarstatus == true?appbar:
      title != "" ? AppBar(
        automaticallyImplyLeading: backpress,
        title: Text(
          title.toString(),
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.white),
        leading: backpress
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (onBackPress != null) {
              onBackPress!();
            } else {
              Navigator.of(context).pop();
            }
          },
        )
            : null,
      ):null,

      body: body,
      bottomNavigationBar: showBottomBar
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF232B3B),
              unselectedItemColor: const Color(0xFF8A94A6),
              showUnselectedLabels: true,
              currentIndex: currentIndex,
              onTap: (index) {
                onTabChanged(index, context);
              },
              backgroundColor: Colors.white,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Find'),
                BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Offer'),
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'My Rides'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            )
          : null,
    );
  }

  void onTabChanged(int index, BuildContext context) {
    if (index == 4) {
      Navigator.pushReplacementNamed(context, RouteConstants.profile);
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, RouteConstants.home);
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context,  RouteConstants.offerRide);
    }
  }
}
