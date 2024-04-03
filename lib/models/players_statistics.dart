import 'package:footballer/models/player_model.dart';
import 'package:footballer/models/statistic.dart';

class PlayersStatistics {
  PlayerModel player;
  dynamic offSides;
  dynamic goalsTotal;
  dynamic goalsConceded;
  dynamic goalsAssists;
  dynamic goalsSaves;
  dynamic cardsYellow;
  dynamic cardsRed;
  dynamic penaltyWon;
  dynamic penaltyCommitted;
  dynamic penaltyScored;
  dynamic penaltyMissed;
  dynamic penaltySaved;


  // PlayersStatistics(this.player);
  PlayersStatistics(
      this.player,
      this.offSides,
      this.goalsTotal,
      this.goalsConceded,
      this.goalsAssists,
      this.goalsSaves,
      this.cardsYellow,
      this.cardsRed,
      this.penaltyWon,
      this.penaltyCommitted,
      this.penaltyScored,
      this.penaltyMissed,
      this.penaltySaved,
  );

  factory PlayersStatistics.fromJson(Map<String, dynamic> json) {
    return PlayersStatistics(
        PlayerModel.fromJson(json['player']),
        json['statistics'][0]['offsides'],
        json['statistics'][0]['goals']['total'],
        json['statistics'][0]['goals']['conceded'],
        json['statistics'][0]['goals']['assists'],
        json['statistics'][0]['goals']['saves'],
        json['statistics'][0]['cards']['yellow'],
        json['statistics'][0]['cards']['red'],
        json['statistics'][0]['penalty']['won'],
        json['statistics'][0]['penalty']['commited'],
        json['statistics'][0]['penalty']['scored'],
        json['statistics'][0]['penalty']['missed'],
        json['statistics'][0]['penalty']['saved'],
    );
  }

  @override
  String toString() {
    // return "{player: $player}";
    return "{player: $player, offSides: $offSides, goalsTotal: $goalsTotal, goalsConceded: $goalsConceded, goalsAssists: $goalsAssists, goalsSaves: $goalsSaves, cardsYellow: $cardsYellow, cardsRed: $cardsRed, penaltyWon: $penaltyWon, penaltyCommitted: $penaltyCommitted, penaltyScored: $penaltyScored, penaltyMissed: $penaltyMissed, penaltySaved: $penaltySaved, }";
  }
}
