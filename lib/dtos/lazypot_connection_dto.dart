class LazyPotConnectionDTO {
  int id;
  String ssid, name;
  DateTime created;

  LazyPotConnectionDTO(this.id, this.ssid, this.created, this.name);

  factory LazyPotConnectionDTO.fromJson(dynamic json) {
    return LazyPotConnectionDTO(json['id'], json['ssid'] as String, DateTime.parse(json['created']), json['name'] as String);
  }

  @override
  String toString() {
    return '{ $ssid, $created }';
  }
}
