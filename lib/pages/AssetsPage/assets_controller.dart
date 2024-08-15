import 'package:flutter/material.dart';
import 'package:tractian_app/models/asset_model.dart';
import 'package:tractian_app/models/companie_model.dart';
import 'package:tractian_app/models/location_model.dart';
import 'package:tractian_app/models/model.dart';
import 'package:tractian_app/models/node_model.dart';
import 'package:tractian_app/shared/service.dart';

class AssetsController extends ChangeNotifier {
  List<Companie> companies = [];
  List<Model> locations = [];
  List<AssetModel> assets = [];
  List<Node<Model>> roots = [];
  List<Node<Model>> subLocations = [];
  Node<Model> first = Node<Model>(Model(id: "id", name: "name"));

  final service = ServiceJson();

  getCompanies() async {
    companies = await service.fetchCompaniesJson();
    notifyListeners();
  }

  disposer() {
    first.children.clear();
    locations.clear();
    roots.clear();
    subLocations.clear();
    assets.clear();
    //otifyListeners();
  }

  getLocations(Companie companie) async {
    locations = await service.fetchLocationsJson(companie.id);
    notifyListeners();
  }

  getAssets(String companieID) async {
    assets = await service.fetchAssetsJson(companieID);
    notifyListeners();
  }

  buildTree(Companie companie) async {
    disposer();
    await getLocations(companie);
    await getAssets(companie.id);
    await buildRoots(companie);
    await buildNodes();
    notifyListeners();
  }

  buildRoots(Companie companie) {
    for (var location in locations) {
      final Node<Model> node = Node(location);

      if (location.parentId == null) {
        roots.add(node);
      }
      if (location.parentId != null) {
        subLocations.add(node);
      }
    }
    first = Node(Model(id: '', name: companie.name));
    first.children.addAll(roots);
    notifyListeners();
  }

  buildNodes() {
    for (var subLocation in subLocations) {
      Node<Model> node = getNode(first, subLocation.data.parentId!);
      node.children.add(subLocation);
    }

    // for (var location in first.children) {
    //   location.children.addAll(subLocations.where(
    //       (subLocation) => subLocation.data.parentId == location.data.id));
    // }
    for (var i = assets.length - 1; i >= 0; i--) {
      AssetModel asset = assets[i];
      if (asset.locationId == null || asset.parentId == null) {
        print("Asset que foi pra raiz: ${asset.name}");
        first.children.add(Node<AssetModel>(asset));
        assets.remove(asset);
      }
      if (asset.locationId != null && asset.sensorId == null) {
        Node<Model> locationNode = getNode(first, asset.locationId!);
        print(
            "O Asset ${asset.name} é filho do Local ${locationNode.data.name}");
        locationNode.children.add(Node<Model>(asset));
        assets.remove(asset);
      }
      if (asset.parentId != null && asset.sensorId == null) {
        Node<Model> node = getNode(first, asset.parentId!);
        node.children.add(Node<AssetModel>(asset));
        assets.remove(asset);
      }
      if (asset.sensorType != null) {
        if (asset.locationId != null) {
          Node<Model> node = getNode(first, asset.locationId!);
          node.children.add(Node<Model>(asset));
          assets.remove(asset);
        }
        if (asset.parentId != null) {
          Node<Model> node = getNode(first, asset.parentId!);
          node.children.add(Node<AssetModel>(asset));
          assets.remove(asset);
        }
      }
    }
    notifyListeners();
  }

  Node<Model> getNode(Node<Model> node, String nodeId) {
    Node<Model> aux = Node(Model(id: "id", name: "fake"));
    for (var child in node.children) {
      if (child.data.id == nodeId) {
        aux = child;
      }
      if (child.data.id != nodeId && child.children.isNotEmpty) {
        aux = getNode(child, nodeId);
      }
    }
    return aux;
  }
}
