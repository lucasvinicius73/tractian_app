import 'package:flutter/material.dart';
import 'package:tractian_app/models/asset_model.dart';
import 'package:tractian_app/models/companie_model.dart';
import 'package:tractian_app/models/model.dart';
import 'package:tractian_app/models/node_model.dart';
import 'package:tractian_app/shared/service.dart';

class AssetsController extends ChangeNotifier {
  List<Companie> companies = [];
  List<Model> locations = [];
  List<AssetModel> assets = [];
  List<Node<Model>> roots = [];
  List<Node<Model>> subLocations = [];
  Node<Model> root = Node<Model>(Model(id: "id", name: "name"));
  Node<Model> nodeAux = Node<Model>(Model(id: "id", name: "fake"));

  final service = ServiceJson();

  getCompanies() async {
    companies = await service.fetchCompaniesJson();
    notifyListeners();
  }

  disposer() {
    root.children.clear();
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
    root = Node(Model(id: 'eae', name: companie.name));
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
    root.children.addAll(roots);
    notifyListeners();
  }

  buildNodes() {
    for (var subLocation in subLocations) {
      Node<Model>? node = getNode(root, subLocation.data.parentId!);
      if (node == null) {
        continue;
      }
      node.children.add(subLocation);
    }
    int i = 0;
    // assets.forEach(
    //     (asset) => print("Nome: ${asset.name} e SensorID: ${asset.sensorId}"));
    while (assets.isNotEmpty) {
      if (i == assets.length) {
        i = 0;
      }
      print(
          "O Item ${assets[i]} indice $i entrou na filtragem de ${assets.length} itens");

      if (assets[i].locationId == null && assets[i].parentId == null) {
        print("Asset que foi pra raiz: ${assets[i].name}");
        root.children.add(Node<AssetModel>(assets[i]));
        assets.remove(assets[i]);
        continue;
      }

      if (assets[i].locationId != null && assets[i].sensorId == null) {
        Node<Model>? locationNode = getNode(root, assets[i].locationId!);
        if (locationNode == null) {
          i++;
          continue;
        }
        print(
            "O Asset ${assets[i].name} é filho do Local ${locationNode.data.name}");
        locationNode.children.add(Node<Model>(assets[i]));
        assets.remove(assets[i]);
        continue;
      }

      if (assets[i].parentId != null && assets[i].sensorId == null) {
        Node<Model>? node = getNode(root, assets[i].parentId!);
        if (node == null) {
          i++;
          continue;
        }
        print("O Asset ${assets[i].name} é filho do Asset ${node.data.name}");
        node.children.add(Node<AssetModel>(assets[i]));
        assets.remove(assets[i]);
        continue;
      }

      if (assets[i].sensorType != null) {
        if (assets[i].locationId != null) {
          Node<Model>? node = getNode(root, assets[i].locationId!);
          if (node == null) {
            i++;
            continue;
          }
          print(
              "O Componente ${assets[i].name} é filho do Local ${node.data.name}");
          node.children.add(Node<Model>(assets[i]));
          assets.remove(assets[i]);
          continue;
        }

        if (assets[i].parentId != null) {
          print("O componente ${assets[i]} entrou no filtro do Filho de Asset");

          Node<Model>? node = getNode(root, assets[i].parentId!);
          if (node == null) {
            i++;
            continue;
          }
          print(
              "O Componente ${assets[i].name} é filho do Asset ${node.data.name}");
          node.children.add(Node<AssetModel>(assets[i]));
          assets.remove(assets[i]);
          continue;
        }
      }
    }

    notifyListeners();
  }

  Node<Model>? getNode(Node<Model> node, String nodeId) {
    for (var child in node.children) {
      if (child.data.id == nodeId) {
        return child;
      }
      if (child.data.id != nodeId && child.children.isNotEmpty) {
        var foundNode = getNode(child, nodeId);
        if (foundNode != null) {
          return foundNode;
        }
      }
    }
    return null;
  }

  searchNode(String nodeName) {
    List<Node<Model>> path = [];

    bool findPathRecursive(Node<Model> node) {
      path.add(node);
      if (node.data.toString() == nodeName) {
        return true;
      }
      for (var child in node.children) {
        if (findPathRecursive(child)) {
          return true;
        }
      }
      path.removeLast();
      return false;
    }

    findPathRecursive(root);
    return path;
  }
}
