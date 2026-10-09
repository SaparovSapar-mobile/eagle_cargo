import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:eagle_cargo/core/remote_config/index.dart';
import 'package:eagle_cargo/core/routes/generator.dart';
import 'package:eagle_cargo/core/routes/routes.dart';
import 'package:eagle_cargo/core/singletone/app_providers.dart';
import 'package:eagle_cargo/core/use_case/no_network_widget.dart';
import 'package:eagle_cargo/core/utils/dev_constants.dart';
import 'package:eagle_cargo/core/utils/palette.dart';
import 'package:eagle_cargo/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:kargoo_core/kargoo_core.dart' as core hide Palette;
import 'package:eagle_cargo/core/preferences/preferences_util.dart';
import 'package:eagle_cargo/core/api/providers/index.dart';

Future<void> main({bool isTestMode = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await _init();
  runApp(
    MultiProvider(
      providers: ApplicationProvider.instance?.allProviders ?? [],
      child: const MyApp(),
    ),
  );
}

Future<void> _init({bool isTestMode = false}) async {
  core.BaseClient.defaultHeaders = {'X-headers-app': 'eagle-cargo'};
  await PreferenceManager.ensureInitialized();
  await core.PreferenceManager.init();
  if (isTestMode) return;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await RemoteConfigService().initialize();
  await DevConstants.initAppVersion();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final translationProvider = context.watch<TranslationProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Flip the whole UI for right-to-left languages (fa / ar / ur).
        return Directionality(
          textDirection: translationProvider.textDirection,
          child: Scaffold(
            body: Column(
              children: [
                Expanded(child: child ?? const SizedBox()),
                const NoNetworkWidget(),
              ],
            ),
          ),
        );
      },
      // Locale for the built-in widgets (date picker, system dialogs) only.
      // A language Flutter has no Material strings for — `tk`, `tg` — resolves
      // to its fallback instead, so those widgets never break.
      locale: translationProvider.materialLocale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: core.kMaterialSupportedLanguageCodes.map(Locale.new),
      title: 'Eagle Cargo',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Palette.primary,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Palette.primaryDark,
        useMaterial3: true,
      ),
      initialRoute: Routes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
