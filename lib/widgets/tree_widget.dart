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
    Icon? status;
    if (node.data is LocationModel) {
      icon = 'assets/icons/GoLocation.png';
    } else if (node.data is AssetModel) {
      icon = 'assets/icons/asset.png';
      if (node.data.sensorType != null) {
        icon = "assets/icons/component.png";
        if (node.data.status == "operating") {
          status = const Icon(
            Icons.bolt,
            color: Colors.green,
            size: 20,
          );
        }
        if (node.data.status == "alert") {
          status = const Icon(
            Icons.circle,
            color: Colors.red,
            size: 13,
          );
        }
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Image.asset(
              icon,
              scale: 1.7,
            ),
            Text('${node.data}'),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: status ?? const SizedBox(),
            )
          ],
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
