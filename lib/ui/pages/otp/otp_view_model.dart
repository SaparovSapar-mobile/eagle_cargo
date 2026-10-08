import 'package:flutter/material.dart';
import 'otp_page.dart';
import 'dart:async';

import 'package:provider/provider.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:eagle_cargo/core/api/providers/auth_provider.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/extensions/toaster_extension.dart';
import 'package:eagle_cargo/core/routes/routes.dart';

abstract class OtpViewModel extends State<OtpPage> {
     static int otpLength = 4;

  final List<TextEditingController> controllers = List.generate(
    otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(
    otpLength,
    (_) => FocusNode(),
  );

  // Timer logic
  Timer? pageTimer; // Timer to show resend button after 60 seconds
  Timer? countdownTimer; // Countdown timer for resend button
  bool canResend = false;
  int remainingSeconds = 60;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _listenForSms();
  }

  // Shows the system "Allow [App] to read this message?" dialog (SMS User
  // Consent API) and auto-fills the code once the user approves it. Works
  // with any SMS sender/format, unlike the SMS Retriever API which requires
  // the backend to append an app-specific hash to the message text.
  Future<void> _listenForSms() async {
    final result = await SmartAuth.instance.getSmsWithUserConsentApi();
    if (!mounted) return;

    final digits = result.data?.code;
    if (digits == null || digits.length != otpLength) return;

    for (var i = 0; i < otpLength; i++) {
      controllers[i].text = digits[i];
    }
    submit();
  }

  void _startCountdown() {
    canResend = false;
    remainingSeconds = 60; // or 90 if you prefer longer initial wait

    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        setState(() {
          canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void resendOtp() {
    if (!canResend) return;

    context.read<AuthProvider>().resendOtp();

    // Restart cooldown after successful resend
    _startCountdown();

    // Optional: give feedback
    context.showSuccessToast(description: context.tr('success'));
  }

  String get resendButtonText {
    if (canResend) {
      return context.tr('mb_resend_otp');
    } else {
      int minutes = remainingSeconds ~/ 60;
      int seconds = remainingSeconds % 60;
      return "${context.tr('mb_resend_in')} $minutes:${seconds.toString().padLeft(2, '0')}";
    }
  }

  void submit() {
    final otp = controllers.map((c) => c.text).join();
    if (otp.length == otpLength) {
      context.read<AuthProvider>().verify(
        otp: otp,
        phone: widget.phoneNumber,
        onRegisterRequired: () {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacementNamed(context, Routes.register);
        },
        onSuccess: () {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacementNamed(context, Routes.main);
        },
        onError: () {
          context.showErrorToast(description: context.tr('mb_error_occured'));
        },
      );
    } else {
      context.showErrorToast(
        description: context.tr('mb_enter_8_digit_number').replaceAll('8', '4'),
      );
    }
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    pageTimer?.cancel();
    countdownTimer?.cancel();
    SmartAuth.instance.removeUserConsentApiListener();
    super.dispose();
  }
}
