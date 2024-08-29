import 'package:flutter/material.dart';
import 'package:tractian_app/models/companie_model.dart';
import 'package:tractian_app/pages/AssetsPage/assets_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = AssetsController();
  @override
  void initState() {
    controller.getCompanies();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          Widget body = Container();
          if (controller.companies.isNotEmpty) {
            body = Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildButtonHome(controller.companies[0], context),
                  buildButtonHome(controller.companies[1], context),
                  buildButtonHome(controller.companies[2], context),
                ],
              ),
            );
          }
          if (controller.companies.isEmpty) {
            body = Center(child: CircularProgressIndicator());
          }
          return Scaffold(
              appBar: AppBar(
                title: Image.asset('assets/LOGOTRACTIAN.png'),
                backgroundColor: const Color(0xFF17192D),
                centerTitle: true,
              ),
              body: body);
        });
  }

  Widget buildButtonHome(Companie companie, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SizedBox(
        width: 317,
        height: 76,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7))),
              backgroundColor:
                  const MaterialStatePropertyAll(Color(0xFF2188FF))),
          child: Row(
            children: [
              Image.asset('assets/icons/homeicon.png'),
              const SizedBox(
                width: 20,
              ),
              Text(
                companie.name,
                style: const TextStyle(
                    fontSize: 18, color: Colors.white, fontFamily: 'Roboto'),
              ),
            ],
          ),
          onPressed: () {
            Navigator.of(context)
                .pushNamed('/assets_page', arguments: {'companie': companie});
          },
        ),
      ),
    );
  }
}
