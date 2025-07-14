import 'dart:convert';

import 'package:chalosaath/features/helper/CustomScaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../address/presentation/address_search_bloc.dart';
import '../../address/data/AddressSearchEvent.dart';
import '../../address/data/AddressSearchState.dart';
import '../../address/domain/address_repo_impl.dart';
import '../../../core/storage/app_key.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/service_locator.dart';
import '../../loader/CustomLoader.dart';
import '../../authorization/data/auth_event.dart';
import '../../authorization/data/auth_state.dart';
import '../../authorization/data/user_model.dart';
import '../../authorization/presentation/auth_bloc.dart';

class ProfileSetUpScreen extends StatefulWidget {
  final AuthorizationBloc bloc;
  final bool args;

  const ProfileSetUpScreen({super.key, required this.bloc, required this.args});

  @override
  State<ProfileSetUpScreen> createState() => _ProfileSetUpScreenState();
}

class _ProfileSetUpScreenState extends State<ProfileSetUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedUserType;
  List<String> userTypedata = [];
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final carNumberController = TextEditingController();
  final pickupController = TextEditingController();
  final dropoffController = TextEditingController();
  bool isLoading = false;
  // Removed: List<String> _suggestions = [];

  var uid = "";

  late UserModel user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.bloc.add(LoadUserTypeData());
    try {
      final userJson = widget.args == false
          ? getX<AppPreference>().getString(AppKey.googleData)
          : getX<AppPreference>().getString(AppKey.userData);
      if (userJson != null && userJson.isNotEmpty) {
        final map = jsonDecode(userJson);
        user = UserModel.fromMap(map);
      } else {
        user = UserModel.empty();
      }
    } catch (e) {
      print('Error loading user data in signup: $e');
      user = UserModel.empty();
    }
    emailController.text = user.email;
    fullNameController.text = user.fullName;
    uid = user.uid;
    phoneController.text = user.phone != "null" ? user.phone : "";
    if (widget.args == true) {
      selectedUserType = user.role;
    }
    if (widget.args == true && user.role == "Pilot") {
      carNumberController.text = user.carNumber.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthorizationBloc>.value(value: widget.bloc),
        BlocProvider<AddressSearchBloc>(
          create: (_) => AddressSearchBloc(AddressRepoImpl(getX())),
        ),
      ],
      child: BlocListener<AuthorizationBloc, AuthState>(
        listener: (context, state) async {
          if (state is UserTypeLoaded) {
            setState(() {
              isLoading = false;
              userTypedata = state.data;
            });
          } else if (state is RoleChangedData) {
            setState(() {
              isLoading = false;
              selectedUserType = state.data;
            });
          } else if (state is AuthLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is AuthSuccess) {
            setState(() {
              isLoading = false;
            });
            await getX<AppPreference>().setString(
              AppKey.userData,
              state.userCredential!.toJson(),
            );
            await getX<AppPreference>().setBool(AppKey.isLogin, true);
            Navigator.pushReplacementNamed(context, "/home");
          } else if (state is AuthFailure) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            print("${state.message}");
          }
        },
        child: CustomScaffold(
          profile: true,
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                width: 400,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFF232B3B),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Setup Profile",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF232B3B),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          "Tell us a bit about yourself",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF8A94A6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Full Name',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          hintText: "Enter your full name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: Icon(Icons.more_horiz),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter your full name'
                            : null,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Mobile Number',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          hintText: 'Enter your mobile number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(Icons.phone),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Enter mobile number';
                          if (value.length != 10) return 'Enter 10 digit number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Pickup Location',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<AddressSearchBloc, AddressSearchState>(
                        builder: (context, state) {
                          List<String> suggestions = [];
                          if (state is AddressLoaded) {
                            suggestions = state.suggestions;
                          }
                          return TypeAheadField<String>(
                            controller: pickupController,
                            suggestionsCallback: (pattern) {
                              if (pattern.isNotEmpty) {
                                context.read<AddressSearchBloc>().add(FetchAddressSuggestions(pattern));
                              }
                              return suggestions;
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(title: Text(suggestion));
                            },
                            onSelected: (suggestion) {
                              pickupController.text = suggestion;
                            },
                            builder: (context, controller, focusNode) {
                              return TextFormField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  hintText: 'Where do you usually start from?',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) => value == null || value.isEmpty
                                    ? 'Enter pickup location'
                                    : null,
                              );
                            },
                            decorationBuilder: (context, child) {
                              return Material(
                                color: Colors.white,
                                elevation: 4,
                                borderRadius: BorderRadius.circular(8),
                                child: child,
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Drop-off Location',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<AddressSearchBloc, AddressSearchState>(
                        builder: (context, state) {
                          List<String> suggestions = [];
                          if (state is AddressLoaded) {
                            suggestions = state.suggestions;
                          }
                          return TypeAheadField<String>(
                            controller: dropoffController,
                            suggestionsCallback: (pattern) {
                              if (pattern.isNotEmpty) {
                                context.read<AddressSearchBloc>().add(FetchAddressSuggestions(pattern));
                              }
                              return suggestions;
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(title: Text(suggestion));
                            },
                            onSelected: (suggestion) {
                              dropoffController.text = suggestion;
                            },
                            builder: (context, controller, focusNode) {
                              return TextFormField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  hintText: 'Where do you usually go?',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) => value == null || value.isEmpty
                                    ? 'Enter drop-off location'
                                    : null,
                              );
                            },
                            decorationBuilder: (context, child) {
                              return Material(
                                color: Colors.white,
                                elevation: 4,
                                borderRadius: BorderRadius.circular(8),
                                child: child,
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: const [
                          Text('Vehicle Details', style: TextStyle(fontWeight: FontWeight.w600)),
                          SizedBox(width: 4),
                          Text('(Optional)', style: TextStyle(fontSize: 12, color: Color(0xFF8A94A6))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: carNumberController,
                        decoration: InputDecoration(
                          hintText: 'MH01AB1234',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final user = UserModel(
                                uid: uid,
                                fullName: fullNameController.text.trim(),
                                email: emailController.text.trim(),
                                phone: phoneController.text.trim(),
                                role: selectedUserType ?? '',
                                carNumber: selectedUserType == "Pilot"
                                    ? carNumberController.text.trim()
                                    : '',
                                isRegister: true,
                                isCarVerified: false,
                                isEmailVerified: true,
                                isAddress: true,
                                homeAddress: pickupController.text,
                                officeAddress: dropoffController.text,
                              );
                              widget.bloc.add(RegisterUser(user));
                            }
                          },
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Complete Setup',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
