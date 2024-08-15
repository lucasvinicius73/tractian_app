import 'package:tractian_app/models/model.dart';

class Companie extends Model {
  Companie() : super(id: '', name: '');

  Companie.fromJson(Map json)
      : super(id: json['id'], name: json['name'], parentId: json['parentId']);

  @override
  String toString() {
    return name;
  }
}
