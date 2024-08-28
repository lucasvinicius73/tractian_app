import 'package:flutter/material.dart';
import 'package:tractian_app/models/asset_model.dart';
import 'package:tractian_app/models/companie_model.dart';
import 'package:tractian_app/models/location_model.dart';
import 'package:tractian_app/models/model.dart';
import 'package:tractian_app/models/node_model.dart';
import 'package:tractian_app/shared/service.dart';

class AssetsController2 extends ChangeNotifier {
  List<Companie> companies = [];
  List<LocationModel> locations = [];
  List<AssetModel> assets = [];
  Map<String, Node> nodeIdMap = {};
  final service = ServiceJson();
  Map<String, Node<Model>> searchResult = {};

  Node<Model> root = Node(Model(id: "", name: ""));

  getCompanies() async {
    companies = await service.fetchCompaniesJson();
    notifyListeners();
  }

  getLocations(Companie companie) async {
    locations = await service.fetchLocationsJson(companie.id);
    notifyListeners();
  }

  getAssets(Companie companie) async {
    assets = await service.fetchAssetsJson(companie.id);
    notifyListeners();
  }

  fetchAll(Companie companie) async {
    await getLocations(companie);
    await getAssets(companie);
    await createHashTable();
    await buildNodes();
    await buildRoot(companie);
  }

  createHashTable() {
    for (var location in locations) {
      Node<Model> locationNode = Node(location);
      nodeIdMap[locationNode.data.id] = locationNode;
    }
    for (var asset in assets) {
      Node<AssetModel> assetNode = Node(asset);
      nodeIdMap[assetNode.data.id] = assetNode;
    }
  }

  buildNodes() {
    for (var node in nodeIdMap.values) {
      if (node is! Node<AssetModel>) {
        if (node.data.parentId != null) {
          nodeIdMap[node.data.parentId!]!.children.add(node);
        }
      }
      if (node is Node<AssetModel>) {
        if (node.data.parentId == null && node.data.locationId == null) {
          root.children.add(node);
        }

        if (node.data.parentId != null) {
          nodeIdMap[node.data.parentId!]!.children.add(node);
        } else if (node.data.locationId != null) {
          Node<Model> father = nodeIdMap[node.data.locationId!]! as Node<Model>;
          father.children.add(node);
        }
      }
    }
    notifyListeners();
  }

  buildRoot(Companie companie) {
    root.data.name = "Companie ${companie.name}";
    int i = -1;
    for (var location in locations) {
      if (location.parentId == null) {
        i++;
        Node<Model> locationModel = nodeIdMap[location.id]! as Node<Model>;
        print("Local com ${locationModel.children.length} filhos");
        if (locationModel.children.isNotEmpty) {
          root.children.insert(0, locationModel);
        } else {
          root.children.insert(i, locationModel);
        }
      }
    }

    print("Root com ${root.children.length}");
    notifyListeners();
  }

  filterStatusNodes(String status) {
    searchResult.clear();
    Map<String, Model> aux = {};
    for (var asset in assets) {
      if (asset.status == status) {
        if (asset.parentId != null) {
          aux[asset.parentId!] = asset;
        } else if (asset.locationId != null) {
          aux[asset.locationId!] = asset;
        }
      }
    }
    for (var element in aux.values) {
      Node<Model>? father = nodeIdMap[element.parentId]! as Node<Model>?;
    }

    print("Filtro encontrado com ${searchResult.length} itens");
    notifyListeners();
  }

  findFatherAndRemoveBrothers(Node<Model> nodeSon) {
    if (nodeSon.data.parentId != null) {
      Node<Model>? father = nodeIdMap[nodeSon.data.parentId] as Node<Model>?;
    }
  }
}
