import 'package:flutter/material.dart';
import 'package:kargoo_core/core/extensions/theme_extension.dart';
import 'package:kargoo_core/core/extensions/translate_extension.dart';
import 'package:eagle_cargo/core/api/models/package_model.dart';
import 'package:eagle_cargo/core/utils/local_translations.dart';
import 'package:eagle_cargo/core/utils/utc_format_extenstion.dart';

import '../../../../core/utils/palette.dart';

/// Countries the shipment passes, styled like [OrderDetailVerticalSteps]:
/// passed ones with a check, the current one highlighted with "Now here",
/// upcoming ones grey. Read-only.
class OrderDetailRoute extends StatelessWidget {
  final ShipmentRoute route;
  const OrderDetailRoute({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final checkpoints = route.checkpoints;
    final upcomingColor = context.isDark()
        ? Colors.grey.shade700
        : Colors.grey.shade300;

    return Column(
      children: List.generate(checkpoints.length, (index) {
        final checkpoint = checkpoints[index];
        final isPassed = checkpoint.isPassed;
        final isCurrent = checkpoint.isCurrent;
        final isReached = isPassed || isCurrent;
        final isLast = index == checkpoints.length - 1;

        final date = checkpoint.arrivedDt.convert2Local();
        final String? subtitle = isCurrent
            ? [context.tl('mb_now_here'), if (date.isNotEmpty) date].join(' · ')
            : (isPassed && date.isNotEmpty ? date : null);

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
                    color: isReached ? Palette.primaryLight : upcomingColor,
                  ),
                  child: Center(
                    child: isPassed
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : isCurrent
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
                    height: 44,
                    // Solid only on the stretch already travelled.
                    color: isPassed ? Palette.primaryDark : upcomingColor,
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
                      '${checkpoint.mark} '
                              '${checkpoint.localizedName(context.langCode)}'
                          .trim(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isReached
                            ? (context.isDark() ? Colors.white : Colors.black87)
                            : Colors.grey[500],
                      ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: isCurrent
                                ? Palette.primary
                                : Colors.grey[500],
                            fontWeight: isCurrent
                                ? FontWeight.w600
                                : FontWeight.normal,
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
