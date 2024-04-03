import 'package:flutter/material.dart';

class HeadToHeadModel {
  final int fixtureId;
  final DateTime date;
  final int homeTeamId;
  final String homeTeamName;
  final String homeTeamLogoUrl;
  final bool homeTeamWinner;
  final int awayTeamId;
  final String awayTeamName;
  final String awayTeamLogoUrl;
  final bool awayTeamWinner;
  final int homeTeamGoals;
  final int awayTeamGoals;
  final int homeTeamHalftimeGoals;
  final int awayTeamHalftimeGoals;
  final int homeTeamExtraTimeGoals;
  final int awayTeamExtraTimeGoals;
  final int homeTeamPenaltyGoals;
  final int awayTeamPenaltyGoals;
  final String referee;
  final String timezone;
  final String leagueName;
  final String leagueCountry;
  final String leagueLogoUrl;
  final String leagueFlagUrl;
  final int leagueSeason;
  final String leagueRound;
  final String venueName;
  final String venueCity;

  HeadToHeadModel({
    @required this.fixtureId,
    @required this.date,
    @required this.homeTeamId,
    @required this.homeTeamName,
    @required this.homeTeamLogoUrl,
    @required this.homeTeamWinner,
    @required this.awayTeamId,
    @required this.awayTeamName,
    @required this.awayTeamLogoUrl,
    @required this.awayTeamWinner,
    @required this.homeTeamGoals,
    @required this.awayTeamGoals,
    @required this.homeTeamHalftimeGoals,
    @required this.awayTeamHalftimeGoals,
    @required this.homeTeamExtraTimeGoals,
    @required this.awayTeamExtraTimeGoals,
    @required this.homeTeamPenaltyGoals,
    @required this.awayTeamPenaltyGoals,
    @required this.referee,
    @required this.timezone,
    @required this.leagueName,
    @required this.leagueCountry,
    @required this.leagueLogoUrl,
    @required this.leagueFlagUrl,
    @required this.leagueSeason,
    @required this.leagueRound,
    @required this.venueName,
    @required this.venueCity,
  });

  factory HeadToHeadModel.fromJson(Map<String, dynamic> json) {
    return HeadToHeadModel(
      fixtureId: json['fixture']['id'],
      date: DateTime.parse(json['fixture']['date']),
      homeTeamId: json['teams']['home']['id'],
      homeTeamName: json['teams']['home']['name'],
      homeTeamLogoUrl: json['teams']['home']['logo'],
      homeTeamWinner: json['teams']['home']['winner'],
      awayTeamId: json['teams']['away']['id'],
      awayTeamName: json['teams']['away']['name'],
      awayTeamLogoUrl: json['teams']['away']['logo'],
      awayTeamWinner: json['teams']['away']['winner'],
      homeTeamGoals: json['goals']['home'],
      awayTeamGoals: json['goals']['away'],
      homeTeamHalftimeGoals: json['score']['halftime']['home'],
      awayTeamHalftimeGoals: json['score']['halftime']['away'],
      homeTeamExtraTimeGoals: json['score']['extratime']['home'] ?? 0,
      awayTeamExtraTimeGoals: json['score']['extratime']['away'] ?? 0,
      homeTeamPenaltyGoals: json['score']['penalty']['home'] ?? 0,
      awayTeamPenaltyGoals: json['score']['penalty']['away'] ?? 0,
      referee: json['fixture']['referee'] ?? "",
      timezone: json['fixture']['timezone'] ?? "",
      leagueName: json['league']['name'] ?? "",
      leagueCountry: json['league']['country'] ?? "",
      leagueLogoUrl: json['league']['logo'] ?? "",
      leagueFlagUrl: json['league']['flag'] ?? "",
      leagueSeason: json['league']['season'],
      leagueRound: json['league']['round'] ?? "",
      venueName: json['fixture']['venue']['name'] ?? "",
      venueCity: json['fixture']['venue']['city'] ?? "",
    );
  }

}