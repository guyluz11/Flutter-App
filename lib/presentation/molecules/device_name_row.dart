import 'package:cybearjinni/presentation/atoms/atoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DeviceNameRow extends StatelessWidget {
  const DeviceNameRow(this.name, this.second);
  final String name;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextAtom(
            name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        second,
      ],
    );
  }
}
