import 'package:footballer/models/player_model.dart';
import 'package:footballer/models/statistic.dart';
import 'package:footballer/models/substitutes_model.dart';
import 'package:footballer/models/team.dart';

class LineUpsModel {
  // Team team;
  SubstitutesModel substitutes;

  // LineUpsModel(this.team, this.substitutes);
  LineUpsModel(this.substitutes);

  factory LineUpsModel.fromJson(Map<String, dynamic> json) {
    return LineUpsModel(
        json['substitutes'],
    );
  }

  @override
  String toString() {
    // return "{team: $team, substitutes: $substitutes}";
    return "{substitutes: $substitutes}";
  }
}
