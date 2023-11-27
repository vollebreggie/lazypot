import 'package:mobile_lazy_pot/dtos/lazypot_connection_dto.dart';
import 'package:mobile_lazy_pot/dtos/lazypot_measurement_dto.dart';

class LazyPotDashboardThumbnailDTO {
  LazyPotConnectionDTO lazyPot;
  LazyPotMeasurementDTO lastMeasurement;

  LazyPotDashboardThumbnailDTO(this.lazyPot, this.lastMeasurement);

  factory LazyPotDashboardThumbnailDTO.fromJson(dynamic json) {
    return LazyPotDashboardThumbnailDTO(LazyPotConnectionDTO.fromJson(json['lazyPot']),
        json['lastMeasurement'] != null ? LazyPotMeasurementDTO.fromJson(json['lastMeasurement']) : LazyPotMeasurementDTO(0, 0, 0, DateTime.now()));
  }

  @override
  String toString() {
    return '{ ${lazyPot.toString()}, ${lastMeasurement.toString()} }';
  }
}
