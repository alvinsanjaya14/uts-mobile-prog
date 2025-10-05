import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final Color? borderColor;
  final double borderWidth;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24.0,
    this.backgroundColor = Colors.transparent,
    this.iconColor = Colors.black,
    this.borderColor,
    this.borderWidth = 1,
  });

  const CircleIconButton.filled({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24.0,
    this.backgroundColor = const Color.fromARGB(207, 255, 255, 255),
    this.iconColor = Colors.black,
    this.borderColor,
    this.borderWidth = 1,
  });

  const CircleIconButton.outlined({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24.0,
    this.backgroundColor = Colors.transparent,
    this.iconColor = Colors.black,
    this.borderColor = Colors.black,
    this.borderWidth = 1,
  });

  const CircleIconButton.transparent({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24.0,
    this.backgroundColor = Colors.transparent,
    this.iconColor = Colors.black,
    this.borderColor,
    this.borderWidth = 0,
  });
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: iconColor,
        shape: const CircleBorder(),
        iconSize: size,
        side: borderColor != null
            ? BorderSide(color: borderColor!, width: borderWidth)
            : null,
        padding: EdgeInsets.zero,
      ),
      onPressed: onPressed,
    );
  }
}
