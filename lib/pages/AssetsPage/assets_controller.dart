import 'package:flutter/material.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:tractian_app/models/asset_model.dart';
import 'package:tractian_app/models/companie_model.dart';
import 'package:tractian_app/models/location_model.dart';
import 'package:tractian_app/models/model.dart';
import 'package:tractian_app/models/node_model.dart';
import 'package:tractian_app/shared/service.dart';

class AssetsController extends ChangeNotifier {
  List<Companie> companies = [];
  List<LocationModel> locations = [];
  List<AssetModel> assets = [];
  Map<String, Node> nodeIdMap = {};
  final service = ServiceJson();
  Node<Model> root = Node(Model(id: "", name: ""));
  Node<Model> searchResult = Node(Model(id: "", name: "Search"));

  bool critic = false;
  bool operating = false;

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
    root.children.clear();
    disposeSearch();
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
        if (locationModel.children.isNotEmpty) {
          root.children.insert(0, locationModel);
        } else {
          root.children.insert(i, locationModel);
        }
      }
    }

    notifyListeners();
  }

  disposeSearch() {
    critic = false;
    operating = false;
    searchResult.children.clear();
    notifyListeners();
  }

  changeFilterState(String status) {
    if (status == "operating") {
      operating = !operating;
      print("Status Operating : $operating");

      if (operating == true) {
        critic = false;
        filterStatusNodes(status);
      } else {
        disposeSearch();
      }
      notifyListeners();
    } else if (status == "alert") {
      critic = !critic;
      print("Status Critic: $critic");

      if (critic == true) {
        operating = false;
        filterStatusNodes(status);
      } else {
        disposeSearch();
      }
      notifyListeners();
    }
  }

  filterStatusNodes(String status) {
    searchResult.children.clear();
    Map<String, Model> aux = {};
    for (var asset in assets) {
      if (asset.status == status) {
        if (asset.parentId == null && asset.locationId == null) {
          aux[asset.id] = asset;
        }
        if (asset.parentId != null) {
          aux[asset.parentId!] = asset;
        } else if (asset.locationId != null) {
          aux[asset.locationId!] = asset;
        }
      }
    }
    for (var element in aux.values) {
      Node<Model> son = Node(element);
      Node<Model>? father = findFatherAndRemoveBrothersFilter(son, status);
      if (father != null) {
        searchResult.children.add(father);
      }
    }

    notifyListeners();
  }

  Node<Model>? findFatherAndRemoveBrothersFilter(
      Node<Model> nodeSon, String status) {
    if (nodeSon.data.parentId == null && nodeSon.data.locationId == null) {
      return nodeSon;
    }
    if (nodeSon.data.parentId != null) {
      Node<Model>? father = nodeIdMap[nodeSon.data.parentId] as Node<Model>?;
      compareAndRemoveFilter(father!, status);

      while (father!.data.parentId != null) {
        var aux = father;
        father = nodeIdMap[father.data.parentId]! as Node<Model>?;
        father!.children.clear();
        father.children.add(aux);
      }
      Node<Model>? fatherLocal =
          findFatherAndRemoveBrothersFilter(father, status);
      if (fatherLocal == null) {
        return father;
      } else {
        var aux = findFatherAndRemoveBrothersFilter(fatherLocal, status);
        if (aux != null) {
          return aux;
        } else {
          return fatherLocal;
        }
      }
    }
    if (nodeSon.data.locationId != null) {
      var locationFather = nodeIdMap[nodeSon.data.locationId];
      locationFather!.children.clear();
      locationFather.children.add(nodeSon);

      return locationFather as Node<Model>?;
    }
    return null;
  }

  compareAndRemoveFilter(Node<Model> node, String status) {
    for (var i = node.children.length; i > node.children.length + 1; i--) {
      Node<AssetModel> childNode = node.children[i] as Node<AssetModel>;

      if (childNode.data.status == status) {
        node.children.remove(node.children[i]);
      }
    }
  }

  searchItemNode(String name) {
    disposeSearch();
    Map<String, Node<Model>> aux = {};
    Map<String, Node<Model>> resultAux = {};
    for (var node in nodeIdMap.values) {
      node as Node<Model>;
      if (node.data.name.toLowerCase().similarityTo(name.toLowerCase()) >
          0.30) {
        if (node.data.parentId == null && node.data.locationId == null) {
          aux[node.data.id] = node;
        } else if (node.data.parentId != null) {
          aux[node.data.parentId!] = node;
        } else if (node.data.locationId != null) {
          aux[node.data.locationId!] = node;
        }
      }
    }
    for (var nodeSon in aux.values) {
      Node<Model>? father = findFatherAndRemoveBrothersSearch(nodeSon, name);
      if (father != null) {
        resultAux[father.data.id] = father;
      }
    }
    searchResult.children.addAll(resultAux.values);

    notifyListeners();
  }

  findFatherAndRemoveBrothersSearch(Node<Model> nodeSon, String name) {
    if (nodeSon.data.parentId == null && nodeSon.data.locationId == null) {
      return nodeSon;
    }
    if (nodeSon.data.parentId != null) {
      Node<Model>? father = nodeIdMap[nodeSon.data.parentId] as Node<Model>?;
      findFatherAndRemoveBrothersSearch(father!, name);
      while (father!.data.parentId != null) {
        father = nodeIdMap[father.data.parentId]! as Node<Model>?;
      }
      Node<Model>? fatherLocal =
          findFatherAndRemoveBrothersSearch(father, name);
      if (fatherLocal == null) {
        return father;
      } else {
        var aux = findFatherAndRemoveBrothersSearch(fatherLocal, name);
        if (aux != null) {
          return aux;
        } else {
          return fatherLocal;
        }
      }
    }
    if (nodeSon.data.locationId != null) {
      var locationFather = nodeIdMap[nodeSon.data.locationId];
      locationFather!.children.clear();
      locationFather.children.add(nodeSon);

      return locationFather;
    }
    return null;
  }
}
