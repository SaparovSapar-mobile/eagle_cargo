import 'package:flutter/material.dart';
import 'package:eagle_cargo/core/api/models/warehouse_model.dart';
import 'package:eagle_cargo/core/api/services/warehouse_service.dart';

import '../models/payment_info_response.dart';

/// Paginated state of one warehouse list.
class _WarehouseList {
  bool isFetching = false;
  final List<WarehouseModel> items = [];
  int total = 0;
  int page = 1;

  bool get isComplete => total > 0 && items.length >= total;

  void reset() {
    total = 0;
    page = 1;
    items.clear();
  }
}

class WarehouseProvider extends ChangeNotifier {
  final _local = _WarehouseList();
  final _foreign = _WarehouseList();
  final int _limit = 20;

  List<WarehouseModel> get warehouses => _local.items;
  int get total => _local.total;

  /// Warehouses abroad — shown in their own section.
  List<WarehouseModel> get foreignWarehouses => _foreign.items;
  int get foreignTotal => _foreign.total;

  PaymentInfoResponse? _paymentInfoResponse;
  PaymentInfoResponse? get paymentInfoResponse => _paymentInfoResponse;

  void reset() => _local.reset();

  void resetForeign() => _foreign.reset();

  /// Regular warehouses. Foreign ones are excluded here because they live in
  /// their own section.
  Future<void>? getAll({Function? onSuccess, Function? onError}) {
    return _fetch(
      _local,
      () => WarehouseService.getAll(
        limit: _limit,
        page: _local.page,
        isForeign: false,
      ),
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  Future<void>? getForeign({Function? onSuccess, Function? onError}) {
    return _fetch(
      _foreign,
      () => WarehouseService.getForeign(limit: _limit, page: _foreign.page),
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  Future<void>? _fetch(
    _WarehouseList state,
    Future<Map<String, dynamic>> Function() request, {
    Function? onSuccess,
    Function? onError,
  }) {
    if (state.isFetching || state.isComplete) return null;
    state.isFetching = true;
    return request()
        .then((v) {
          state.total = v['count'];
          state.items.addAll(v['data']);
          onSuccess?.call();
          state.isFetching = false;
          if (state.items.length < state.total) state.page++;
          notifyListeners();
        })
        .catchError((err) {
          debugPrint("$err");
          state.isFetching = false;
          onError?.call();
        });
  }

  Future<void>? getPaymentInfo() {
    return WarehouseService.getPaymentInfo()
        .then((v) {
          _paymentInfoResponse = v;
          notifyListeners();
        })
        .catchError((err) {
          debugPrint("$err");
        });
  }
}
