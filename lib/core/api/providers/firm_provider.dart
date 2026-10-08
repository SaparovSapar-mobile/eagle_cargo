import 'package:flutter/material.dart';
import 'package:eagle_cargo/core/api/models/firm_detail_response.dart';
import 'package:eagle_cargo/core/api/models/firm_rate_model.dart';

import '../services/firm_service.dart';

class FirmProvider extends ChangeNotifier {
  bool isFetching = false;
  FirmDetailResponse? _firmDetails;
  FirmDetailResponse? get firmDetails => _firmDetails;

  List<FirmRateModel> _firmRates = [];
  List<FirmRateModel> get firmRates => _firmRates;

  void getFirmDetails({Function? onDone, Function? onError}) async {
    isFetching = true;
    notifyListeners();
    return FirmService.getFirmDetails()
        .then((v) {
          _firmDetails = v;
          notifyListeners();
          if (onDone != null) onDone();
        })
        .catchError((err) {
          debugPrint("$err");
          if (onError != null) onError();
        })
        .whenComplete(() {
          isFetching = false;
          notifyListeners();
        });
  }

  void getFirmRates({Function? onDone, Function? onError}) async {
    isFetching = true;
    notifyListeners();
    return FirmService.getFirmRates()
        .then((v) {
          _firmRates = v;
          notifyListeners();
          if (onDone != null) onDone();
        })
        .catchError((err) {
          debugPrint("$err");
          if (onError != null) onError();
        })
        .whenComplete(() {
          isFetching = false;
          notifyListeners();
        });
  }
}
