
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/storage/app_key.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/service_locator.dart';
import '../../helper/CustomScaffold.dart';
import '../data/auth_event.dart';
import '../data/auth_state.dart';
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
            String data = state.userCredential.toJson();
            await getX<AppPreference>().setString(AppKey.googleData, data);
            widget.bloc.add(CheckUser(state.userCredential.email));
          } else if (state is UserSuccess) {
            setState(() {
              isLoading = false;
            });

            if (state.userCredential != null &&
                state.userCredential?.isRegister == true) {
              String data = state.userCredential!.toJson();
              await getX<AppPreference>().setString(AppKey.userData, data);
              await getX<AppPreference>().setBool(AppKey.isLogin, true);
              Navigator.pushReplacementNamed(context, "/home");
            } else {
              Navigator.pushReplacementNamed(context, "/signup",arguments: true);
            }
          } else if (state is UserFail) {
            setState(() {
              isLoading = false;
            });
            final isLogin = getX<AppPreference>().getBool(AppKey.isLogin);
            Navigator.pushReplacementNamed(
              context,
              isLogin == false ? "/signup"  : "/home", arguments:false
            );
          } else if (state is AuthFailure) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: buildUI(),
      ),
    );
  }

  buildUI() {
    return CustomScaffold(
      appbar: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  AppConstants.tagline,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.20),
                      borderRadius: BorderRadius.only(topLeft:Radius.circular(20.0),topRight:Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.10),
                          blurRadius: 50,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.18),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(28),
                          child: const Icon(Icons.directions_car, color: Colors.white, size: 54),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          AppConstants.welcome,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          AppConstants.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            _FeatureIcon(icon: Icons.person, label: AppConstants.safe),
                            _FeatureIcon(icon: Icons.phone, label: AppConstants.easy),
                            _FeatureIcon(icon: Icons.directions_car, label: AppConstants.reliable),
                          ],
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder(),
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () => widget.bloc.add(SignInWithGoogle()),
                            child: Ink(
                              decoration:  BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFFF48C45), AppColors.primary],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(32)),
                              ),
                              child: Container(
                                height: 56,
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(width: 12),
                                    const Text(
                                      AppConstants.loginWithGoogle,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          AppConstants.secureAuth,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isLoading) ...[
                  const SizedBox(height: 32),
                  const CircularProgressIndicator(color: Colors.white),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary,
          radius: 24,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style:  TextStyle(
            fontSize: 16,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
