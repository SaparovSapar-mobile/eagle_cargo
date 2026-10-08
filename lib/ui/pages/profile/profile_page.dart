import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eagle_cargo/core/api/api.dart';
import 'package:eagle_cargo/core/api/models/payment_info_response.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/api/providers/index.dart';
import 'package:eagle_cargo/core/routes/routes.dart';
import 'package:eagle_cargo/core/utils/local_translations.dart';
import 'package:eagle_cargo/core/utils/palette.dart';
import 'package:eagle_cargo/ui/pages/profile/components/profile_header.dart';
import 'package:eagle_cargo/ui/pages/profile/components/profile_tile.dart';
import 'package:eagle_cargo/ui/pages/profile/profile_view_model.dart';
import 'package:eagle_cargo/ui/widgets/cached_image.dart';
import 'package:eagle_cargo/ui/widgets/custom_alert_dialog.dart';

import 'components/languages_bottom_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends ProfileViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? CircularProgressIndicator.adaptive()
          : CustomScrollView(
              controller: scrollController,
              slivers: [
                // ============================
                // EXPANDING HEADER → APPBAR
                // ============================
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  backgroundColor: Palette.primary,
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isCollapsed ? 1.0 : 0.0,
                    child: Text(
                      context.t('mb_profile'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(background: ProfileHeader()),
                ),

                // ============================
                // CONTENT SECTION
                // ============================
                SliverToBoxAdapter(child: const SizedBox(height: 20)),

                SliverToBoxAdapter(child: _buildCardSection(context)),
                SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
    );
  }

  Widget _buildCardSection(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    PaymentInfoResponse? payment = context
        .watch<WarehouseProvider>()
        .paymentInfoResponse;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: context.isDark() ? Palette.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: context.defaultShadow(),
      ),
      child: Column(
        children: [
          // ProfileTile(icon: Icons.edit, title: "Edit Profile Name"),
          ProfileTile(
            icon: Icons.info_outline_rounded,
            title: context.t('mb_about_us'),
            onTap: () {
              Navigator.pushNamed(context, Routes.aboutUs);
            },
          ),
          ProfileTile(
            icon: Icons.warehouse_outlined,
            title: context.t('menu_warehouses'),
            onTap: () {
              Navigator.pushNamed(context, Routes.warehouses);
            },
          ),
          ProfileTile(
            icon: Icons.public_rounded,
            title: context.tl('mb_foreign_warehouses'),
            onTap: () {
              Navigator.pushNamed(context, Routes.foreignWarehouses);
            },
          ),
          ProfileTile(
            icon: Icons.warning_amber_rounded,
            title: context.tl('mb_warnings'),
            onTap: () {
              Navigator.pushNamed(context, Routes.warnings);
            },
          ),
          ProfileTile(
            icon: Icons.translate_rounded,
            title: context.t('language_settings'),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return LanguagesBottomSheet();
                },
              );
            },
          ),
          ProfileTile(
            icon: CupertinoIcons.moon_stars,
            title: context.t('mb_dark_mode'),
            showArrow: false,
            trailing: Switch.adaptive(
              value: context.watch<ThemeProvider>().themeMode == ThemeMode.dark,
              onChanged: (v) {
                themeProvider.toggleTheme();
              },
            ),
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
          if ((payment?.paymentData?.base?.alipayQr?.isNotEmpty ?? false) ||
              (payment?.paymentData?.base?.alipayLink?.isNotEmpty ?? false))
            ProfileTile(
              onTap: () {
                final qr = payment?.paymentData?.base?.alipayQr;
                final link = payment?.paymentData?.base?.alipayLink;
                showModalBottomSheet(
                  context: context,
                  backgroundColor: context.isDarkRead()
                      ? Palette.darkSurface
                      : Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  isScrollControlled: true,
                  builder: (context) => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        if (qr?.isNotEmpty ?? false)
                          CachedImage(imageUrl: '${API.host}/uploads$qr'),
                        if (link?.isNotEmpty ?? false) ...[
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => launchUrl(
                              Uri.parse(link!),
                              mode: LaunchMode.externalApplication,
                            ),
                            child: const Text("Open Alipay"),
                          ),
                        ],
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
              icon: CupertinoIcons.qrcode,
              title: "Alipay",
            ),
          if ((payment?.paymentData?.base?.wechatQr?.isNotEmpty ?? false) ||
              (payment?.paymentData?.base?.wechatLink?.isNotEmpty ?? false))
            ProfileTile(
              onTap: () {
                final qr = payment?.paymentData?.base?.wechatQr;
                final link = payment?.paymentData?.base?.wechatLink;
                showModalBottomSheet(
                  context: context,
                  backgroundColor: context.isDarkRead()
                      ? Palette.darkSurface
                      : Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  isScrollControlled: true,
                  builder: (context) => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        if (qr?.isNotEmpty ?? false)
                          CachedImage(imageUrl: '${API.host}/uploads$qr'),
                        if (link?.isNotEmpty ?? false) ...[
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => launchUrl(
                              Uri.parse(link!),
                              mode: LaunchMode.externalApplication,
                            ),
                            child: const Text("Open WeChat"),
                          ),
                        ],
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
              icon: CupertinoIcons.qrcode,
              title: "WeChat",
            ),
          Divider(height: 1),
          ProfileTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    actionCombination: CustomADActionCombination.yesno,
                    contentWidget: Text(
                      context.tr('mb_ask_logout'),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                    titleText: context.tr('logout'),
                    onSubmit: () {
                      context.read<AuthProvider>().logout(
                        onSuccess: () {
                          Navigator.popUntil(context, (r) => r.isFirst);
                          Navigator.pushReplacementNamed(context, Routes.login);
                        },
                      );
                    },
                  );
                },
              );
            },
            icon: Icons.logout,
            title: context.t('logout'),
            color: Colors.red,
            showArrow: false,
          ),
          if (Platform.isIOS || kDebugMode) ...[
            Divider(),
            ProfileTile(
              onTap: () => onDeleteAccount(context),
              icon: Icons.delete_outline_rounded,
              title: context.t('mb_delete_account'),
              color: Colors.red,
              showArrow: false,
            ),
          ],
        ],
      ),
    );
  }
}
