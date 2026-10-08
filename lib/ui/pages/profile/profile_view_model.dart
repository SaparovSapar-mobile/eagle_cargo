import 'package:flutter/material.dart';
import 'package:kargoo_core/core/extensions/translate_extension.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/providers/index.dart';
import 'package:eagle_cargo/core/extensions/toaster_extension.dart';
import 'package:eagle_cargo/core/routes/routes.dart';

import '../../widgets/custom_alert_dialog.dart';
import '../main/components/page_lifecycle.dart';
import 'profile_page.dart';

abstract class ProfileViewModel extends State<ProfilePage> with PageLifecycle {
  bool isLoading = false;
  final ScrollController scrollController = ScrollController();
  bool isCollapsed = false;
  @override
  void initState() {
    super.initState();
    context.read<WarehouseProvider>().getPaymentInfo();
    context.read<WarehouseProvider>().checkForeign();
    context.read<AuthProvider>().getProfile();

    scrollController.addListener(() {
      if (scrollController.hasClients) {
        bool collapsed = scrollController.offset > (220 - kToolbarHeight - 20);
        if (collapsed != isCollapsed) {
          setState(() {
            isCollapsed = collapsed;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void logout() {
    context.read<AuthProvider>().logout(
      onSuccess: () {
        Navigator.popUntil(context, (r) => r.isFirst);
      },
    );
  }

  @override
  void onPageVisible() {
    debugPrint("Profile tab re-opened");
    context.read<AuthProvider>().getProfile();
    context.read<WarehouseProvider>().getPaymentInfo();
    context.read<WarehouseProvider>().checkForeign();
    super.onPageVisible();
  }

  void onError() {
    context.showErrorToast(description: context.tr('mb_error_occured'));
  }

  void onDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomAlertDialog(
          actionCombination: CustomADActionCombination.yesno,
          titleText: context.tr('mb_delete_account'),
          contentWidget: Text(
            context.tr('mb_ask_delete_account'),
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          ),
          onSubmit: () {
            if (!mounted) return;
            // 1. Close the dialog first
            Navigator.pop(dialogContext);

            // 2. Navigate to your entry route and clear the entire stack
            context.read<AuthProvider>().deleteAccount(
              onSuccess: () {
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.login, // Or whatever your first page route is
                  (route) => false,
                );
              },
              onError: () => onError(),
            );
          },
        );
      },
    );
  }
}
