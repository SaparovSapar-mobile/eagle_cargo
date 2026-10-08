import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  const CachedImage({super.key, required this.imageUrl, this.fit, this.width});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        width: width,
        placeholder: (context, url) =>
            Image.memory(kTransparentImage, fit: BoxFit.cover),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fadeInDuration: const Duration(milliseconds: 500),
        fadeInCurve: Curves.easeIn);
  }
}
