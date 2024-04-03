import 'package:footballer/models/status.dart';
import 'package:footballer/models/venue.dart';

class Fixture {
  int id;
  String date;
  dynamic timestamp;
  String referee;
  Status status;
  Venue venue;
  Fixture(this.id, this.date, this.timestamp, this.referee, this.status, this.venue);

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
        json['id'],
        json['date'],
        json['timestamp'],
        json['referee'],
        Status.fromJson(json['status']),
        Venue.fromJson(json['venue'])
    );
  }
}
