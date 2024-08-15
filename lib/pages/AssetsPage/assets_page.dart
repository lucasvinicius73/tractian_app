import 'package:flutter/material.dart';
import 'package:tractian_app/models/companie_model.dart';
import 'package:tractian_app/models/node_model.dart';
import 'package:tractian_app/pages/AssetsPage/assets_controller.dart';
import 'package:tractian_app/provider.dart';
import 'package:tractian_app/widgets/tree_widget.dart';

class AssetsPage extends StatefulWidget {
  final Companie companie;
  const AssetsPage({super.key, required this.companie});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  final controller = getIt<AssetsController>();
  @override
  void initState() {
    controller.buildTree(widget.companie);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        Widget body = Container();
        if (controller.first.children.isNotEmpty) {
          body = Column(
            mainAxisSize: MainAxisSize.min,
            children: [buildHeader(), const Divider(), buildTree(controller)],
          );
        }
        if (controller.first.children.isEmpty) {
          body = Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                "Assets",
                style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
              ),
              backgroundColor: const Color(0xFF17192D),
              centerTitle: true,
            ),
            body: SingleChildScrollView(child: body));
      },
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color(0xFFEAEFF3),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            width: 328,
            height: 32,
            child: const Text("Buscar Ativo ou Local",
                style: TextStyle(color: Color(0xFF77818C))),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 180,
                height: 32,
                child: OutlinedButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    side: const MaterialStatePropertyAll(
                        BorderSide(color: Color(0xFF77818C))),
                  ),
                  icon: Image.asset("assets/icons/energyIcon.png"),
                  label: const Text(
                    "Sensor de Energia",
                    maxLines: 1,
                    style: TextStyle(
                      color: Color(0xFF77818C),
                      fontFamily: 'Roboto',
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                width: 106,
                height: 32,
                child: OutlinedButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3))),
                    side: const MaterialStatePropertyAll(
                        BorderSide(color: Color(0xFF77818C))),
                  ),
                  icon: Image.asset("assets/icons/criticalIcon.png"),
                  label: const Text(
                    "Critico",
                    style: TextStyle(
                        color: Color(0xFF77818C), fontFamily: 'Roboto'),
                  ),
                  onPressed: () {},
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildTree(AssetsController controller) {
    //B.children.add(D);
    // C.children.add(E);
    return TreeWidget(node: controller.first);
  }
}
