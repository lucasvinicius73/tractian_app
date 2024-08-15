import 'package:tractian_app/models/model.dart';

class AssetModel extends Model {
  final String? sensorId;
  final String? sensorType;
  final String? status;
  final String? gatewayId;
  final String? locationId;

  AssetModel({
    required this.sensorId,
    required this.sensorType,
    required this.status,
    required this.gatewayId,
    required this.locationId,
  }) : super(id: '', name: '');

  AssetModel.fromJson(Map json)
      : sensorId = json['sensorId'],
        sensorType = json['sensorType'],
        status = json['status'],
        gatewayId = json['gatewayId'],
        locationId = json['locationId'],
        super(id: json['id'], name: json['name'], parentId: json['parentId']);

  @override
  String toString() {
    return name;
  }
}
