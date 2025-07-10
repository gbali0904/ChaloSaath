import 'package:chalosaath/features/helper/CustomScaffold.dart';
import 'package:chalosaath/features/profile/presentation/profile_setup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../authorization/data/user_model.dart';
import '../../../services/service_locator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../address/presentation/address_search_bloc.dart';
import '../../address/data/AddressSearchEvent.dart';
import '../../address/data/AddressSearchState.dart';

class ProfileSetupScreen extends StatefulWidget {
  ProfileSetupBloc bloc;
  String args;
  final AddressSearchBloc addressBloc;

  ProfileSetupScreen({super.key, required this.bloc, required this.args, required this.addressBloc});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final pickupController = TextEditingController();
  final dropoffController = TextEditingController();
  final vehicleController = TextEditingController();
  bool isLoading = false;
  List<String> _suggestions = [];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileSetupBloc>.value(value: widget.bloc),
        BlocProvider<AddressSearchBloc>.value(value: widget.addressBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileSetupBloc, ProfileSetupState>(
            listener: (context, state) {
              if (state is ProfileSetupLoading) {
                setState(() => isLoading = true);
              } else if (state is ProfileSetupSuccess) {
                setState(() => isLoading = false);
                Navigator.pushReplacementNamed(context, '/home');
              } else if (state is ProfileSetupFailure) {
                setState(() => isLoading = false);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<AddressSearchBloc, AddressSearchState>(
            listener: (context, state) {
              if (state is AddressLoaded) {
                setState(() {
                  _suggestions = state.suggestions;
                });
              }
            },
          ),
        ],
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
                        radius: 40,
                        backgroundColor: const Color(0xFF232B3B),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Setup Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF232B3B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tell us a bit about yourself',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF8A94A6),
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
                          hintText: 'Enter your full name',
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
                        'Pickup Location',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TypeAheadField<String>(
                        controller: pickupController,
                        suggestionsCallback: (pattern) {
                          if (pattern.isNotEmpty) {
                            widget.addressBloc.add(FetchAddressSuggestions(pattern));
                          }
                          return _suggestions;
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
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Drop-off Location',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TypeAheadField<String>(
                        controller: dropoffController,
                        suggestionsCallback: (pattern) {
                          if (pattern.isNotEmpty) {
                            widget.addressBloc.add(FetchAddressSuggestions(pattern));
                          }
                          return _suggestions;
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
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: const [
                          Text(
                            'Vehicle Details',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '(Optional)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A94A6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: vehicleController,
                        decoration: InputDecoration(
                          hintText: 'Honda City - MH01AB1234',
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
                            backgroundColor: const Color(0xFF8A94A6),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final user = UserModel(
                                fullName: fullNameController.text.trim(),
                                homeAddress: pickupController.text.trim(),
                                officeAddress: dropoffController.text.trim(),
                                carNumber: vehicleController.text.trim(),
                                isRegister: true,
                                uid: Uuid().v1(),
                                email: '',
                                phone: widget.args,
                                role: '',
                                // Add other required fields as needed
                              );
                              widget.bloc.add(ProfileSetupSubmitted(user));
                            }
                          },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
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
