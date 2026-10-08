import 'package:flutter/material.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;

import 'package:eagle_cargo/core/api/models/warning_model.dart';
import 'package:eagle_cargo/core/utils/palette.dart';
import 'package:eagle_cargo/core/utils/utc_format_extenstion.dart';
import 'package:eagle_cargo/ui/components/warning_html_content.dart';
import 'package:eagle_cargo/ui/pages/warnings/warning_detail_page.dart';

class WarningCard extends StatelessWidget {
  final WarningModel warning;

  const WarningCard({super.key, required this.warning});

  @override
  Widget build(BuildContext context) {
    final mustAccept = warning.mustAccept;
    final accent = mustAccept ? Palette.primary : Colors.blue;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WarningDetailPage(warning: warning)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.isDark() ? Palette.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: context.defaultShadow(),
        ),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                mustAccept
                    ? Icons.verified_user_outlined
                    : Icons.info_outline_rounded,
                color: accent,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    warning.title ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    htmlToPlainText(warning.content),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    warning.updatedDt.convert2Local(),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
