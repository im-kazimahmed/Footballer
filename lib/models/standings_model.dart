import 'package:flutter/material.dart';

class StandingsModel {
  final String teamName;
  final String teamLogoUrl;
  final dynamic rank;
  final int played;
  final int wins;
  final int points;

  StandingsModel({
    @required this.teamName,
    @required this.teamLogoUrl,
    @required this.rank,
    @required this.played,
    @required this.wins,
    @required this.points,
  });

  factory StandingsModel.fromJson(Map<String, dynamic> json) {
    return StandingsModel(
      teamName: json['team']['name'],
      teamLogoUrl: json['team']['logo'],
      rank: json['rank'],
      played: json['all']['played'],
      wins: json['all']['win'],
      points: json['points'],
    );
  }

}