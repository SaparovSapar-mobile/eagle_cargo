import 'package:flutter/material.dart';
import 'package:eagle_cargo/core/api/models/notification_model.dart';
import 'package:eagle_cargo/core/api/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final List<NotificationModel> _list = [];
  List<NotificationModel> get list => _list;
  NotificationModel? _current;
  NotificationModel? get current => _current;
  bool isFetching = false;
  int _total = 0;
  int get total => _total;
  int _page = 1;
  final int _limit = 20;
  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  void reset() {
    _list.clear();
    _page = 1;
    _total = 0;
  }

  Future<void>? getAll({Function? onDone, Function? onError}) {
    if (isFetching || (_total > 0 && _list.length >= _total)) return null;
    isFetching = true;
    return NotificationService.getAll(limit: _limit, page: _page)
        .then((v) {
          _list.addAll(v['data']);
          _total = v['count'];
          if (_list.length < _total) _page++;
          isFetching = false;
          onDone?.call();
          notifyListeners();
        })
        .catchError((err) {
          isFetching = false;
          debugPrint("$err");
          onDone?.call();
          notifyListeners();
        });
  }

  Future<void>? getOne({String? guid, Function? onDone, Function? onError}) {
    if (guid == null) return null;
    return NotificationService.getOne(guid: guid)
        .then((v) {
          _current = v;
          onDone?.call();
          markAsRead.call();
          notifyListeners();
        })
        .catchError((err) {
          debugPrint("$err");
          onError?.call();
          return null;
        });
  }

  Future<void>? markAsRead() {
    if (current == null || current?.guid == null) return null;
    return NotificationService.markAsRead(guid: current!.guid!).catchError((
      err,
    ) {
      debugPrint("$err");
      return false;
    });
  }

  Future<void>? getUnreadCount() {
    return NotificationService.getUnreadCount()
        .then((v) {
          _unreadCount = v;
          notifyListeners();
        })
        .catchError((err) {});
  }
}
