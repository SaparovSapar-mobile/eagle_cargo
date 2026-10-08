import 'package:flutter/material.dart';
import 'package:kargoo_core/core/extensions/translate_extension.dart';
import 'package:eagle_cargo/core/api/models/firm_rate_model.dart';

import 'about_service_card.dart';

class AboutServiceSection extends StatelessWidget {
  final List<FirmRateModel> rates;
  const AboutServiceSection({super.key, required this.rates});

  @override
  Widget build(BuildContext context) {
    if (rates.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('mb_our_services'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rates.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final rate = rates[index];
              return AboutServiceCard(rate: rate);
            },
          ),
        ],
      ),
    );
  }
}