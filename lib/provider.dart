import 'package:get_it/get_it.dart';
import 'package:tractian_app/pages/AssetsPage/assets_controller.dart';

final getIt = GetIt.instance;

setupProviders() {
  getIt.registerLazySingleton<AssetsController>(() => AssetsController());
}
