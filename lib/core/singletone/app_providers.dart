import 'package:eagle_cargo/core/api/providers/index.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ApplicationProvider {
  ApplicationProvider._init();
  static ApplicationProvider? _instance;
  static ApplicationProvider? get instance {
    _instance ??= ApplicationProvider._init();
    return _instance;
  }

  List<SingleChildWidget> allProviders = [
    ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
    ChangeNotifierProvider<FirebaseTopicsProvider>(
      create: (_) => FirebaseTopicsProvider(),
    ),
    ChangeNotifierProvider<TranslationProvider>(
      create: (_) => TranslationProvider(),
    ),
    ChangeNotifierProvider<WarehouseProvider>(
      create: (_) => WarehouseProvider(),
    ),
    ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),
    ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
    ChangeNotifierProvider<NotificationProvider>(
      create: (_) => NotificationProvider(),
    ),
    ChangeNotifierProvider<FirmProvider>(create: (_) => FirmProvider()),
    ChangeNotifierProvider<SliderProvider>(create: (_) => SliderProvider()),
    ChangeNotifierProvider<WarningProvider>(create: (_) => WarningProvider()),
  ];
}
