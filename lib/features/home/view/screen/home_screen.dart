import 'package:flutter/material.dart';
import 'package:raghad_pro/features/home/view/widget/home_body_content.dart';
import 'package:raghad_pro/features/home/view/widget/home_header_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            HomeHeaderSection(), // الجزء العلوي (اللوغو والإشعارات)
            HomeBodyContent(),   // باقي المحتوى (البحث، الاختصاصات، الأطباء)
          ],
        ),
      ),
    );
  }
}
