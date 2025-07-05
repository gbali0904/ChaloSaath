import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/storage/app_key.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/service_locator.dart';
import '../../authorization/data/user_model.dart';
import '../../helper/CustomScaffold.dart';
import '../../home/data/HomeEvent.dart';
import '../../home/data/HomeState.dart';
import '../../home/presentation/home_bloc.dart';
import '../../loader/CustomLoader.dart';
import '../data/AddressSearchEvent.dart';
import '../data/AddressSearchState.dart';
import 'address_search_bloc.dart';

class AddressScreen extends StatefulWidget {
  final AddressSearchBloc bloc;
  final HomeBloc home_bloc;
  final bool arg;

  const AddressScreen({
    Key? key,
    required this.bloc,
    required this.home_bloc,
    required this.arg,
  }) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final homeController = TextEditingController();
  final workController = TextEditingController();
  final searchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  List<String> _suggestions = [];
  bool? isAddress = false;
  var isLoading = false;
  late UserModel user;

  @override
  void initState() {
    super.initState();
    try {
      final userJson = getX<AppPreference>().getString(AppKey.userData);
      if (userJson != null && userJson.isNotEmpty) {
        final map = jsonDecode(userJson);
        user = UserModel.fromMap(map);
        isAddress = user.isAddress ?? false;
      } else {
        user = UserModel.empty();
        isAddress = false;
      }
    } catch (e) {
      print('Error loading user data in address form: $e');
      user = UserModel.empty();
      isAddress = false;
    }

    if(widget.arg == true && isAddress!){
      homeController.text = user.homeAddress.toString();
      workController.text = user.officeAddress.toString();
    }

  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddressSearchBloc>.value(value: widget.bloc),
        BlocProvider<HomeBloc>.value(value: widget.home_bloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddressSearchBloc, AddressSearchState>(
            listener: (context, state) async {
              if (state is AddressLoaded) {
                setState(() {
                  _suggestions = state.suggestions;
                });
              } else if (state is AddressError) {
                print("message : ${state.message}");
              }
            },
          ),
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) async {
              if (state is HomeLoading) {
                setState(() {
                  isLoading = true;
                });
              } else if (state is HomeLoaded) {
                await getX<AppPreference>().setString(
                  AppKey.userData,
                  state.userData.toJson(),
                );
                setState(() {
                  isLoading = false;
                  isAddress = state.userData.isAddress;
                  user = state.userData;
                });
              } else if (state is HomeError) {
                setState(() {
                  isLoading = false;
                });
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ],
        child: buildCustomScaffold(),
      ),
    );
  }

  CustomScaffold buildCustomScaffold() {
    return CustomScaffold(
      appbar: widget.arg ,
      backpress: widget.arg ,
      profile: true,
      body: Visibility(
        visible:widget.arg == false? !isAddress!:true,
        child: Column(
          children: [

            Visibility(
              visible: widget.arg== true ? false : true,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Welcome to Chalo Saath!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            Container(
              height: 280,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/login_bac.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TypeAheadField<String>(
                        controller: homeController,
                        suggestionsCallback: (pattern) {
                          widget.bloc.add(FetchAddressSuggestions(pattern));
                          return _suggestions;
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(title: Text(suggestion));
                        },
                        onSelected: (suggestion) {
                          homeController.text = suggestion;
                        },
                        builder: (context, controller, focusNode) {
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              hintText: "Enter home address",
                              prefixIcon: Icon(Icons.location_on),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter home address';
                              }
                              return null;
                            },
                          );
                        },
                      ),

                      SizedBox(height: 16),
                      TypeAheadField<String>(
                        controller: workController,
                        suggestionsCallback: (pattern) {
                          widget.bloc.add(FetchAddressSuggestions(pattern));
                          return _suggestions;
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(title: Text(suggestion));
                        },
                        onSelected: (suggestion) {
                          workController.text = suggestion;
                        },

                        builder: (context, controller, focusNode) {
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              hintText: "Work Address",
                              prefixIcon: Icon(Icons.location_on),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter work address';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              user = user.copyWith(
                                isAddress: true,
                                isRegister: true,
                                homeAddress: homeController.text,
                                officeAddress: workController.text,
                              );

                              widget.home_bloc.add(SaveUserAddress(user));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            "Save and Continue",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 16,
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
          ],
        ),
      ),
    );
  }
}
