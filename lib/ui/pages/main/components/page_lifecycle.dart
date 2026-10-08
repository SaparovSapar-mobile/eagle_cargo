import 'package:flutter/material.dart';

mixin PageLifecycle<T extends StatefulWidget> on State<T> {
  void onPageVisible() {}
}
