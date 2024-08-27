import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:tractian_app/models/asset_model.dart';
import 'package:tractian_app/models/location_model.dart';
import 'package:tractian_app/models/node_model.dart';

class TreeWidget extends StatefulWidget {
  final Node node;
  const TreeWidget({super.key, required this.node});

  @override
  State<TreeWidget> createState() => _TreeWidgetState();
}

class _TreeWidgetState extends State<TreeWidget> {
  bool drop = false;

  @override
  Widget build(BuildContext context) {
    print("Nó ${widget.node.data} tem ${widget.node.children.length} filhos");
    String icon = 'assets/icons/criticalIcon.png';
    Icon? status;
    if (widget.node.data is LocationModel) {
      icon = 'assets/icons/GoLocation.png';
    } else if (widget.node.data is AssetModel) {
      icon = 'assets/icons/asset.png';
      if (widget.node.data.sensorType != null) {
        icon = "assets/icons/component.png";
        if (widget.node.data.status == "operating") {
          status = const Icon(
            Icons.bolt,
            color: Colors.green,
            size: 20,
          );
        }
        if (widget.node.data.status == "alert") {
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
        InkWell(
          onTap: () {
            setState(() {
              drop = !drop;
            });
          },
          child: Row(
            children: [
              widget.node.children.isNotEmpty
                  ? Icon(drop == true
                      ? Icons.arrow_drop_down
                      : Icons.arrow_drop_up)
                  : const SizedBox(
                      width: 23,
                    ),
              Image.asset(
                icon,
                scale: 1.7,
              ),
              Text('${widget.node.data}'),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: status ?? const SizedBox(),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        widget.node.children.isNotEmpty && drop == true
            ? Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SuperListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.node.children.length,
                    itemBuilder: (context, index) =>
                        TreeWidget(node: widget.node.children[index]),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
