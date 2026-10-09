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

  /// Opens the launch dialog and records every accepted warning.
  Future<List<String?>> openDialog(
    WidgetTester tester,
    List<WarningModel> warnings,
  ) async {
    final accepted = <String?>[];
    await tester.pumpWidget(_host(const SizedBox()));
    final context = tester.element(find.byType(SizedBox));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WarningDialog(
        warnings: warnings,
        onAccept: (w) async => accepted.add(w.warningGuid),
      ),
    );
    await tester.pumpAndSettle();
    return accepted;
  }

  ElevatedButton acceptButton(WidgetTester tester) =>
      tester.widget<ElevatedButton>(find.byType(ElevatedButton));

  testWidgets('accept dialog cannot be dismissed without accepting', (
    tester,
  ) async {
    final accepted = await openDialog(tester, [_warning(type: 'accept')]);
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

    // A short text fits without scrolling, so the button is enabled at once
    // and is the only way out.
    expect(acceptButton(tester).onPressed, isNotNull);
    expect(find.text('Read to the end to accept'), findsNothing);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(find.byType(WarningDialog), findsNothing);
    expect(accepted, ['guid-1']);
  });

  testWidgets('accept stays disabled until the text is scrolled to the end', (
    tester,
  ) async {
    final long = WarningModel.fromJson({
      'warning_guid': 'long',
      'title': 'Длинные условия',
      'content': List.generate(80, (i) => '<p>Абзац $i</p>').join(),
      'type': 'accept',
      'level': 1,
      'updated_dt': '2026-10-06T08:15:30.000Z',
    });
    final accepted = await openDialog(tester, [
      long,
      _warning(guid: 'short', type: 'accept'),
    ]);

    expect(find.text('1 of 2'), findsOneWidget);
    expect(acceptButton(tester).onPressed, isNull);
    expect(find.text('Read to the end to accept'), findsOneWidget);

    // Halfway is not enough.
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(acceptButton(tester).onPressed, isNull);

    await tester.fling(
      find.byType(SingleChildScrollView),
      const Offset(0, -20000),
      5000,
    );
    await tester.pumpAndSettle();
    expect(acceptButton(tester).onPressed, isNotNull);
    expect(find.text('Read to the end to accept'), findsNothing);

    // Saved right away, before the next warning is shown.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(accepted, ['long']);
    expect(find.text('2 of 2'), findsOneWidget);
    expect(find.byType(WarningDialog), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(accepted, ['long', 'short']);
    expect(find.byType(WarningDialog), findsNothing);
  });

  test('accepted only while updated_dt matches the stored one', () async {
    final provider = WarningProvider();
    final accepted = _warning(guid: 'accepted', type: 'accept');
    final edited = _warning(guid: 'edited', type: 'accept');
    final fresh = _warning(guid: 'fresh', type: 'accept');

    await PreferenceManager.instance.setStringValue(
      PreferenceKeys.ACCEPTED_WARNINGS,
      jsonEncode({
        'accepted': accepted.updatedDt,
        'edited': '2026-01-01T00:00:00.000Z',
      }),
    );

    expect(provider.isAccepted(accepted), isTrue);
    expect(provider.isAccepted(edited), isFalse);
    expect(provider.isAccepted(fresh), isFalse);

    await provider.accept(edited);
    expect(provider.isAccepted(edited), isTrue);
    expect(provider.isAccepted(fresh), isFalse);

    final stored = jsonDecode(
      PreferenceManager.instance.getStringValue(
        PreferenceKeys.ACCEPTED_WARNINGS,
      ),
    );
    expect(stored, {
      'accepted': accepted.updatedDt,
      'edited': edited.updatedDt,
    });
  });

  testWidgets('warnings section groups by type and marks accepted ones', (
    tester,
  ) async {
    final rules = _warning(guid: 'rules', type: 'accept');
    final provider = WarningProvider()
      ..warnings.addAll([
        rules,
        _warning(guid: 'other-rules', type: 'accept'),
        _warning(guid: 'hours'),
      ]);
    await provider.accept(rules);

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

    expect(find.text('Rules and terms'), findsOneWidget);
    expect(find.text('Information'), findsOneWidget);
    expect(find.byType(WarningCard), findsNWidgets(3));
    // Only the accepted `accept` warning carries the mark.
    expect(find.text('Accepted'), findsOneWidget);

    // Opening a card shows the full HTML text, without an accept button.
    await tester.tap(find.byType(WarningCard).first);
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Уважаемые клиенты!', findRichText: true),
      findsOneWidget,
    );
    expect(find.byType(ElevatedButton), findsNothing);
  });

  testWidgets('warnings section hides an empty group', (tester) async {
    final provider = WarningProvider()..warnings.add(_warning(guid: 'hours'));

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

    expect(find.text('Rules and terms'), findsNothing);
    expect(find.text('Information'), findsOneWidget);
  });

  test('htmlToPlainText strips tags and entities', () {
    expect(
      htmlToPlainText('<p>Склад работает&nbsp;с 9:00</p><p>до 18:00</p>'),
      'Склад работает с 9:00 до 18:00',
    );
  });
}
