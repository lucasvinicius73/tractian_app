import 'package:tractian_app/models/model.dart';

class AssetModel extends Model {
  final String? sensorId;
  final String? sensorType;
  final String? status;
  final String? gatewayId;

  AssetModel({
    required this.sensorId,
    required this.sensorType,
    required this.status,
    required this.gatewayId,
  }) : super(id: '', name: '');

  AssetModel.fromJson(Map json)
      : sensorId = json['sensorId'],
        sensorType = json['sensorType'],
        status = json['status'],
        gatewayId = json['gatewayId'],
        super(
            id: json['id'],
            name: json['name'],
            parentId: json['parentId'],
            locationId: json['locationId']);

  @override
  String toString() {
    return name;
  }
}
