import 'package:flutter/material.dart';
import 'package:kargoo_core/core/extensions/theme_extension.dart';
import 'package:kargoo_core/core/extensions/translate_extension.dart';
import 'package:eagle_cargo/core/api/models/package_model.dart';
import 'package:eagle_cargo/core/utils/utc_format_extenstion.dart';

import '../../../../core/utils/palette.dart';

class OrderDetailVerticalSteps extends StatelessWidget {
  final PackageModel? item;
  const OrderDetailVerticalSteps({super.key, required this.item});

  int _getStepIndex(String? status) {
    switch (status) {
      case 'confirmed':
      case 'registered':
        return 1;
      case 'in_transit':
      case 'transport':
        return 2;
      case 'is_checked':
      case 'completed':
        return 3;
      case 'delivered':
        return 4;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (item == null) return const SizedBox();
    final String from = context
        .tr('mb_in_z_warehouse')
        .replaceAll(
          'zzz',
          item?.order?.fromLocation?.getLocalizedTitle(context.langCode) ?? '',
        );
    final String to = context
        .tr('mb_in_z_warehouse')
        .replaceAll(
          'zzz',
          item?.order?.toLocation?.getLocalizedTitle(context.langCode) ?? '',
        );
    final createdDate = item?.order?.createdDt.convert2Local();
    final steps = [
      {
        'label': from,
        'subtitle': (createdDate != null && createdDate.isNotEmpty)
            ? createdDate
            : null,
      },
      {'label': context.tr('package_status_transport'), 'subtitle': null},
      {'label': to, 'subtitle': null},
      {'label': context.tr('mb_delivered_to_customer_short'), 'subtitle': null},
    ];

    final currentStep = _getStepIndex(item?.status);

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final stepNum = index + 1;
        final isActive = stepNum == currentStep;
        final isCompleted = stepNum <= currentStep;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? Palette.primaryLight
                        : Palette.primaryDark,
                  ),
                  child: Center(
                    child: stepNum < currentStep
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : isActive
                        ? Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 44, // Adjusted height for better vertical flow
                    color: isCompleted
                        ? Palette.primaryDark
                        : Palette.primaryLight,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['label'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isCompleted
                            ? (context.isDark() ? Colors.white : Colors.black87)
                            : Colors.grey[500],
                      ),
                    ),
                    if (step['subtitle'] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          step['subtitle'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
