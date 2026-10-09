import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/utils/palette.dart';

/// Language picker.
///
/// The list comes from `GET /api/v1/translations/languages` through
/// [TranslationProvider] — base languages first, then the ones this firm has
/// enabled, in the order the server sent them. Names are shown exactly as
/// served (written in the language itself) and are never translated.
class LanguagesBottomSheet extends StatelessWidget {
  const LanguagesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TranslationProvider>();
    final languages = provider.languages;

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
            if (languages.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CircularProgressIndicator(),
              )
            else
              // A firm can enable more languages than fit on screen, so the
              // list scrolls inside the sheet instead of overflowing it.
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final language = languages[index];
                    return ListTile(
                      leading: Text(
                        language.flag,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      title: Text(language.name),
                      trailing: language.code == provider.currentCode
                          ? const Icon(Icons.check_rounded)
                          : null,
                      onTap: () {
                        provider.setLanguageCode(language.code);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            SizedBox(height: kToolbarHeight / 2),
          ],
        ),
      ),
    );
  }
}
