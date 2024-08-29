import 'package:string_similarity/string_similarity.dart';
import 'package:tractian_app/pages/AssetsPage/assets_controller.dart';

void main() async {
  final controller = AssetsController();

  await controller.getCompanies();
  await controller.fetchAll(controller.companies[1]);
  //controller.searchItemNode("Disk Mill");
  //controller.filterNodes("alert");

  similar() {
    return "Milling".toLowerCase().similarityTo("Disk Mill".toLowerCase());
  }

  print("Busca ${similar()}");
}
