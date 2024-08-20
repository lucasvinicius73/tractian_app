import 'package:flutter/material.dart';
import 'package:tractian_app/models/asset_model.dart';
import 'package:tractian_app/models/companie_model.dart';
import 'package:tractian_app/models/model.dart';
import 'package:tractian_app/models/node_model.dart';
import 'package:tractian_app/shared/service.dart';
import 'package:string_similarity/string_similarity.dart';

class AssetsController extends ChangeNotifier {
  List<Companie> companies = [];
  List<Model> locations = [];
  List<AssetModel> assets = [];
  List<Node<Model>> roots = [];
  List<Node<Model>> subLocations = [];
  Node<Model> root = Node<Model>(Model(id: "id", name: "name"));
  final Map<String, Node<Model>> nodeIdMap = {};
  List<Node<Model>> searchResult = [];

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

  fetchAll(Companie companie) async {
    disposer();
    root = Node(Model(id: 'id', name: companie.name));
    await getLocations(companie);
    await getAssets(companie.id);
    await buildTree(companie);
  }

  buildTree(Companie companie) async {
    await buildLocationsRoots(companie);
    await buildSubLocationsNode();
    await buildAssetsNodes();
    notifyListeners();
  }

  buildLocationsRoots(Companie companie) {
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
    //notifyListeners();
  }

  buildSubLocationsNode() {
    for (var node in root.children) {
      nodeIdMap[node.data.id] = node;
      _fillNodeMap(nodeIdMap, node);
    }
    for (var subLocation in subLocations) {
      nodeIdMap[subLocation.data.id] = subLocation;
      _fillNodeMap(nodeIdMap, subLocation);
    }

    for (var subLocation in subLocations) {
      final parentId = subLocation.data.parentId!;
      final node = nodeIdMap[parentId];
      if (node != null) {
        node.children.add(nodeIdMap[subLocation.data.id]!);
      }
    }
  }

  buildAssetsNodes() {
    final Map<String, Node<Model>> fatherAsset = {};
    final List<Node<Model>> component = [];

    for (int i = 0; i < assets.length + 1;) {
      //Ao chegar ao final do Laço ele vai acionar a função de adicionar os componentes que não encontraram o Pai
      if (i == assets.length) {
        insertComponents(fatherAsset, component);
        break;
      }
      final asset = assets[i];
      print(
          "O Item ${assets[i]} indice $i entrou na filtragem de ${assets.length} itens");
      if (asset.locationId == null && asset.parentId == null) {
        //Verifica se o Asset não esta associado a um Local e se não tem ParentID
        print("Asset que foi pra raiz: ${asset.name}");
        nodeIdMap[asset.id] = Node<AssetModel>(asset);
        root.children.add(nodeIdMap[asset.id]!);

        assets.removeAt(i);
      } else if (asset.locationId != null && asset.sensorId == null) {
        //Se não, verifica se tem um local como Pai
        final locationNode = nodeIdMap[asset.locationId!];
        if (locationNode != null) {
          print(
              "O Asset ${asset.name} é filho do Local ${locationNode.data.name}");
          locationNode.children.add(Node<AssetModel>(asset));
          fatherAsset[asset.id] = locationNode.children
              .where((element) => element.data.id == asset.id)
              .first;

          nodeIdMap[asset.id] = fatherAsset[asset.id]!;
          assets.removeAt(i);
        } else {
          //Se ele não encontrar o Local pai vai pular a ordem do Loop para o proximo
          i++;
        }
      } else {
        //Se ele não possuir um local ou SubLocal como pai, significa que é filho de outro Asset
        final String? parentId = asset.parentId;
        final parentNode = nodeIdMap[parentId];
        if (parentNode != null) {
          print(
              "O Asset ${asset.name} é filho do Asset ${parentNode.data.name}");
          fatherAsset[asset.id] = Node<AssetModel>(asset);
          nodeIdMap[asset.id] = fatherAsset[asset.id]!;
          parentNode.children.add(nodeIdMap[asset.id]!);
          assets.removeAt(i);
        } else {
          //Se não encontrar o Asset pai
          if (asset.locationId != null) {
            //Verifica se ele não pertence a um local
            final locationNode = nodeIdMap[asset.locationId!];
            if (locationNode != null) {
              nodeIdMap[asset.id] = Node<AssetModel>(asset);
              locationNode.children.add(nodeIdMap[asset.id]!);
              assets.removeAt(i);
            } else if (locationNode != null) {
              assets.removeAt(i);
              i++;
            }
          } else {
            //Se não tiver um localID ele vai para a lista de Componentes esperar encontrar o Componente Pai
            print("O componente ${asset.name} foi pra lista de componentes");
            nodeIdMap[asset.id] = Node<AssetModel>(asset);
            component.add(nodeIdMap[asset.id]!);
            i++;
          }
        }
      }
    }

    notifyListeners();
  }

  insertComponents(
      Map<String, Node<Model>> fatherAssets, List<Node<Model>> components) {
    for (var component in components) {
      print("Componente: ${component.data.name}");
      final String? parentId = component.data.parentId;
      final parentNode = fatherAssets[parentId];
      if (parentNode != null) {
        print(
            "O Componente ${component.data.name} é filho do Asset ${parentNode.data.name}");
        parentNode.children.add(component);
      }
    }
    notifyListeners();
  }

  void _fillNodeMap(Map<String, Node<Model>> map, Node<Model> node) {
    for (var child in node.children) {
      map[child.data.id] = child;
      _fillNodeMap(map, child);
    }
  }

  searchItemNode(String name) {
    searchResult = nodeIdMap.values
        .where((element) =>
            element.data.name.toLowerCase().similarityTo(name.toLowerCase()) >
            0.2)
        .toList();
    print("A busca encontrou ${searchResult.length} itens");
    searchResult
        .forEach((element) => print("Itens buscado: ${element.data.name}"));
  }

  searchNode(String nodeName) {
    List<Node<Model>> path = [];

    bool findPathRecursive(Node<Model> node) {
      path.add(node);
      if (node.data.name == nodeName) {
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
