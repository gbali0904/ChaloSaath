import '../../authorization/data/user_model.dart';

class Ride {
  final String id;
  final String pickup;
  final String destination;
  final String fare;
  final String date;
  final String time;
  final bool recurring;
  final int seats;
  final String notes;
  final String userEmail;
  final UserModel? rider; // 🔥 Add this

  Ride({
    required this.id,
    required this.pickup,
    required this.destination,
    required this.fare,
    required this.date,
    required this.time,
    required this.recurring,
    required this.seats,
    required this.notes,
    required this.userEmail,
    this.rider,
  });

  factory Ride.fromMap(String id, Map<String, dynamic> data) {
    return Ride(
      id: id,
      pickup: data['pickup'] ?? '',
      destination: data['destination'] ?? '',
      fare: data['fare'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      recurring: data['recurring'] ?? false,
      seats: data['seats'] ?? 0,
      notes: data['notes'] ?? '',
      userEmail: data['userEmail'] ?? '',
    );
  }

  Ride copyWithRider(UserModel rider) {
    return Ride(
      id: id,
      pickup: pickup,
      destination: destination,
      fare: fare,
      date: date,
      time: time,
      recurring: recurring,
      seats: seats,
      notes: notes,
      userEmail: userEmail,
      rider: rider,
    );
  }
}
