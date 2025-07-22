import 'dart:convert';

import 'package:chalosaath/core/routes/route_constants.dart';
import 'package:chalosaath/features/home/data/home_state.dart';
import 'package:chalosaath/features/home/data/Ride.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/storage/app_key.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/service_locator.dart';
import '../../address/presentation/address_search_bloc.dart';
import '../../authorization/data/user_model.dart';
import '../../helper/custome_bottom_nav_bar.dart';
import '../data/home_event.dart';
import 'home_bloc.dart';
import '../../offer/presentation/offer_ride_screen.dart';
import '../../offer/bloc/offer_ride_bloc.dart';

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
  int selectedTab = 0;

  List<Ride> rideData = [];

  @override
  void initState() {
    super.initState();
    try {
      final userJson = getX<AppPreference>().getString(AppKey.userData);
      if (userJson != null && userJson.isNotEmpty) {
        final map = jsonDecode(userJson);
        user = UserModel.fromMap(map);
        isAddress = user.isAddress ?? false;
        // widget.home_bloc.add(GetUserList(user.role));
        widget.home_bloc.add(GetRideList());
      } else {
        user = UserModel.empty();
        isAddress = false;
      }
    } catch (e) {
      print('Error loading user data: $e');
      user = UserModel.empty();
      isAddress = false;
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
              } else if (state is UserDataSuccess) {
                setState(() {
                  isLoading = false;
                  data = state.userData;
                  filteredData = data;
                });
              } else if (state is RideDataSuccess) {
                setState(() {
                  isLoading = false;
                  rideData = state.rideData;
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
        child: _buildScaffold(),
      ),
    );
  }

  Widget _buildScaffold() {
    return CustomBottomNavBar(
      context: context,
      appbarstatus: true,
      appbar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      // Optional: hide back button
      titleSpacing: 24,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              user.homeAddress.toString().split(",").first,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteConstants.profile);
            },
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Text(
                user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '',
                style: const TextStyle(
                  color: Color(0xFF10182B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFindRideTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Where are you going card
        Visibility(
          visible: false,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.search, color: Color(0xFF8A94A6)),
                      SizedBox(width: 8),
                      Text(
                        'Where are you going?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter destination',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF8F9FB),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.access_time, size: 18),
                        label: const Text('Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF232B3B),
                          elevation: 0,
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.tune, size: 18),
                        label: const Text('Filters'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFF232B3B),
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 18),
        // Upcoming Rides
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Rides',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Visibility(
              visible: rideData.length > 5,
              child: Text(
                'View All',
                style: TextStyle(
                  color: Color(0xFF8A94A6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        rideData.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: rideData.length,
                  itemBuilder: (context, index) {
                    final ride = rideData[index];
                    return _buildRideCard(ride, index);
                  },
                ),
              )
            : Center(child: Text("No Ride Found")),
      ],
    );
  }

  Widget _buildRideCard(Ride ride, int index) {
    final isHosting = index % 2 == 0;
    final status = 'Booking';
    final additional_note = ride.notes != "" ? ride.notes :"";
    final time = ride.time;
    final route =
        "${ride.pickup.split(",").first} -> ${ride.destination.split(",").first}";
    final withWhom = ride.rider!.fullName.toString();
    final people = ride.seats;
    final price = "₹${ride.fare}";
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isHosting
                        ? const Color(0xFF1A2343)
                        : const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isHosting ? Colors.white : const Color(0xFF232B3B),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF8A94A6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.people, size: 18, color: Color(0xFF8A94A6)),
                const SizedBox(width: 4),
                Text('$people'),
                const SizedBox(width: 12),
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(withWhom, style: const TextStyle(color: Color(0xFF000000))),
            const SizedBox(height: 8),
            Text(
              route,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(additional_note ,style: const TextStyle(fontSize: 10, color: Colors.red)),
                const SizedBox(height: 4),
            Divider(),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.call, size: 40, color: AppColors.primary),
                Icon(Icons.message, size: 40, color: AppColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top tab row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = 0;
                    });
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: selectedTab == 0
                          ? Colors.white
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: selectedTab == 0
                              ? AppColors.primary
                              : const Color(0xFF8A94A6),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Find a Ride',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: selectedTab == 0
                                ? AppColors.primary
                                : const Color(0xFF8A94A6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = 1;
                    });
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: selectedTab == 1
                          ? Colors.white
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_car,
                          color: selectedTab == 1
                              ? AppColors.primary
                              : const Color(0xFF8A94A6),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Offer a Ride',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: selectedTab == 1
                                ? AppColors.primary
                                : const Color(0xFF8A94A6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Tab content
          Expanded(
            child: selectedTab == 0
                ? _buildFindRideTab()
                : OfferRideScreen(
                    addressBloc: getX<AddressSearchBloc>(),
                    offerRideBloc: getX<OfferRideBloc>(),
                    showAppBar: false,
                    showBottomBar: false,
                    showtitle: false,
                  ),
          ),
        ],
      ),
    );
  }
}
