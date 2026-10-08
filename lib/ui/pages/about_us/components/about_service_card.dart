import 'package:flutter/material.dart';
import 'package:kargoo_core/core/extensions/theme_extension.dart';
import 'package:kargoo_core/core/extensions/translate_extension.dart';
import 'package:eagle_cargo/core/api/models/firm_rate_model.dart';
import 'package:eagle_cargo/core/utils/dev_constants.dart';
import 'package:eagle_cargo/core/utils/palette.dart';
import 'package:eagle_cargo/core/utils/utc_format_extenstion.dart';

class AboutServiceCard extends StatelessWidget {
  final FirmRateModel rate;
  const AboutServiceCard({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final from = rate.fromLocation?.getLocalizedTitle(langCode) ?? "";
    final to = rate.toLocation?.getLocalizedTitle(langCode) ?? "";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.isDark()
            ? Palette.darkSurface
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // if (context.isDark())
            BoxShadow(
              color: Colors.black.withValues(alpha:  0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
        border: Border.all(
          color: context.isDark() ? Colors.white10 : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          // Route info
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              _buildRoutePoint(context, from, Icons.location_on_outlined),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: context.isDark() ? Colors.grey[600] : Colors.grey[400],
              ),
              _buildRoutePoint(context, to, Icons.location_on, isEnd: true),
            ],
          ),
          const Padding(
            padding: .symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          // Details grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCompactInfo(
                context,
                context.tr('transport'),
                context.tr(
                  DevConstants.transports
                      .where((e) => e.key == rate.transportType)
                      .first
                      .name,
                ),
                DevConstants.transports
                    .where((e) => e.key == rate.transportType)
                    .first
                    .icon,
              ),
              _buildCompactInfo(
                context,
                context.tr('service'),
                rate.serviceType?.toSentenceCase() ?? "-",
                Icons.star_outline_rounded,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCompactInfo(
                context,
                context.tr('mb_price_per_kg'),
                "${rate.pricePerKg} ${rate.currency}",
                Icons.payments_outlined,
              ),
              _buildCompactInfo(
                context,
                context.tr('mb_deadline'),
                rate.deadline ?? "-",
                Icons.speed_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildRoutePoint(
    BuildContext context,
    String title,
    IconData icon, {
    bool isEnd = false,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: isEnd
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isEnd) ...[
            Icon(icon, size: 18, color: Palette.primary),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: isEnd ? TextAlign.end : TextAlign.start,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          if (isEnd) ...[
            const SizedBox(width: 8),
            Icon(icon, size: 18, color: Palette.primary),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactInfo(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Palette.primary.withValues(alpha: 255 * 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: context.isDark() ? Colors.white54 : Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}