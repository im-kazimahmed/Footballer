import 'package:footballer/models/team.dart';
import 'package:footballer/models/venue.dart';

class TeamInfo {
  Team team;
  Venue venue;

  TeamInfo(this.team, this.venue);

  factory TeamInfo.fromJson(Map<String, dynamic> json) =>
      TeamInfo(Team.fromJson(json['team']), Venue.fromJson(json['venue']));
}
