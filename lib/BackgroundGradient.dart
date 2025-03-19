import 'package:flutter/material.dart';

// Reusable BackgroundGradient Widget
class BackgroundGradient extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const BackgroundGradient({
    required this.child,
    this.padding = EdgeInsets.zero,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade100, Colors.white], // Red to white gradient
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}