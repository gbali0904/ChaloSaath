
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final bool backpress;
  final bool appbar;
  final bool profile;
  final VoidCallback? onBackPress;

  const CustomScaffold({
    super.key,
    required this.body,
    this.backpress = false,
    this.appbar = true,
    this.profile = false,
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appbar == true ?
      AppBar(
        automaticallyImplyLeading: backpress,
        title: const Text(
          "Chalo Saath",
          style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor:AppColors.primary,
        iconTheme: IconThemeData(
          color: AppColors.white,
        ),
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
        actions: [
          ?profile == false ? IconButton(
            icon: const Icon(Icons.account_circle, size: 28),
            onPressed: () {
              Navigator.pushNamed(context, "/profile"); // or your desired route
            },
          ): null,
        ],
      ):null,

      body: body,
    );
  }
}


