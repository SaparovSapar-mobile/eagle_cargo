import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kargoo_core/core/extensions/translate_extension.dart';
import 'package:eagle_cargo/core/utils/palette.dart';

enum _ButtonRole { cancel, yes, close }

enum CustomADActionCombination { onlyClose, onlyOk, yesno }

class _ButtonDef {
  final _ButtonRole role;
  final String l10nKey;
  final bool isPrimary; // New: to distinguish between outlined and filled

  const _ButtonDef(this.role, this.l10nKey, {this.isPrimary = true});

  static const _mapping = <CustomADActionCombination, List<_ButtonDef>>{
    CustomADActionCombination.onlyClose: [
      _ButtonDef(_ButtonRole.close, 'close'),
    ],
    CustomADActionCombination.onlyOk: [_ButtonDef(_ButtonRole.close, 'mb_ok')],
    CustomADActionCombination.yesno: [
      _ButtonDef(_ButtonRole.cancel, 'cancel', isPrimary: false),
      _ButtonDef(_ButtonRole.yes, 'mb_submit'),
    ],
  };
}

class CustomAlertDialog extends StatelessWidget {
  final String? titleText, contentText;
  final Widget? titleWidget, contentWidget;
  final CustomADActionCombination actionCombination;
  final Function()? onSubmit;

  const CustomAlertDialog({
    super.key,
    this.titleText,
    required this.actionCombination,
    this.contentText,
    this.titleWidget,
    this.contentWidget,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = _ButtonDef._mapping[actionCombination]!;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              if (titleText != null || titleWidget != null) ...[
                titleWidget ??
                    Text(
                      titleText ?? '',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                const SizedBox(height: 12),
              ],

              // Content
              contentWidget ??
                  Text(
                    contentText ?? '',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
              const SizedBox(height: 24),

              // Dynamic Buttons
              Row(
                children: buttons.map((def) {
                  final bool isFirst = buttons.indexOf(def) == 0;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: isFirst ? 0 : 12),
                      child: _buildActionButton(context, def),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, _ButtonDef def) {
    final bool isFilled = def.isPrimary;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        if (def.role == _ButtonRole.yes) {
          onSubmit?.call();
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isFilled ? Palette.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isFilled
              ? null
              : Border.all(color: Palette.primary, width: 2),
        ),
        child: Text(
          context.tr(def.l10nKey),
          style: TextStyle(
            color: isFilled ? Colors.white : (Palette.primary),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
