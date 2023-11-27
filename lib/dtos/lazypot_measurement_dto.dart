class LazyPotMeasurementDTO {
  double waterLevelMeasure, batteryLevel, moistureLevelMeasure;
  DateTime created;

  LazyPotMeasurementDTO(this.waterLevelMeasure, this.batteryLevel, this.moistureLevelMeasure, this.created);

  factory LazyPotMeasurementDTO.fromJson(dynamic json) {
    return LazyPotMeasurementDTO(json['waterLevelMeasure'] / 1 as double, json['batteryLevel'] / 1 as double, json['moistureLevelMeasure'] / 1 as double,
        DateTime.parse(json['created']));
  }

  @override
  String toString() {
    return '{ $waterLevelMeasure, $batteryLevel }';
  }
}
