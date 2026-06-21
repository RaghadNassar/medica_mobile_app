import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomSkeletonizer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final ShimmerEffect? effect; 

  const CustomSkeletonizer({
    super.key,
    required this.child,
    required this.isLoading,
    this.effect,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      effect: effect ?? const ShimmerEffect(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        duration: Duration(milliseconds: 1500),
      ),
      child: child,
    );
  }
}