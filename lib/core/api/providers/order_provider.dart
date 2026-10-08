import 'package:flutter/material.dart';
import 'package:eagle_cargo/core/api/models/order_model.dart';
import 'package:eagle_cargo/core/api/models/package_model.dart';
import 'package:eagle_cargo/core/api/services/order_service.dart';

//status: [pending, confirmed, completed]
class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;
  PackageModel? _searchResult;
  PackageModel? get searchResult => _searchResult;
  PackageModel? _current;
  PackageModel? get current => _current;
  bool _isFetching = false;
  bool get isFetching => _isFetching;
  int _total = 0;
  int get total => _total;
  int _page = 1;
  final int _limit = 20;
  Map<String, dynamic> _query = {};
  set query(Map<String, dynamic> q) {
    _query = q;
    notifyListeners();
  }

  void reset() {
    _page = 1;
    _orders.clear();
    _query.clear();
  }

  Future<void>? trackOrder({
    String? orderNumber,
    Function? onSuccess,
    Function? onNotFound,
    Function? onError,
  }) {
    _searchResult = null;
    notifyListeners();
    if (orderNumber == null || orderNumber.isEmpty) return null;
    return OrderService.searchPackage(orderNumber: orderNumber)
        .then((val) {
          if (val['status'] == 404) {
            onNotFound?.call();
            return;
          }
          _searchResult = val['data'] as PackageModel?;
          notifyListeners();
          onSuccess?.call();
        })
        .catchError((err) {
          debugPrint("$err");
          onError?.call();
        });
  }

  Future<void>? getOne({
    String? orderNumber,
    Function? onSuccess,
    Function? onNotFound,
    Function? onError,
  }) {
    if (orderNumber == null || orderNumber.isEmpty) return null;
    return OrderService.searchPackage(orderNumber: orderNumber)
        .then((val) {
          if (val['status'] == 404) {
            onNotFound?.call();
            return;
          }

          _current = val['data'] as PackageModel?;
          notifyListeners();
          onSuccess?.call();
        })
        .catchError((err) {
          debugPrint("$err");
          onError?.call();
        });
  }

  Future<void>? getOrders({Function? onSuccess, Function? onError}) {
    if (_isFetching || (_total > 0 && _orders.length >= _total)) return null;
    _isFetching = true;
    return OrderService.getOrders(
          limit: _limit,
          page: _page,
          params: Map<String, dynamic>.from(_query),
        )
        .then((val) {
          _orders.addAll(val['data']);
          _total = val['count'];
          if (_orders.length < _total) _page++;
          onSuccess?.call();
          _isFetching = false;
          notifyListeners();
        })
        .catchError((err) {
          debugPrint('$err');
          onError?.call();
          _isFetching = false;
          notifyListeners();
        });
  }
}
