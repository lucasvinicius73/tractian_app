class Model {
  final String id;
  String name;
  final String? parentId;
  final String? locationId;

  Model({required this.id, required this.name, this.parentId, this.locationId});

  @override
  String toString() {
    return name;
  }
}
