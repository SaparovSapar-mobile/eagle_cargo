import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:kargoo_core/kargoo_core.dart' hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/utils/palette.dart';

class ZoomImage extends StatelessWidget {
  final List<String> images;
  const ZoomImage({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDark() ? Palette.darkSurface : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close_rounded, color: Colors.grey, size: 35),
        ),
      ),
      body: Center(
        child: Hero(
          tag: 'danhao-object',
          child: PageView(
            children: images
                .map(
                  (e) => Stack(
                    children: [
                      PhotoView(
                        minScale: PhotoViewComputedScale.contained,
                        backgroundDecoration: BoxDecoration(
                          // color: Palette.mainGrey,
                          color: context.isDark()
                              ? Palette.darkSurface
                              : Colors.white,
                        ),
                        imageProvider: CachedNetworkImageProvider(e),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
