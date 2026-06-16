import 'package:flutter/material.dart';

class BannerDotIndicator extends StatelessWidget {
  final int index;
  final int currentPage;
  final ThemeData theme;

  const BannerDotIndicator({
    super.key,
    required this.index,
    required this.currentPage,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: currentPage == index ? 9 : 8,
      decoration: BoxDecoration(
        color: currentPage == index
            ? theme.colorScheme.primary
            : theme.colorScheme.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
