import 'dart:math';
import 'package:flutter/material.dart';
import '../services/slider_service.dart';
import '../models/slider_model.dart';
import '../../../ui/components/popup_ad_dialog.dart';

class SliderProvider extends ChangeNotifier {
  List<SliderModel> _popups = [];
  bool _isFetching = false;
  bool get isFetching => _isFetching;

  Future<void> showRandomPopup(BuildContext context) async {
    _isFetching = true;
    notifyListeners();

    try {
      _popups = await SliderService.getSliders(type: 'popup');

      if (_popups.isNotEmpty && context.mounted) {
        final randomAd = _popups[Random().nextInt(_popups.length)];
        
        await showDialog(
          context: context,
          // User must wait for the timer or use the close button.
          barrierDismissible: false,
          builder: (context) => PopupAdDialog(ad: randomAd),
        );
      }
    } catch (e) {
      debugPrint("Error fetching popups: $e");
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }
}
