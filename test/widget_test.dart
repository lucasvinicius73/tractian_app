// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:tractian_app/models/asset_model.dart';
import 'package:tractian_app/models/model.dart';
import 'package:tractian_app/models/node_model.dart';

void main() {
  Node<Model> nodeModel = Node(Model(id: "eae", name: "Node Model"));
  Node<AssetModel> assetModel = Node(AssetModel(
      sensorId: "sensorId",
      sensorType: "sensorType",
      status: "status",
      gatewayId: "gatewayId",
      locationId: "locationId"));

  nodeModel.children.add(assetModel);

  print(nodeModel.children);
}
