import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/cliper_widget.dart';


class AuthScaffold extends StatelessWidget {
  final Widget child;

  const AuthScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final double headerHeight = context.heightPct(0.26);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true, 
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(), 
        child: Column(
          children: [
            SizedBox(
              height: headerHeight,
              width: double.infinity,
              child: ClipPath(
                clipper: ExactReservaClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accentTeal,
                        AppColors.accentTeal.withOpacity(0.85),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 40,
                        left: 20,
                        child:  Image.asset(
          Appassets.logoApp,
          height: 90,
          color: AppColors.white.withOpacity(0.12) ,
          colorBlendMode: BlendMode.srcIn,
        ),
                       
                      ),
                      Positioned(
                        top: -10,
                        right: -10,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.white.withOpacity(0.08),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
















































































// class AuthScaffold extends StatelessWidget {
//   final Widget child;

//   const AuthScaffold({
//     super.key,
//     required this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: SafeArea(
//         child: SingleChildScrollView(
//          // padding: AppSpacing.screenPadding1,
//           child: child,
//         ),
//       ),
//     );
//   }
// }
