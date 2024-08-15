import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tractian_app/models/asset_model.dart';
import 'package:tractian_app/models/location_model.dart';
import 'package:tractian_app/models/node_model.dart';

class TreeWidget extends StatelessWidget {
  final Node node;
  //final Node? son;
  const TreeWidget({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    print("Nó ${node.data} tem ${node.children.length} filhos");
    String icon = 'assets/icons/criticalIcon.png';
    switch (node.data) {
      case LocationModel():
        icon = 'assets/icons/GoLocation.png';
      case AssetModel():
        icon = 'assets/icons/asset.png';
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [Image.asset(icon), Text('${node.data}')],
        ),
        const SizedBox(
          height: 5,
        ),
        node.children.isNotEmpty
            ? Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: node.children.length,
                    itemBuilder: (context, index) =>
                        TreeWidget(node: node.children[index]),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
