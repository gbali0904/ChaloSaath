import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/storage/app_key.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/service_locator.dart';
import '../../address/data/AddressSearchEvent.dart';
import '../../address/data/AddressSearchState.dart';
import '../../address/presentation/AddressSearchBloc.dart';
import '../../authorization/data/user_model.dart';
import '../../helper/CustomScaffold.dart';
class HomeScreen extends StatefulWidget {
  AddressSearchBloc bloc;
  HomeScreen({super.key, required this.bloc});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = TextEditingController();
  final workController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  List<String> _suggestions = [];

  bool? isAddress= false;

  @override
  void initState() {
    super.initState();

    final userJson =getX<AppPreference>().getString(AppKey.userData);
    final map = jsonDecode(userJson);
    var user= UserModel.fromMap(map);
    isAddress = user.isAddress ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => widget.bloc,
      child: BlocListener<AddressSearchBloc, AddressSearchState>(
        listener: (context, state) async {
          if (state is AddressLoaded) {
            setState(() {
              _suggestions = state.suggestions;
            });
          } else if (state is AddressError) {
            print("message : ${state.message}");
          }
        },
        child: buildCustomScaffold(),
      ),
    );
  }

  CustomScaffold buildCustomScaffold() {
    return CustomScaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
           // 🔍 Search Bar
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
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Welcome to Chalo Saath!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 24),
          Visibility(
            visible: !isAddress!,
            child: Container(
              height: 250,
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
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSelected: (suggestion) {
                          homeController.text = suggestion;
                        },
                        builder: (context, controller, focusNode) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              hintText:  "Enter home address",
                              prefixIcon: Icon(Icons.location_on),
                            ),
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
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSelected: (suggestion) {
                          workController.text = suggestion;
                        },

                        builder: (context, controller, focusNode) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              hintText:  "Work Address",
                              prefixIcon: Icon(Icons.location_on),
                            ),
                          );
                        },
                      ),


                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (){


                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text("Save and Continue",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  }


  Future<List<String>> getSuggestions(String query) async {
    // Replace this with LocationIQ API call
    await Future.delayed(Duration(milliseconds: 300));
    List<String> dummyAddresses = [
      "Mapsko Mount Ville, Gurgaon",
      "Cyber Hub, Gurgaon",
      "DLF Phase 2, Gurgaon",
      "Sohna Road, Gurgaon"
    ];
    return dummyAddresses
        .where((address) =>
        address.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
