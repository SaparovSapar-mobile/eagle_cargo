import 'package:flutter/material.dart';
import '../../ui/pages/index.dart';
import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name == Routes.splash) {
      return MaterialPageRoute(
        builder: (_) => const SplashPage(),
        settings: settings,
      );
    } else if (settings.name == Routes.main) {
      return MaterialPageRoute(
        builder: (_) => const MainPage(),
        settings: settings,
      );
    } else if (settings.name == Routes.home) {
      return MaterialPageRoute(
        builder: (_) => const HomePage(),
        settings: settings,
      );
    } else if (settings.name == Routes.onboarding) {
      return MaterialPageRoute(
        builder: (_) => const OnboardingPage(),
        settings: settings,
      );
    } else if (settings.name == Routes.login) {
      return MaterialPageRoute(
        builder: (_) => const LoginPage(),
        settings: settings,
      );
    } else if (settings.name == Routes.register) {
      return MaterialPageRoute(
        builder: (_) => const RegisterPage(),
        settings: settings,
      );
    } else if (settings.name == Routes.profile) {
      return MaterialPageRoute(
        builder: (_) => const ProfilePage(),
        settings: settings,
      );
    } else if (settings.name == Routes.orderDetail) {
      return MaterialPageRoute(
        builder: (_) => const OrderDetailPage(),
        settings: settings,
      );
    } else if (settings.name == Routes.warehouses) {
      return MaterialPageRoute(
        builder: (_) => const WarehousesPage(),
        settings: settings,
      );
    } else if (settings.name == Routes.foreignWarehouses) {
      return MaterialPageRoute(
        builder: (_) => const WarehousesPage(isForeign: true),
        settings: settings,
      );
    } else if (settings.name == Routes.warnings) {
      return MaterialPageRoute(
        builder: (_) => const WarningsPage(),
        settings: settings,
      );
    } else if (settings.name == Routes.otp) {
      return MaterialPageRoute(
        builder: (_) => const OtpPage(phoneNumber: '123456'),
        settings: settings,
      );
    } else if (settings.name == Routes.aboutUs) {
      return MaterialPageRoute(
        builder: (_) => const AboutUsPage(),
        settings: settings,
      );
    } else if (settings.name == Routes.notificationDetail) {
      return MaterialPageRoute(builder: (_) => NotificationDetailPage());
    } else {
      return MaterialPageRoute(
        builder: (_) => ErrorRoute(routeName: settings.name.toString()),
        settings: settings,
      );
    }
    // if (settings.name?.contains('stands/') ?? false) {
    //   final segments = settings.name!.split('/');
    //   if (segments.length > 1) {
    //     final standId = segments.last; // Get the last segment as ID
    //     final arguments = CompanyDetailPageArgs(model: CompanyModel(id: int.tryParse(standId) ?? 0));

    //     return SlideLeftRoute(
    //       page: CompanyDetailPage(args: arguments), // Pass the arguments here
    //       settings: settings,
    //     );
    //   }
    // }
  }
}

class ErrorRoute extends StatelessWidget {
  final String routeName;
  const ErrorRoute({super.key, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Eagle Cargo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Text(
            routeName,
            // LocaleKeys.warning_errorOccured.tr().split('!')[1],
          ),
        ),
      ),
    );
  }
}
