import 'package:flutter/material.dart';
import 'package:tractian_app/models/companie_model.dart';
import 'package:tractian_app/models/model.dart';
import 'package:tractian_app/models/node_model.dart';
import 'package:tractian_app/pages/AssetsPage/assets_controller.dart';
import 'package:tractian_app/widgets/tree_widget.dart';

class AssetsView extends StatefulWidget {
  final Companie companie;
  const AssetsView({super.key, required this.companie});

  @override
  State<AssetsView> createState() => _AssetsViewState();
}

class _AssetsViewState extends State<AssetsView> {
  final controller = AssetsController();
  @override
  void initState() {
    controller.fetchAll(widget.companie);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        Widget body = Container();

        if (controller.searchResult.children.isEmpty &&
            controller.root.children.isNotEmpty) {
          body = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildHeader(),
              const Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: buildTree(controller.root),
              )
            ],
          );
        }
        if (controller.searchResult.children.isNotEmpty) {
          body = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildHeader(),
              const Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: buildTree(controller.searchResult),
              )
            ],
          );
        }

        if (controller.root.children.isEmpty) {
          body = Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.38),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                "Assets ${widget.companie.name}",
                style:
                    const TextStyle(color: Colors.white, fontFamily: 'Roboto'),
              ),
              backgroundColor: const Color(0xFF17192D),
              centerTitle: true,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                controller.fetchAll(widget.companie);
              },
              child: const Icon(Icons.restart_alt),
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
          SizedBox(
            width: 350,
            height: 40,
            child: TextFormField(
              onFieldSubmitted: (value) {
                controller.searchItemNode(value);
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  top: 8,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                ),
                hintText: 'Buscar Ativo ou Local',
                isDense: true,
                fillColor: const Color(0xFFEAEFF3),
                filled: true,
                prefixIconConstraints: const BoxConstraints(
                  minHeight: 48,
                  minWidth: 38,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide:
                      const BorderSide(color: Color(0xFFF1F5F4), width: 3),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide:
                      const BorderSide(color: Color(0xFFF1F5F4), width: 3),
                ),
              ),
            ),
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
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    side: WidgetStatePropertyAll(BorderSide(
                        color: controller.operating == true
                            ? Colors.blue
                            : const Color(0xFF77818C))),
                  ),
                  icon: Image.asset(
                    "assets/icons/energyIcon.png",
                    color: controller.operating == true
                        ? Colors.blue
                        : const Color(0xFF77818C),
                  ),
                  label: Text(
                    "Sensor de Energia",
                    maxLines: 1,
                    style: TextStyle(
                      color: controller.operating == true
                          ? Colors.blue
                          : const Color(0xFF77818C),
                      fontFamily: 'Roboto',
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () {
                    controller.changeFilterState("operating");
                  },
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
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3))),
                    side: WidgetStatePropertyAll(BorderSide(
                        color: controller.critic == true
                            ? Colors.blue
                            : const Color(0xFF77818C))),
                  ),
                  icon: Image.asset(
                    "assets/icons/criticalIcon.png",
                    color: controller.critic == true
                        ? Colors.blue
                        : const Color(0xFF77818C),
                  ),
                  label: Text(
                    "Critico",
                    style: TextStyle(
                        color: controller.critic == true
                            ? Colors.blue
                            : const Color(0xFF77818C),
                        fontFamily: 'Roboto'),
                  ),
                  onPressed: () {
                    controller.changeFilterState("alert");
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildTree(Node<Model> node) {
    return TreeWidget(node: node);
  }
}
