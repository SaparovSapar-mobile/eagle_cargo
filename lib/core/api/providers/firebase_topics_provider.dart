import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:eagle_cargo/core/preferences/preference_keys.dart';
import 'package:eagle_cargo/core/preferences/preferences_util.dart';

class FirebaseTopicsProvider extends ChangeNotifier {
  final PreferenceManager cache = PreferenceManager.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  List<String> _topics = [];
  List<String> get topics => _topics;

  void loadTopics() {
    _topics = cache.getStringList(PreferenceKeys.TOPICS);
  }

  Future<void> addTopic(String topic) async {
    if (!_topics.contains(topic)) {
      _topics.add(topic);
      await messaging
          .subscribeToTopic(topic)
          .then((e) {
            _saveTopics();
          })
          .onError((e, _) {
            debugPrint(e.toString());
          });
      notifyListeners();
    }
  }

  Future<void> removeTopic(String topic) async {
    _topics.remove(topic);
    await _saveTopics();
    notifyListeners();
  }

  Future<void> unsubscribeFromAll({Function? onDone}) async {
    // ignore: avoid_function_literals_in_foreach_calls
    _topics.forEach((e) async {
      await messaging.unsubscribeFromTopic(e);
      await removeTopic(e);
    });
    await _saveTopics();
    onDone?.call();
    notifyListeners();
  }

  Future<void> _saveTopics() async {
    await cache.setStringList(PreferenceKeys.TOPICS, _topics);
  }
}
