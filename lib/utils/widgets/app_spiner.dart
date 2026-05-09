import 'package:flutter/material.dart';

class AppSpiner extends StatelessWidget {
  final double size;
  const AppSpiner({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}