import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kargoo_core/core/extensions/theme_extension.dart';
import 'package:kargoo_core/core/extensions/translate_extension.dart';
import 'package:eagle_cargo/core/utils/palette.dart';

class HomeSearchCard extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onSubmitted;
  final void Function()? onScanQr;
  
  const HomeSearchCard({super.key, required this.controller, this.onSubmitted, this.onScanQr});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.isDark() ? Palette.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: context.defaultShadow(),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            context.t('mb_track_your_order'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: .w700,
              color: context.textColor(),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: context.isDark() ? null : Colors.grey.shade100,
              border: context.isDark()
                  ? Border.all(color: Colors.grey.shade100)
                  : null,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              textInputAction: .search,
              style: TextStyle(
                fontSize: 16,
                color: context.isDark() ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                hintText: context.tr('mb_enter_track_number'),
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.grey,
                ),
                suffixIcon: GestureDetector(
                  onTap: onScanQr,
                  child: const Icon(
                    CupertinoIcons.qrcode_viewfinder,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: .circular(16),
                  borderSide: .none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}