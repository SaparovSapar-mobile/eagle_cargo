import 'package:flutter/material.dart';
import 'package:eagle_cargo/core/api/models/warning_model.dart';
import 'package:eagle_cargo/core/utils/utc_format_extenstion.dart';
import 'package:eagle_cargo/ui/components/warning_html_content.dart';
import 'package:eagle_cargo/ui/widgets/appbars/default_appbar.dart';

class WarningDetailPage extends StatelessWidget {
  final WarningModel warning;

  const WarningDetailPage({super.key, required this.warning});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: warning.title ?? ''),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              warning.title ?? '',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              warning.updatedDt.convert2Local(),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 16),
            WarningHtmlContent(html: warning.content ?? ''),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
