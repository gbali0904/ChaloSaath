
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final bool backpress;
  final VoidCallback? onBackPress;

  const CustomScaffold({
    super.key,
    required this.body,
    this.backpress = false,
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
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
      ),

      body: body,
    );
  }
}
