import 'package:flutter/material.dart';

import '../data.dart';

/// Widget gambar menu yang aman digunakan untuk aplikasi.
///
/// Mengandung placeholder saat gambar masih dimuat maupun saat gagal dimuat,
/// sehingga aplikasi tidak pernah crash walaupun gambar tidak tersedia.
class MenuImage extends StatelessWidget {
  const MenuImage({
    super.key,
    required this.menu,
    this.width,
    this.height,
    this.borderRadius,
  });

  final Menu menu;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final Widget image = Image.asset(
      menu.image,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
        return _Fallback(width: width, height: height);
      },
    );

    if (borderRadius == null) {
      return image;
    }

    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFFFE3E3),
      alignment: Alignment.center,
      child: const Icon(Icons.restaurant, color: Color(0xFFD32F2F), size: 32),
    );
  }
}