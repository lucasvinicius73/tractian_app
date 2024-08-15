import 'package:tractian_app/models/model.dart';

class LocationModel extends Model {

  LocationModel() : super(id: '', name: '');

  LocationModel.fromJson(Map json)
      : 
        super(id: json['id'], name: json['name'], parentId: json['parentId']);

  @override
  String toString() {
    return name;
  }
}
