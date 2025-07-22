import 'package:chalosaath/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../address/presentation/address_search_bloc.dart';
import '../../address/data/AddressSearchEvent.dart';
import '../../address/data/AddressSearchState.dart';
import '../../helper/custome_bottom_nav_bar.dart';
import '../bloc/offer_ride_bloc.dart';
import '../bloc/offer_ride_event.dart';
import '../bloc/offer_ride_state.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class OfferRideScreen extends StatefulWidget {
  final AddressSearchBloc addressBloc;
  final OfferRideBloc offerRideBloc;
  final bool showAppBar;
  final bool showBottomBar;
  final bool showtitle;

  const OfferRideScreen({
    super.key,
    required this.addressBloc,
    required this.offerRideBloc,
    this.showAppBar = false,
    this.showBottomBar = true,
    this.showtitle = true,
  });

  @override
  State<OfferRideScreen> createState() => _OfferRideScreenState();
}

class _OfferRideScreenState extends State<OfferRideScreen> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  List<String> _suggestions = [];
  String currentField = '';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddressSearchBloc>.value(value: widget.addressBloc),
        BlocProvider<OfferRideBloc>.value(value: widget.offerRideBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddressSearchBloc, AddressSearchState>(
            listener: (context, state) {
              if (state is AddressLoaded) {
                setState(() {
                  _suggestions = state.suggestions;
                });
              }
            },
          ),
          BlocListener<OfferRideBloc, OfferRideState>(
            listener: (context, state) {
              if (state.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ride published successfully!')),
                );
                // Clear form fields after successful publish
                pickupController.clear();
                destinationController.clear();
                context.read<OfferRideBloc>().add(ResetOfferRideForm());
              } else if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error!)),
                );
              }
            },
          ),
        ],
        child: CustomBottomNavBar(
          context:context,
          appbarstatus: widget.showAppBar,
          title: widget.showtitle ? "Offer a Ride" : "",
          showBottomBar: widget.showBottomBar,
          body: BlocBuilder<OfferRideBloc, OfferRideState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Route Details
                    _SectionTitle(icon: Icons.route, title: 'Route Details'),
                    const SizedBox(height: 8),
                    _AddressField(
                      label: 'Pickup Point',
                      hint: 'Enter pickup location',
                      controller: pickupController,
                      suggestions: _suggestions,
                      onChanged: (val) {
                        context.read<OfferRideBloc>().add(PickupChanged(val));
                      },
                      onSearch: (pattern) {
                        currentField = 'pickup';
                        widget.addressBloc.add(FetchAddressSuggestions(pattern));
                      },
                    ),
                    const SizedBox(height: 12),
                    _AddressField(
                      label: 'Destination',
                      hint: 'Where are you going?',
                      controller: destinationController,
                      suggestions: _suggestions,
                      onChanged: (val) {
                        context.read<OfferRideBloc>().add(DestinationChanged(val));
                      },
                      onSearch: (pattern) {
                        currentField = 'destination';
                        widget.addressBloc.add(FetchAddressSuggestions(pattern));
                      },
                    ),
                    const SizedBox(height: 24),
                    // When are you leaving?
                    _SectionTitle(icon: Icons.access_time, title: 'When are you leaving?'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _DateField(
                            date: state.date,
                            onChanged: (date) => context.read<OfferRideBloc>().add(DateChanged(date)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _TimeField(
                            time: state.time,
                            onChanged: (time) => context.read<OfferRideBloc>().add(TimeChanged(time)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Switch(
                          value: state.recurring,
                          onChanged: (val) => context.read<OfferRideBloc>().add(RecurringChanged(val)),
                        ),
                        const Text('Make this a recurring ride'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Ride Details
                    _SectionTitle(icon: Icons.event_seat, title: 'Ride Details'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _SeatsDropdown(
                            value: state.seats,
                            onChanged: (val) => context.read<OfferRideBloc>().add(SeatsChanged(val ?? 1)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _FareField(
                            value: state.fare,
                            onChanged: (val) => context.read<OfferRideBloc>().add(FareChanged(val)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Additional Notes (Optional)',
                        hintText: 'Any specific pickup instructions, preferences, etc.',
                        border: OutlineInputBorder(),
                      ),
                      minLines: 2,
                      maxLines: 3,
                      onChanged: (val) => context.read<OfferRideBloc>().add(NotesChanged(val)),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () => context.read<OfferRideBloc>().add(SubmitOfferRide()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: state.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Publish Ride', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.black, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}

class _AddressField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final List<String> suggestions;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSearch;
  const _AddressField({required this.label, required this.hint, required this.controller, required this.suggestions, required this.onChanged, required this.onSearch});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        TypeAheadField<String>(
          controller: controller,
          suggestionsCallback: (pattern) {
            onSearch(pattern);
            return suggestions;
          },
          itemBuilder: (context, suggestion) {
            return ListTile(title: Text(suggestion));
          },
          onSelected: (suggestion) {
            controller.text = suggestion;
            onChanged(suggestion);
          },
          builder: (context, textController, focusNode) {
            return TextFormField(
              controller: textController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hint,
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.location_on_outlined),
              ),
              onChanged: onChanged,
            );
          },
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  final DateTime? date;
  final ValueChanged<DateTime> onChanged;
  const _DateField({required this.date, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: date != null ? "${date!.day}/${date!.month}/${date!.year}" : ''),
      decoration: const InputDecoration(
        labelText: 'Date',
        hintText: 'dd/mm/yyyy',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onChanged(picked);
      },
    );
  }
}

class _TimeField extends StatelessWidget {
  final TimeOfDay? time;
  final ValueChanged<TimeOfDay> onChanged;
  const _TimeField({required this.time, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: time != null ? time!.format(context) : ''),
      decoration: const InputDecoration(
        labelText: 'Time',
        hintText: '--:--',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.access_time),
      ),
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
        );
        if (picked != null) onChanged(picked);
      },
    );
  }
}

class _SeatsDropdown extends StatelessWidget {
  final int value;
  final ValueChanged<int?> onChanged;
  const _SeatsDropdown({required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: const InputDecoration(
        labelText: 'Available Seats',
        border: OutlineInputBorder(),
      ),
      items: List.generate(6, (i) => i + 1)
          .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _FareField extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _FareField({required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Suggested Fare',
        prefixText: '₹ ',
        border: OutlineInputBorder(),
      ),
      controller: TextEditingController(text: value),
      onChanged: onChanged,
    );
  }
} 