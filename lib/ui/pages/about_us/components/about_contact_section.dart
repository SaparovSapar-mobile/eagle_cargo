import 'package:flutter/material.dart';
import 'package:kargoo_core/core/extensions/translate_extension.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eagle_cargo/core/api/providers/firm_provider.dart';

import 'contact_action_tile.dart';

class AboutContactSection extends StatelessWidget {
  const AboutContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final firm = context.watch<FirmProvider>().firmDetails;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('footer_contact'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (firm?.phone != null)
            ContactActionTile(
              icon: Icons.phone_in_talk_rounded,
              title: context.tr('phone'),
              value: firm!.phone!,
              color: Colors.green,
              onTap: () => launchUrl(Uri.parse('tel:${firm.phone}')),
            ),
          if (firm?.phone2 != null)
            ContactActionTile(
              icon: Icons.phone_in_talk_rounded,
              title: context.tr('phone'),
              value: firm!.phone2!,
              color: Colors.green,
              onTap: () => launchUrl(Uri.parse('tel:${firm.phone2}')),
            ),
          if (firm?.phone3 != null)
            ContactActionTile(
              icon: Icons.phone_in_talk_rounded,
              title: context.tr('phone'),
              value: firm!.phone3!,
              color: Colors.green,
              onTap: () => launchUrl(Uri.parse('tel:${firm.phone2}')),
            ),
          if (firm?.email != null)
            ContactActionTile(
              icon: Icons.alternate_email_rounded,
              title: context.tr('email'),
              value: firm!.email!,
              color: Colors.blue,
              onTap: () => launchUrl(Uri.parse('mailto:${firm.email}')),
            ),
        ],
      ),
    );
  }
}