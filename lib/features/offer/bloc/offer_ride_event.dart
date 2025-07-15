import 'package:flutter/material.dart';

abstract class OfferRideEvent {}

class PickupChanged extends OfferRideEvent {
  final String pickup;
  PickupChanged(this.pickup);
}

class DestinationChanged extends OfferRideEvent {
  final String destination;
  DestinationChanged(this.destination);
}

class DateChanged extends OfferRideEvent {
  final DateTime date;
  DateChanged(this.date);
}

class TimeChanged extends OfferRideEvent {
  final TimeOfDay time;
  TimeChanged(this.time);
}

class RecurringChanged extends OfferRideEvent {
  final bool recurring;
  RecurringChanged(this.recurring);
}

class SeatsChanged extends OfferRideEvent {
  final int seats;
  SeatsChanged(this.seats);
}

class FareChanged extends OfferRideEvent {
  final String fare;
  FareChanged(this.fare);
}

class NotesChanged extends OfferRideEvent {
  final String notes;
  NotesChanged(this.notes);
}

class SubmitOfferRide extends OfferRideEvent {} 