import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/utils/palette.dart';

class LanguagesBottomSheet extends StatelessWidget {
  const LanguagesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: context.isDarkRead() ? Palette.darkSurface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: .min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            ListTile(
              leading: Text(
                '🇹🇲',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              onTap: () {
                context.read<TranslationProvider>().setLanguage(AppLanguage.tm);
                Navigator.pop(context);
              },
              title: Text('Türkmençe'),
            ),
            ListTile(
              leading: Text(
                '🇷🇺',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              onTap: () {
                context.read<TranslationProvider>().setLanguage(AppLanguage.ru);
                Navigator.pop(context);
              },
              title: Text('Русский'),
            ),
            ListTile(
              leading: Text(
                '🇬🇧',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              onTap: () {
                context.read<TranslationProvider>().setLanguage(AppLanguage.en);
                Navigator.pop(context);
              },
              title: Text('English'),
            ),
            SizedBox(height: kToolbarHeight / 2),
          ],
        ),
      ),
    );
  }
}
