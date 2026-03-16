import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Displays a rating's image, preferring the locally stored copy over the
/// remote URL. Falls back gracefully at every level:
///   local file  →  remote URL (cached)  →  broken-image placeholder
class RatingImage extends StatelessWidget {
  final String imageUrl;
  final String localImagePath;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const RatingImage({
    super.key,
    required this.imageUrl,
    required this.localImagePath,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (localImagePath.isNotEmpty) {
      image = Image.file(
        File(localImagePath),
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    } else if (imageUrl.isNotEmpty) {
      image = CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        placeholder: (_, _) => SizedBox(
          height: height,
          width: width,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (_, _, _) => _placeholder(),
      );
    } else {
      return _placeholder();
    }

    return ClipRRect(borderRadius: borderRadius, child: image);
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(30),
        borderRadius: borderRadius,
      ),
      child: Icon(
        Icons.broken_image_outlined,
        size: (height ?? 56) * 0.45,
        color: Colors.grey.withAlpha(120),
      ),
    );
  }
}
