import 'package:flutter/material.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/home/view/widget/edit_icon_button.dart';

// class ProfileImageWithEdit extends StatelessWidget {
//   final String imagePath;
//   final VoidCallback onEditTap;

//   const ProfileImageWithEdit({
//     super.key,
//     required this.imagePath,
//     required this.onEditTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final double imageSize = context.widthPct(0.22);

//     return SizedBox(
//       height: imageSize + 10, // مساحة إضافية للأيقونة البارزة
//       width: imageSize + 10,
//       child: Stack(
//         alignment: Alignment.topLeft,
//         children: [
//           // ويدجت الصورة العامة التي أنشأناها سابقاً
//           CustomImagePositioned(
//             imagePath: imagePath,
//             height: imageSize,
//             width: imageSize,
//             isCircle: true,
//           ),
//           // أيقونة التعديل
//           Positioned(
//             bottom: 0,
//             right: 0,
//             child: EditIconButton(onTap: onEditTap, theme: theme),
//           ),
//         ],
//       ),
//     );
//   }
// }
class ProfileImageWithEdit extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onEditTap;

  const ProfileImageWithEdit({
    super.key,
    this.imagePath,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double imageSize = context.widthPct(0.22);

    return SizedBox(
      height: imageSize + 10,
      width: imageSize + 10,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          imagePath != null && imagePath!.startsWith('http')
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(imageSize / 2),
                  child: Image.network(
                    imagePath!,
                    height: imageSize,
                    width: imageSize,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: imageSize,
                        width: imageSize,
                        color: theme.colorScheme.surface,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultUserIcon(imageSize, theme);
                    },
                  ),
                )
              : _buildDefaultUserIcon(
                  imageSize, theme), // إذا كان الرابط نل أو فارغاً

          Positioned(
            bottom: 0,
            right: 0,
            child: EditIconButton(onTap: onEditTap, theme: theme),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultUserIcon(double size, ThemeData theme) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.person_rounded,
        size: size * 0.6,
        color: theme.primaryColor,
      ),
    );
  }
}
