import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

extension ToastExtension on BuildContext {
  void showInfoToast({String? title, String? description}) {
    if (!mounted) return;
    toastification.show(
      context: this,
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      title: title != null ? Text(title) : null,
      description: description != null ? Text(description, style: TextStyle(fontWeight: FontWeight.w600),) : null,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      boxShadow: lowModeShadow,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  void showErrorToast({String? title, String? description}) {
    if (!mounted) return;
    toastification.show(
      context: this,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: title != null ? Text(title) : null,
      description: description != null ? Text(description, style: TextStyle(fontWeight: FontWeight.w600),) : null,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      boxShadow: lowModeShadow,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  void showSuccessToast({String? title, String? description}) {
    if (!mounted) return;
    toastification.show(
      context: this,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: title != null ? Text(title) : null,
      description: description != null ? Text(description, style: TextStyle(fontWeight: FontWeight.w600),) : null,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      boxShadow: lowModeShadow,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }
}
