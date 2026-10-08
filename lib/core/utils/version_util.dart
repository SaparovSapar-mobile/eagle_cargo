import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:kargoo_core/kargoo_core.dart' hide Palette, PreferenceManager, PreferenceKeys;

class VersionUtil {
  static Future<void> checkForUpdate(BuildContext context) async {
    final newVersion = NewVersionPlus(
      androidId: "tm.com.sanlyteklip.eagle",
      iOSId: "tm.com.sanlyteklip.eagle",
    );                                                                                                                                                                                                                
    try {
      final status = await newVersion.getVersionStatus();
      if (!context.mounted) return;
      if (status != null && status.canUpdate) {
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          dialogTitle: context.tr('mb_update_available'),
          dialogText: context
              .tr('mb_update_dialog_xxx')
              .replaceAll('xxx', status.storeVersion),
          updateButtonText: context.tr('mb_update'),
          dismissButtonText: context.tr('mb_update_later'),
          dismissAction: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
