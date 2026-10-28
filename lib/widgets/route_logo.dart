import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_colors.dart';

/// App-bar / splash logo.
///
/// Placeholder text version. To use the real Route logo, export it from Figma
/// into `assets/images/route_logo.png`, declare it in pubspec.yaml and replace
/// the body with `Image.asset('assets/images/route_logo.png', height: height)`.
class RouteLogo extends StatelessWidget {
  const RouteLogo({super.key, this.height = 40});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Route',
      style: GoogleFonts.quicksand(
        fontSize: height,
        fontWeight: FontWeight.w300,
        color: AppColors.gold,
        height: 1,
      ),
    );
  }
}
