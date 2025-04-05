import 'package:jima/src/tools/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class EvenlySpacedMultiSliver extends StatelessWidget {
  final bool? pushPinnedChildren;
  final List<Widget> children;
  final double? spacing;
  final Widget? spacerWidget;

  const EvenlySpacedMultiSliver({
    required this.children,
    this.pushPinnedChildren,
    this.spacing,
    this.spacerWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      pushPinnedChildren: pushPinnedChildren ?? false,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i != 0) spacerWidget ?? (spacing ?? 0).boxHeight,
          children[i],
        ],
      ],
    );
  }
}
