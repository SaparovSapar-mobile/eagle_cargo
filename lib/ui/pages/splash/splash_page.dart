// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:eagle_cargo/ui/pages/splash/splash_view_model.dart';
import 'splash_components/splash_elements.dart';
import 'splash_components/splash_no_internet.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends SplashViewModel {
  // -----------------------------
  // UI
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    if (apiError) {
      return Scaffold(
        body: SplashNoInternet(
          onRetry: () {
            setState(() {
              apiError = false;
            });
            startAppFlow();
          },
        ),
      );
    }

    return Scaffold(
      body: FutureBuilder(
        future: hasInternet(),
        builder: (context, snap) {
          if (!snap.hasData || snap.data == true) {
            return const SplashElements();
          } else {
            return SplashNoInternet(onRetry: startAppFlow);
          }
        },
      ),
    );
  }
}
