import 'package:footballer/models/player_model.dart';

class SubstitutesModel {
  int id;
  String name;
  int number;
  String pos;
  dynamic grid;

  SubstitutesModel(this.id, this.name, this.number, this.pos, this.grid);

  factory SubstitutesModel.fromJson(Map<String, dynamic> json) {
    return SubstitutesModel(
        json["player"]['id'],
        json["player"]['name'],
        json["player"]['number'],
        json["player"]['pos'],
        json["player"]['grid'],
    );
  }

  @override
  String toString() {
    return "{id: $id, name: $name, number: $number, pos: $pos, grid: $grid}";
  }
}
