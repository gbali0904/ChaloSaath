import 'package:flutter/material.dart';

class OfferRideState {
  final String pickup;
  final String destination;
  final DateTime? date;
  final TimeOfDay? time;
  final bool recurring;
  final int seats;
  final String fare;
  final String notes;
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  OfferRideState({
    this.pickup = '',
    this.destination = '',
    this.date,
    this.time,
    this.recurring = false,
    this.seats = 1,
    this.fare = '',
    this.notes = '',
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  OfferRideState copyWith({
    String? pickup,
    String? destination,
    DateTime? date,
    TimeOfDay? time,
    bool? recurring,
    int? seats,
    String? fare,
    String? notes,
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return OfferRideState(
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      date: date ?? this.date,
      time: time ?? this.time,
      recurring: recurring ?? this.recurring,
      seats: seats ?? this.seats,
      fare: fare ?? this.fare,
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
} 