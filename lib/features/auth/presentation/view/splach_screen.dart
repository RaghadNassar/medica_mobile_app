import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';

class SplachScreen extends StatelessWidget {
  const SplachScreen({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Image.asset(Appassets.imageSplash),
        
      )
    );
  }
}
