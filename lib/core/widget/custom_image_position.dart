 import 'package:flutter/material.dart';

class CustomImagePositioned extends StatelessWidget {
  final String imagePath;
  final double height;
  final double width;
  final double? right, bottom, left, top;
  final bool isCircle; // خاصية جديدة للبروفايل

  const CustomImagePositioned({
    super.key,
    required this.imagePath,
    required this.height,
    required this.width,
    this.right, this.bottom, this.left, this.top,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right, bottom: bottom, left: left, top: top,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}