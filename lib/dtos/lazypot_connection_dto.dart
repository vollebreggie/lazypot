class LazyPotConnectionDTO {
  int id, waterLevelMode;
  String ssid, name;
  DateTime created;

  LazyPotConnectionDTO(this.id, this.ssid, this.created, this.name, this.waterLevelMode);

  factory LazyPotConnectionDTO.fromJson(dynamic json) {
    return LazyPotConnectionDTO(json['id'], json['ssid'] as String, DateTime.parse(json['created']), json['name'] as String, json['waterLevelMode']);
  }

  @override
  String toString() {
    return '{ $ssid, $created }';
  }
}
