import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kargoo_core/kargoo_core.dart' as core;

import 'package:eagle_cargo/core/api/models/package_model.dart';
import 'package:eagle_cargo/core/preferences/preferences_util.dart';
import 'package:eagle_cargo/core/utils/utc_format_extenstion.dart';
import 'package:eagle_cargo/ui/pages/order_detail/components/order_detail_route.dart';

Map<String, dynamic> _checkpoint(
  int sequence,
  String emoji,
  String code,
  String nameEn, {
  String? arrived,
  bool passed = false,
  bool current = false,
}) => {
  'location_guid': 'guid-$code',
  'sequence': sequence,
  'emoji': emoji,
  'code': code,
  'name': '$nameEn TK',
  'title': {
    'base': {'title_tk': '$nameEn TK', 'title_ru': '$nameEn RU', 'title_en': nameEn},
  },
  'arrived_dt': arrived,
  'is_passed': passed,
  'is_current': current,
};

const _uzArrived = '2026-10-10T11:29:57.789Z';

Map<String, dynamic> _onTheWay() {
  final uz = _checkpoint(2, '🇺🇿', 'UZ', 'Uzbekistan',
      arrived: _uzArrived, current: true);
  return {
    'current': uz,
    'checkpoints': [
      _checkpoint(1, '🇨🇳', 'CN', 'China',
          arrived: '2026-10-08T06:00:00.000Z', passed: true),
      uz,
      _checkpoint(3, '🇹🇲', 'TM', 'Turkmenistan'),
    ],
  };
}

Widget _host(Widget child) => MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => core.ThemeProvider()),
    ChangeNotifierProvider(create: (_) => core.TranslationProvider()),
  ],
  child: MaterialApp(home: Scaffold(body: child)),
);

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferenceManager.ensureInitialized();
    await core.PreferenceManager.init();
  });

  group('parsing', () {
    test('reads the route next to shipments', () {
      final package = PackageModel.fromJson({
        'package_guid': 'p1',
        'status': 'in_transit',
        'route': _onTheWay(),
      });
      final route = package.route!;

      expect(route.isEmpty, isFalse);
      expect(route.checkpoints.map((e) => e.code), ['CN', 'UZ', 'TM']);
      expect(route.current?.code, 'UZ');
      expect(route.checkpoints[0].isPassed, isTrue);
      expect(route.checkpoints[1].isCurrent, isTrue);
      expect(route.checkpoints[2].arrivedDt, isNull);
      expect(route.checkpoints[1].sequence, 2);
    });

    test('an empty route and a missing one are both "no route"', () {
      final empty = PackageModel.fromJson({
        'route': {'current': null, 'checkpoints': []},
      });
      expect(empty.route!.isEmpty, isTrue);
      expect(empty.route!.current, isNull);

      expect(PackageModel.fromJson({}).route, isNull);
    });

    test('localized name falls back to name, then code', () {
      final full = RouteCheckpoint.fromJson(
        _checkpoint(1, '🇨🇳', 'CN', 'China'),
      );
      expect(full.localizedName('ru'), 'China RU');
      expect(full.localizedName('en'), 'China');
      expect(full.localizedName('kk'), 'China TK');

      final bare = RouteCheckpoint.fromJson({'code': 'UZ', 'emoji': null});
      expect(bare.localizedName('en'), 'UZ');
      expect(bare.mark, 'UZ');
    });
  });

  group('widget', () {
    testWidgets('on the way: passed ✓, current highlighted, rest grey', (
      tester,
    ) async {
      final route = ShipmentRoute.fromJson(_onTheWay());
      await tester.pumpWidget(_host(OrderDetailRoute(route: route)));

      expect(find.text('🇨🇳 China'), findsOneWidget);
      expect(find.text('🇺🇿 Uzbekistan'), findsOneWidget);
      expect(find.text('🇹🇲 Turkmenistan'), findsOneWidget);

      // One passed country → one check mark.
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(
        find.text('Now here · ${_uzArrived.convert2Local()}'),
        findsOneWidget,
      );

      final current = tester.widget<Text>(find.text('🇺🇿 Uzbekistan'));
      expect(current.style?.fontWeight, FontWeight.bold);
      final upcoming = tester.widget<Text>(find.text('🇹🇲 Turkmenistan'));
      expect(upcoming.style?.color, Colors.grey[500]);
    });

    testWidgets('not departed: all grey, no "Now here"', (tester) async {
      final route = ShipmentRoute.fromJson({
        'current': null,
        'checkpoints': [
          _checkpoint(1, '🇨🇳', 'CN', 'China'),
          _checkpoint(2, '🇹🇲', 'TM', 'Turkmenistan'),
        ],
      });
      await tester.pumpWidget(_host(OrderDetailRoute(route: route)));

      expect(find.byIcon(Icons.check), findsNothing);
      expect(find.textContaining('Now here'), findsNothing);
      expect(
        tester.widget<Text>(find.text('🇨🇳 China')).style?.color,
        Colors.grey[500],
      );
    });

    testWidgets('a skipped passed country shows no date; no flag → code', (
      tester,
    ) async {
      final route = ShipmentRoute.fromJson({
        'checkpoints': [
          {
            ..._checkpoint(1, '', 'CN', 'China', passed: true),
            'emoji': null,
          },
          _checkpoint(2, '🇹🇲', 'TM', 'Turkmenistan',
              arrived: _uzArrived, current: true),
        ],
      });
      await tester.pumpWidget(_host(OrderDetailRoute(route: route)));

      expect(find.text('CN China'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      // Only the current country carries a date.
      expect(find.textContaining(_uzArrived.convert2Local()), findsOneWidget);
    });
  });
}
