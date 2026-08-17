import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';

class DoctorHeaderImage extends StatelessWidget {
  final String? imagePath;
  final String doctorName;
  final String specialty;
  final VoidCallback onBackTap;
  final VoidCallback onShareTap;
  final VoidCallback onFavoriteTap;

  const DoctorHeaderImage({
    super.key,
    this.imagePath,
    required this.doctorName,
    required this.specialty,
    required this.onBackTap,
    required this.onShareTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double headerHeight = context.heightPct(0.34);

    return Stack(
      children: [
        ClipRRect(
          // borderRadius:
          //     const BorderRadius.vertical(bottom: Radius.circular(28)),
          child: Container(
            width: double.infinity,
            height: headerHeight,
            color: theme.colorScheme.primaryContainer.withOpacity(0.08),
            child: imagePath != null && imagePath!.isNotEmpty
                ? Image.network(
                    imagePath!,
                    width: double.infinity,
                    height: headerHeight,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: theme.colorScheme.primary,
                        size: 190,
                      ),
                    ),
                  )
                : Center(
                    child: Icon(
                      Icons.person_rounded,
                      color: theme.colorScheme.primary,
                      size: 110,
                    ),
                  ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(28)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.05),
                  Colors.transparent,
                  Colors.black.withOpacity(0.02),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircularButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: onBackTap,
              ),
              // Row(
              //   children: [
              //     _buildCircularButton(
              //       icon: Icons.share_outlined,
              //       onTap: onShareTap,
              //     ),
              //     SizedBox(width: context.widthPct(0.02)), // مسافة بين زر المشاركة والمفضلة
              //     _buildCircularButton(
              //       icon: Icons.favorite_border_rounded,
              //       onTap: onFavoriteTap,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: AppSpacing.screenPadding5,
        decoration:const BoxDecoration(
          color: AppColors.lightSurface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.darkBackground, size: 22),
      ),
    );
  }
}
/*
class DoctorHeaderImage extends StatelessWidget {
  final String imagePath;
  final String doctorName;
  final String specialty;
  final VoidCallback onBackTap;
  final VoidCallback onShareTap;
  final VoidCallback onFavoriteTap;

  const DoctorHeaderImage({
    super.key,
    required this.imagePath,
    required this.doctorName,
    required this.specialty,
    required this.onBackTap,
    required this.onShareTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // 1. صورة الطبيب الممتدة ومقصوصة الحواف من الأسفل بنعومة
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(28)),
          child: Image.asset(
            imagePath,
            width: double.infinity,
            height: context.heightPct(0.3), // تأخذ مساحة هيدر ممتازة ومتجاوبة
            fit: BoxFit.fitHeight,
            alignment:Alignment.topCenter ,
          ),
        ),

        // 2. طبقة ظل (Gradient) أسفل الصورة للتأكد من وضوح نصوص الاسم والاختصاص
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(28)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.15),
                  Colors.transparent,
                  Colors.black.withOpacity(0.14), // الظل السفلي الداكن
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),

        // 3. أزرار التحكم العلوية (الرجوع، مشاركة، مفضلة)
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // زر الرجوع الخلفي الدائري الـ Translucent
              _buildCircularButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: onBackTap,
              ),
              Row(
                children: [
                  _buildCircularButton(
                    icon: Icons.share_outlined,
                    onTap: onShareTap,
                  ),
                   SizedBox(width: context.widthPct(0.02)), // مسافة بين زر المشاركة والمفضلة
                  _buildCircularButton(
                    icon: Icons.favorite_border_rounded,
                    onTap: onFavoriteTap,
                  ),
                ],
              ),
            ],
          ),
        ),

        // 4. نصوص معلومات الطبيب المكتوبة فوق الصورة من الأسفل
       /* Positioned(
          bottom: 20,
          right: 20,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(doctorName,
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: theme.primaryColor)),
              SizedBox(
                  height: context
                      .heightPct(0.005)), // مسافة صغيرة بين الاسم والاختصاص
              Text(specialty, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),*/
      ],
    );
  }

  Widget _buildCircularButton(
      {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: AppSpacing.screenPadding5,
        decoration: BoxDecoration(
          color: AppColors.darkBackground.withOpacity(0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.lightSurface, size: 22),
      ),
    );
  }
}*/