import 'package:flutter/material.dart';

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const RadialGradient(
        center: Alignment.topCenter,
        radius: 1,
        colors: [Color(0xfffe5858), Color(0xffee9617)],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
