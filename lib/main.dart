import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tractian_app/app_widget.dart';
import 'package:tractian_app/pages/AssetsPage/assets_controller.dart';
import 'package:tractian_app/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupProviders();
  runApp(
    const MyApp(),
  );
}
