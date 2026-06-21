import 'package:flutter/material.dart';

class CustomTextClickable extends StatelessWidget {
  final String? text;     
  final String linkText;  
  final VoidCallback onTap;
  final AlignmentGeometry alignment;
  final bool isUnderline;

  const CustomTextClickable({
    super.key,
    this.text,
    required this.linkText,
    required this.onTap,
    this.alignment = Alignment.center,
    this.isUnderline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min, 
          children: [
            if (text != null) ...[
              Text(text!, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: 4),
            ],
            Text(
              linkText,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}