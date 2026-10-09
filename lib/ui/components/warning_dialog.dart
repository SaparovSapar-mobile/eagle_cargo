import 'package:flutter/material.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;

import 'package:eagle_cargo/core/api/models/warning_model.dart';
import 'package:eagle_cargo/core/utils/local_translations.dart';
import 'package:eagle_cargo/core/utils/palette.dart';
import 'warning_html_content.dart';

/// Launch dialog walking the client through the `accept` warnings, one at a
/// time, in the given order.
///
/// It can only be left by accepting every warning — neither the barrier, nor
/// the back button/gesture dismisses it — and each "I accept" stays disabled
/// until the text was scrolled to the end.
class WarningDialog extends StatefulWidget {
  final List<WarningModel> warnings;

  /// Persists the consent; called for each warning as soon as it is accepted.
  final Future<void> Function(WarningModel warning) onAccept;

  const WarningDialog({
    super.key,
    required this.warnings,
    required this.onAccept,
  });

  @override
  State<WarningDialog> createState() => _WarningDialogState();
}

class _WarningDialogState extends State<WarningDialog> {
  /// How close to the bottom counts as "read to the end".
  static const _endTolerance = 20.0;

  final _scrollController = ScrollController();
  int _index = 0;
  bool _reachedEnd = false;
  bool _isSaving = false;

  /// Set while switching to the next warning: until the new text is laid
  /// out, scroll metrics still describe the previous one.
  bool _awaitingLayout = true;

  WarningModel get _current => widget.warnings[_index];

  @override
  void initState() {
    super.initState();
    _checkEndAfterLayout();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// A short text that fits without scrolling is accepted right away.
  void _checkEndAfterLayout() {
    _awaitingLayout = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _awaitingLayout = false;
      _checkEnd();
    });
  }

  void _checkEnd() {
    if (_reachedEnd || _awaitingLayout || !mounted) return;
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.maxScrollExtent - position.pixels <= _endTolerance) {
      setState(() => _reachedEnd = true);
    }
  }

  Future<void> _onAccept() async {
    setState(() => _isSaving = true);
    await widget.onAccept(_current);
    if (!mounted) return;

    if (_index == widget.warnings.length - 1) {
      Navigator.pop(context);
      return;
    }
    _checkEndAfterLayout();
    setState(() {
      _index++;
      _reachedEnd = false;
      _isSaving = false;
    });
    _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final total = widget.warnings.length;

    return PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        backgroundColor: context.isDark() ? Palette.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: size.height * 0.8),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              /// Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    if (total > 1) ...[
                      Text(
                        context
                            .tl('mb_warning_counter')
                            .replaceAll('{n}', '${_index + 1}')
                            .replaceAll('{total}', '$total'),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    Row(
                      crossAxisAlignment: .start,
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          color: Palette.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _current.title ?? '',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              /// Body — the text can be very long, so it scrolls while the
              /// action button below stays visible. Metrics notifications
              /// also cover HTML that grows after the first layout.
              Flexible(
                child: NotificationListener<ScrollMetricsNotification>(
                  onNotification: (_) {
                    _checkEnd();
                    return false;
                  },
                  child: NotificationListener<ScrollUpdateNotification>(
                    onNotification: (_) {
                      _checkEnd();
                      return false;
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: WarningHtmlContent(
                        key: ValueKey(_current.warningGuid),
                        html: _current.content ?? '',
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),

              /// Action
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .stretch,
                  children: [
                    if (!_reachedEnd) ...[
                      Text(
                        context.tl('mb_warning_read_to_end'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primaryLight,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _reachedEnd && !_isSaving ? _onAccept : null,
                      child: Text(
                        context.tl('mb_warning_accept'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
