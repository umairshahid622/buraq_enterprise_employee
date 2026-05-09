import 'package:flutter/material.dart';

class AppScrollableBody extends StatelessWidget {
  final Widget child;
  final bool centerContent;

  const AppScrollableBody({
    super.key,
    required this.child,
    this.centerContent = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          // This physics ensures the scrollable area is always interactive
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              // Fill the available height of the LayoutBuilder
              minHeight: constraints.maxHeight,
            ),
            child: Container(
              // Use alignment instead of Center widget to avoid Intrinsic conflicts
              alignment: centerContent ? Alignment.center : Alignment.topCenter,
              child: child,
            ),
          ),
        );
      },
    );
  }
}