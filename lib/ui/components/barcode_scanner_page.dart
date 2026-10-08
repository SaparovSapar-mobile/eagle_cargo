import 'package:flutter/material.dart';
import 'package:kargoo_core/kargoo_core.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:eagle_cargo/ui/widgets/appbars/default_appbar.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.all],
  );

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: context.tr('mb_scan_barcode'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, state, child) {
                switch (state.torchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                  case TorchState.auto:
                  case TorchState.unavailable:
                    return const Icon(Icons.flash_off, color: Colors.red);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.cameraswitch),
            iconSize: 32.0,
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && !_isDisposed) {
            final String? code = barcodes.first.rawValue;
            if (code != null) {
              _isDisposed = true; // Prevent multiple results
              Navigator.pop(context, code);
            }
          }
        },
      ),
    );
  }
}
