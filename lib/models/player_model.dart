class PlayerModel {
  int id;
  String name;
  String photo;

  PlayerModel(this.id, this.name, this.photo);

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(json['id'], json['name'], json['photo']);
  }

  @override
  String toString() {
    return "{id: $id, name: $name}, photo: $photo}, ";
  }
}
