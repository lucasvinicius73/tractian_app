import 'package:flutter/material.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:tractian_app/pages/AssetsPage/assets_controller.dart';
import 'package:tractian_app/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupProviders();
  final controller = getIt<AssetsController>();

  await controller.getCompanies();
  await controller.fetchAll(controller.companies[0]);
  controller.searchItemNode("Motor");

  // similar() {
  //   return "MOTOR TC01 COAL UNLOADING AF02"
  //       .toLowerCase()
  //       .similarityTo("Motor".toLowerCase());
  // }

  // print(
  //     "Objeto Comparado: ${"MOTOR TC01 COAL UNLOADING AF02".split(" ").first}");
  // print("Busca ${similar()}");
}
