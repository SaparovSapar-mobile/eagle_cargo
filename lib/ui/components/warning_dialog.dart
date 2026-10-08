import 'package:flutter/material.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;

import 'package:eagle_cargo/core/api/models/warning_model.dart';
import 'package:eagle_cargo/core/utils/local_translations.dart';
import 'package:eagle_cargo/core/utils/palette.dart';
import 'warning_html_content.dart';

/// Warning shown on app launch.
///
/// An `accept` warning can only be left through its button — neither the
/// barrier, nor the back gesture/button dismisses it.
class WarningDialog extends StatelessWidget {
  final WarningModel warning;

  const WarningDialog({super.key, required this.warning});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mustAccept = warning.mustAccept;

    return PopScope(
      canPop: !mustAccept,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        backgroundColor: context.isDark() ? Palette.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: size.height * 0.85),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              /// Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  crossAxisAlignment: .start,
                  children: [
                    Icon(
                      mustAccept
                          ? Icons.verified_user_outlined
                          : Icons.info_outline_rounded,
                      color: mustAccept ? Palette.primary : Colors.blue,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        warning.title ?? '',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              /// Body — the text can be very long, so it scrolls while the
              /// action button below stays visible.
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: WarningHtmlContent(html: warning.content ?? ''),
                ),
              ),
              const Divider(height: 1),

              /// Action
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mustAccept
                        ? Palette.primaryLight
                        : Colors.grey.shade200,
                    foregroundColor: mustAccept ? Colors.white : Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    mustAccept
                        ? context.tl('mb_warning_accept')
                        : context.tr('close'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
