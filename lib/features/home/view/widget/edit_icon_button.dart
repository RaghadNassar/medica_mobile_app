
import 'package:flutter/material.dart';

class EditIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final ThemeData theme;

  const EditIconButton({required this.onTap, required this.theme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 16,
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.photo_camera, color: theme.colorScheme.surface, size: 16),
      ),
    );
  }
}