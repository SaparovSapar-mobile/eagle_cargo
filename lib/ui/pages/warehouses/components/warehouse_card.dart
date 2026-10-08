// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/api/models/warehouse_model.dart';
import 'package:eagle_cargo/core/api/providers/auth_provider.dart';
import 'package:eagle_cargo/core/extensions/toaster_extension.dart';
import 'package:eagle_cargo/core/utils/palette.dart';
import 'package:eagle_cargo/core/utils/utc_format_extenstion.dart';

import 'warehouse_map_page.dart';

class WarehouseCard extends StatelessWidget {
  final WarehouseModel model;

  const WarehouseCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    User? profile = context.watch<AuthProvider>().profile;
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: context.isDark() ? Palette.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: context.defaultShadow(),
      ),
      child: Stack(
        children: [
          /// Illustration on right side with low opacity
          Positioned(
            right: -(size.width / 3.5), // move image outside to show only half
            top: 20,
            bottom: 0,
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                "assets/images/warehouse.png",
                // width: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Text content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Palette.primaryLight,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        model.name ?? "...",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Palette.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _row("Doly ady:", profile?.login ?? "..."),
                _row(
                  "${context.tr('table_phone').toSentenceCase()}:",
                  model.phone ?? "",
                ),
                _row("${context.tr('wh_address')}:", model.address ?? "..."),
                _row("${context.tr('mb_postal_code')}:", model.code ?? ""),

                const SizedBox(height: 20),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primaryLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(
                            text:
                                "姓名:${profile?.login ?? "..."}\n电话:${model.phone}\n地址:${model.address} (${profile?.login ?? ""})\n郵遞區號:${model.code}",
                          ),
                        ).then((v) {
                          context.showInfoToast(
                            description: context.tr('mb_copied_to_clipboard'),
                          );
                        });
                        // copied successfully
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          context.tr('mb_copy_address'),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    if (model.latitude != null && model.longitude != null)
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Palette.primaryLight,
                          side: BorderSide(color: Palette.primaryLight),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WarehouseMapPage(
                                latitude: model.latitude!,
                                longitude: model.longitude!,
                                title: model.name,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.map_outlined),
                        label: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Kartada görkez'),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
