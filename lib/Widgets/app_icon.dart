import 'package:flutter/material.dart';

import 'dimensions.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double? iconSize;
  final double size;
  const AppIcon({Key? key,
    required this.icon,
    this.backgroundColor = const Color(0xFFfcf4e4),
    this.iconColor = const Color(0xFF756d54),
    this.iconSize = 16,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size/2),
          color: backgroundColor
      ),
      child: Icon(icon, color: iconColor, size: iconSize, ),
    );
  }
}