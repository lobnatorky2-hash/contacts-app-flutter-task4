import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';

/// Shows an image picked with image_picker, or a placeholder when there is none.
class ContactImage extends StatelessWidget {
  const ContactImage({super.key, required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    final p = path;
    if (p == null) {
      return Container(
        color: AppColors.lightBlue,
        alignment: Alignment.center,
        child: const Icon(Icons.person, size: 64, color: AppColors.darkBlue),
      );
    }
    return kIsWeb
        ? Image.network(p, fit: BoxFit.cover, width: double.infinity)
        : Image.file(File(p), fit: BoxFit.cover, width: double.infinity);
  }
}
