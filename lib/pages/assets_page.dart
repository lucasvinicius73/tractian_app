import 'package:flutter/material.dart';
import 'package:tractian_app/models/node_model.dart';
import 'package:tractian_app/widgets/tree_widget.dart';

class AssetsPage extends StatelessWidget {
  const AssetsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [buildHeader(), const Divider(), buildTree()],
      ),
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

  Widget buildTree() {
    Node<String> root = Node('A');
    Node<String> B = Node('B');
    Node<String> C = Node('C');
    Node<String> D = Node('D');
    Node<String> E = Node('E');

    root.children.addAll([B, C]);
    B.children.add(D);
    C.children.add(E);
    return TreeWidget(node: root);
  }
}
