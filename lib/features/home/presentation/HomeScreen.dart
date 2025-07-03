import 'dart:convert';

import 'package:chalosaath/features/home/data/HomeState.dart';
import 'package:chalosaath/features/home/presentation/HomeBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/storage/app_key.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/service_locator.dart';
import '../../address/data/AddressSearchEvent.dart';
import '../../address/data/AddressSearchState.dart';
import '../../address/presentation/AddressSearchBloc.dart';
import '../../authorization/data/user_model.dart';
import '../../helper/CustomScaffold.dart';
import '../../loader/CustomLoader.dart';
import '../data/HomeEvent.dart';

class HomeScreen extends StatefulWidget {
  AddressSearchBloc bloc;
  HomeBloc home_bloc;

  HomeScreen({super.key, required this.bloc, required this.home_bloc});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = TextEditingController();
  final workController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  List<String> _suggestions = [];

  bool? isAddress = false;

  var isLoading = false;

  late UserModel user;

  List<UserModel> data = [];

  @override
  void initState() {
    super.initState();
    final userJson = getX<AppPreference>().getString(AppKey.userData);
    final map = jsonDecode(userJson);
    user = UserModel.fromMap(map);
    isAddress = user.isAddress ?? false;
    widget.home_bloc.add(GetUserList(user.role));
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
                  jsonEncode(state.userData),
                );
                setState(() {
                  isLoading = false;
                  isAddress = state.userData.isAddress;
                  user = state.userData;
                });
              } else if (state is UserDataSuccess) {
                setState(() {
                  isLoading = false;
                  data = state.userData;
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Visibility(
                  visible: isAddress!,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Ride or Location...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !isAddress!,
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          'Welcome to Chalo Saath!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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
                                    widget.bloc.add(
                                      FetchAddressSuggestions(pattern),
                                    );
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
                                        if (value == null ||
                                            value.trim().isEmpty) {
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
                                    widget.bloc.add(
                                      FetchAddressSuggestions(pattern),
                                    );
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
                                        if (value == null ||
                                            value.trim().isEmpty) {
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
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        user = user.copyWith(
                                          isAddress: true,
                                          homeAddress: homeController.text,
                                          officeAddress: workController.text,
                                        );

                                        widget.home_bloc.add(
                                          SaveUserAddress(user),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
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
                SizedBox(height: 20),
                Visibility(
                  visible: isAddress!,
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final user_data = data[index];
                        return Card(
                          elevation: 3,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // Circular Image
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(
                                    "assets/profile_user.png",
                                  ),
                                  backgroundColor: Colors.grey.shade200,
                                ),
                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user_data.fullName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Visibility(
                                        visible: user.role == "Rider",
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
                                      Text('Home: ${user_data.homeAddress}'),
                                      const SizedBox(height: 10),
                                      Text('Office: ${user_data.officeAddress}'),
                                    ],
                                  ),
                                ),

                                // Icons column
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.call,
                                        color: Colors.green,
                                      ),
                                      onPressed: () async {
                                        final phoneNumber =
                                            user_data.phone; // e.g. "1234567890"
                                        final Uri phoneUri = Uri(
                                          scheme: 'tel',
                                          path: phoneNumber,
                                        );
                                        if (await canLaunchUrl(phoneUri)) {
                                          await launchUrl(phoneUri);
                                        } else {
                                          print('Could not launch dialer');
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon:  Icon(
                                        Icons.chat,
                                        color: AppColors.primary,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading == true ? CustomLoader() : Container(),
        ],
      ),
    );
  }
}
