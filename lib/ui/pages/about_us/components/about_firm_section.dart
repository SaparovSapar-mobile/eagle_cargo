import 'package:flutter/material.dart';
import 'package:kargoo_core/core/extensions/theme_extension.dart';
import 'package:eagle_cargo/core/api/models/firm_detail_response.dart';

class AboutFirmSection extends StatelessWidget {
  final FirmDetailResponse? firm;
  const AboutFirmSection({super.key, this.firm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // No more huge SizedBox(height: 60) needed here!
          Text(
            firm?.name ?? "YB Express",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            firm?.about ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: context.isDark() ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}