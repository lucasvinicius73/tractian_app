import 'package:flutter/material.dart';
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

bool drop = false;
String icon = '';
Icon? status;

class _TreeWidgetState extends State<TreeWidget> {
  @override
  void initState() {
    drop = widget.node.children.length > 5 ? false : true;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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
              icon.isNotEmpty
                  ? Image.asset(
                      icon,
                      scale: 1.7,
                    )
                  : const SizedBox(),
              SizedBox(
                width: 232,
                child: Text(
                  '${widget.node.data}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
                    cacheExtent: 200,
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
