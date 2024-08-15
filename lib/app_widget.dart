import 'package:flutter/material.dart';
import 'package:tractian_app/pages/AssetsPage/assets_page.dart';
import 'package:tractian_app/pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/' : (context) => const HomePage(),
        '/assets_page': (context){
          final args = ModalRoute.of(context)?.settings.arguments as Map;
          return AssetsPage(companie: args['companie']);
        }
      },
    );
  }
}