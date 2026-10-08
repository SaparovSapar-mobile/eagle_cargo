import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eagle_cargo/core/api/models/slider_model.dart';

class PopupAdDialog extends StatefulWidget {
  final SliderModel ad;

  const PopupAdDialog({super.key, required this.ad});

  @override
  State<PopupAdDialog> createState() => _PopupAdDialogState();
}

class _PopupAdDialogState extends State<PopupAdDialog> {
  late int _secondsLeft;
  Timer? _timer;
  bool _canClose = false;

  @override
  void initState() {
    super.initState();
    // How long to show the slide before it can be dismissed comes from the
    // slider itself; fall back to 4s when the server leaves it unset.
    _secondsLeft = widget.ad.second ?? 4;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        setState(() {
          _canClose = true;
        });
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handleTap() async {
    final link = (widget.ad.appLink != null && widget.ad.appLink!.isNotEmpty)
        ? widget.ad.appLink!
        : widget.ad.webLink;
    if (link != null && link.isNotEmpty) {
      final url = Uri.parse(link);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        // The image keeps its own aspect ratio and is only scaled down when
        // it would not otherwise fit on screen.
        constraints: BoxConstraints(
          maxWidth: size.width * 0.9,
          maxHeight: size.height * 0.8,
        ),
        child: Stack(
          children: [
            GestureDetector(
              onTap: _handleTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: widget.ad.image ?? "",
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const SizedBox(
                    height: 300,
                    width: 300,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const SizedBox(
                    height: 300,
                    width: 300,
                    child: Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
            ),

            // Timer / Close Button
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: _canClose ? () => Navigator.pop(context) : null,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: _canClose
                      ? const Icon(Icons.close, color: Colors.white, size: 20)
                      : Text(
                          "$_secondsLeft",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
