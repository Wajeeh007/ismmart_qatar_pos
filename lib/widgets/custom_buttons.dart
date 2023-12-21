import 'package:flutter/material.dart';

import '../helper/theme_helper.dart';

class CustomTextBtn extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double width;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final MaterialTapTargetSize? tapTargetSize;
  final OutlinedBorder? shape;
  final BorderSide borderSide;
  final double radius;

  const CustomTextBtn({
    Key? key,
    this.height = 50,
    this.title = "",
    this.width = double.infinity,
    required this.onPressed,
    this.backgroundColor = ThemeHelper.primaryColor,
    this.foregroundColor = Colors.white,
    this.child,
    this.padding,
    this.tapTargetSize,
    this.borderSide = BorderSide.none,
    this.shape,
    this.radius = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: padding,
        tapTargetSize: tapTargetSize,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: Size(width, height),
        side: borderSide,
        shape: (shape != null)
            ? shape
            : RoundedRectangleBorder(
                side: borderSide,
                borderRadius: BorderRadius.circular(radius),
              ),
      ),
      child: child ??
          Text(
            title,
            style: const TextStyle(fontSize: 15),
          ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? iconColor;

  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: const BoxConstraints.tightFor(height: 35),
      splashRadius: 16,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      icon: Icon(
        icon,
        color: iconColor ?? Colors.white70,
        size: 16,
      ),
    );
  }
}

class CustomIconButton2 extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? iconColor;

  const CustomIconButton2({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 22,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      icon: Icon(
        icon,
        color: iconColor ?? Colors.white70,
      ),
    );
  }
}
