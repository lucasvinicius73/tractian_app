import 'package:flutter/material.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:tractian_app/pages/AssetsPage/assets_controller.dart';
import 'package:tractian_app/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupProviders();
  final controller = getIt<AssetsController>();

  await controller.getCompanies();
  //await controller.fetchAll(controller.companies[1]);
  //controller.searchItemNode("Disk Mill");

  similar() {
    return "Milling"
        .toLowerCase()
        .similarityTo("Disk Mill".toLowerCase());
  }

  print("Busca ${similar()}");
}
