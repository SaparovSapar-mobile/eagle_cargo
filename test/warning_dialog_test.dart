import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kargoo_core/kargoo_core.dart' as core;

import 'package:eagle_cargo/core/api/models/warning_model.dart';
import 'package:eagle_cargo/core/api/providers/warning_provider.dart';
import 'package:eagle_cargo/core/preferences/preference_keys.dart';
import 'package:eagle_cargo/core/preferences/preferences_util.dart';
import 'package:eagle_cargo/ui/components/warning_dialog.dart';
import 'package:eagle_cargo/ui/components/warning_html_content.dart';
import 'package:eagle_cargo/ui/pages/warnings/components/warning_card.dart';
import 'package:eagle_cargo/ui/pages/warnings/warnings_page.dart';

WarningModel _warning({
  String type = 'info',
  String guid = 'guid-1',
  String updated = '2026-10-06T08:15:30.000Z',
}) => WarningModel.fromJson({
  'warning_guid': guid,
  'title': 'Условия перевозки',
  'content':
      '<p><strong>Уважаемые клиенты!</strong></p><ul><li>Пункт один</li></ul>',
  'type': type,
  'level': 1,
  'updated_dt': updated,
});

Widget _host(Widget child) => MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => core.ThemeProvider()),
    ChangeNotifierProvider(create: (_) => core.TranslationProvider()),
  ],
  child: MaterialApp(home: child),
);

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferenceManager.ensureInitialized();
    await core.PreferenceManager.init();
  });

  testWidgets('renders the HTML body instead of raw tags', (tester) async {
    await tester.pumpWidget(
      _host(
        Scaffold(
          body: WarningHtmlContent(html: _warning().content!),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // fwfh paints rich text, so the spans have to be searched too.
    expect(
      find.textContaining('Уважаемые клиенты!', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Пункт один', findRichText: true),
      findsOneWidget,
    );
    expect(find.textContaining('<strong>', findRichText: true), findsNothing);
  });

  testWidgets('renders the tag set the web editor can produce', (tester) async {
    const kitchenSink = '''
<h2 style="text-align: center">Заголовок</h2>
<p style="text-align: right"><em>Курсив</em>, <u>подчёркнутый</u>, <s>зачёркнутый</s></p>
<p><span style="color: #ff0000">Красный</span> и <mark>выделенный</mark></p>
<ol><li>Первый</li><li>Второй</li></ol>
<blockquote>Цитата</blockquote>
<pre><code>код()</code></pre>
<hr>
<p><a href="https://example.com">Ссылка</a></p>
''';

    await tester.pumpWidget(
      _host(
        Scaffold(
          body: SingleChildScrollView(
            child: const WarningHtmlContent(html: kitchenSink),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    for (final text in [
      'Заголовок',
      'Курсив',
      'подчёркнутый',
      'зачёркнутый',
      'Красный',
      'выделенный',
      'Первый',
      'Второй',
      'Цитата',
      'код()',
      'Ссылка',
    ]) {
      expect(
        find.textContaining(text, findRichText: true),
        findsWidgets,
        reason: 'missing rendered text: $text',
      );
    }
    expect(find.textContaining('<span', findRichText: true), findsNothing);
    expect(find.textContaining('text-align', findRichText: true), findsNothing);
  });

  testWidgets('accept warning cannot be dismissed without its button', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const SizedBox()));
    final context = tester.element(find.byType(SizedBox));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WarningDialog(warning: _warning(type: 'accept')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(WarningDialog), findsOneWidget);

    // Tapping outside the dialog keeps it open.
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.byType(WarningDialog), findsOneWidget);

    // Back gesture is blocked as well.
    final popped = await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(popped, isTrue);
    expect(find.byType(WarningDialog), findsOneWidget);

    // Only the button closes it.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(find.byType(WarningDialog), findsNothing);
  });

  test('pending keeps new and edited warnings only', () async {
    final provider = WarningProvider();
    final seen = _warning(guid: 'seen');
    final edited = _warning(guid: 'edited');
    final fresh = _warning(guid: 'fresh');

    await PreferenceManager.instance.setStringValue(
      PreferenceKeys.SEEN_WARNINGS,
      jsonEncode({
        'seen': seen.updatedDt,
        'edited': '2026-01-01T00:00:00.000Z',
      }),
    );
    provider.warnings.addAll([seen, edited, fresh]);

    expect(
      provider.pending.map((e) => e.warningGuid),
      ['edited', 'fresh'],
    );

    await provider.markSeen(edited);
    expect(provider.pending.map((e) => e.warningGuid), ['fresh']);
  });

  testWidgets('warnings section splits the list by type', (tester) async {
    final provider = WarningProvider()
      ..warnings.addAll([
        _warning(guid: 'rules', type: 'accept'),
        _warning(guid: 'hours'),
      ]);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => core.ThemeProvider()),
          ChangeNotifierProvider(create: (_) => core.TranslationProvider()),
          ChangeNotifierProvider<WarningProvider>.value(value: provider),
        ],
        child: const MaterialApp(home: WarningsPage()),
      ),
    );
    await tester.pumpAndSettle();

    // One card per tab: the `accept` one here, the `info` one after switching.
    expect(find.byType(WarningCard), findsOneWidget);
    await tester.tap(find.byType(Tab).last);
    await tester.pumpAndSettle();
    expect(find.byType(WarningCard), findsOneWidget);

    // Opening a card shows the full HTML text.
    await tester.tap(find.byType(WarningCard));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Уважаемые клиенты!', findRichText: true),
      findsOneWidget,
    );

    // The refresh request fails under the test binding, which raises an error
    // toast; let its auto-close timer finish before the tree is disposed.
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
  });

  test('htmlToPlainText strips tags and entities', () {
    expect(
      htmlToPlainText('<p>Склад работает&nbsp;с 9:00</p><p>до 18:00</p>'),
      'Склад работает с 9:00 до 18:00',
    );
  });
}
