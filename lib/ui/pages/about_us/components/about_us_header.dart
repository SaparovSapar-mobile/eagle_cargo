import 'package:flutter/material.dart';
import 'package:kargoo_core/core/extensions/theme_extension.dart';
import 'package:eagle_cargo/core/api/api.dart';
import 'package:eagle_cargo/core/api/models/firm_detail_response.dart';

class AboutUsHeader extends StatelessWidget {
  final FirmDetailResponse? firm;
  const AboutUsHeader({super.key, this.firm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 20),
      child: Center(
        child: Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            // Thinner, cleaner border for white backgrounds
            border: Border.all(
              color: context.isDark() ? Colors.white10 : Colors.white,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:  0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipOval(
            child: firm?.image != null
                ? Image.network(
                    "http://${API.authority}/uploads${firm!.image!}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/app_logo.jpg',
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset('assets/images/app_logo.jpg', fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}