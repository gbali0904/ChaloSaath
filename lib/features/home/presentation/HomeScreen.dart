import 'dart:convert';

import 'package:chalosaath/features/address/presentation/AddressForm.dart';
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
  final searchController = TextEditingController();

  bool? isAddress = false;

  var isLoading = false;

  late UserModel user;

  List<UserModel> data = [];

  List<UserModel> filteredData = [];

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
                  filteredData = data;
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
            child:!isAddress! ?
            AddressScreen(bloc: widget.bloc ,home_bloc:widget.home_bloc,arg:false
            ): Column(
              children: [
                Visibility(
                  visible: isAddress!,
                  child: TextField(
                    controller: searchController,
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
                    onChanged: (value) {
                      final query = value.toLowerCase();
                      setState(() {
                        if (query != "") {
                          filteredData = data.where((user) {
                            return user.fullName.toLowerCase().contains(
                                  query,
                                ) ||
                                (user.carNumber?.toLowerCase().contains(
                                      query,
                                    ) ??
                                    false) ||
                                (user.homeAddress?.toLowerCase().contains(
                                      query,
                                    ) ??
                                    false) ||
                                (user.officeAddress?.toLowerCase().contains(
                                      query,
                                    ) ??
                                    false);
                          }).toList();
                        } else {
                          filteredData = data;
                        }
                      });
                    },
                  ),
                ),

                SizedBox(height: 20),
                Visibility(
                  visible: isAddress!,
                  child: Expanded(
                    child: filteredData.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final user_data = filteredData[index];
                              return Card(
                                elevation: 3,
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          // Circular Image
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage: AssetImage(
                                              "assets/profile_user.png",
                                            ),
                                            backgroundColor:
                                                Colors.grey.shade200,
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
                                                      Text(
                                                        'Car Number: ${user_data.carNumber}',
                                                      ),
                                                      SizedBox(width: 6),
                                                      Icon(
                                                        user_data.isCarVerified ==
                                                                true
                                                            ? Icons.check_circle
                                                            : Icons.cancel,
                                                        color:
                                                            user_data
                                                                    .isCarVerified ==
                                                                true
                                                            ? Colors.green
                                                            : Colors.red,
                                                        size: 18,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Home: ${user_data.homeAddress}',
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Office: ${user_data.officeAddress}',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.call,
                                              color: Colors.green,
                                            ),
                                            onPressed: () async {
                                              final phoneNumber = user_data
                                                  .phone; // e.g. "1234567890"
                                              final Uri phoneUri = Uri(
                                                scheme: 'tel',
                                                path: phoneNumber,
                                              );
                                              if (await canLaunchUrl(
                                                phoneUri,
                                              )) {
                                                await launchUrl(phoneUri);
                                              } else {
                                                print(
                                                  'Could not launch dialer',
                                                );
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
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
                          )
                        : Center(child: Text("No Data Found ")),
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
