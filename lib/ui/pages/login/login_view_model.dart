import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/providers/auth_provider.dart';
import 'login_page.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/extensions/toaster_extension.dart';
import 'package:eagle_cargo/ui/pages/otp/otp_page.dart';
import 'package:eagle_cargo/ui/widgets/custom_alert_dialog.dart';

abstract class LoginViewModel extends State<LoginPage>{
  final TextEditingController phoneController = TextEditingController();
  String selectedPrefix = "+993";
  final List<String> prefixes = ["+993", "+86"];

  int get maxPhoneLength => selectedPrefix == "+993" ? 8 : 11;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  void onContinue() {
    if (phoneController.text.length == maxPhoneLength) {
      setState(() => isLoading = true);
      context.read<AuthProvider>().initLogin(
        phone: "$selectedPrefix${phoneController.text}",
        onRegisterRequired: () {
          setState(() => isLoading = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpPage(
                phoneNumber: "$selectedPrefix${phoneController.text}",
              ),
            ),
          );
        },
        onDeletedAccount: () {
          setState(() => isLoading = false);
          showDialog(context: context, builder: (context){
            return CustomAlertDialog(actionCombination: CustomADActionCombination.onlyOk,
            contentWidget: Text(context.tr('mb_alert_deleted_account'), style: Theme.of(context).textTheme.bodyLarge,),
            );
          });
        },
        onSuccess: () {
          setState(() => isLoading = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpPage(
                phoneNumber: "$selectedPrefix${phoneController.text}",
              ),
            ),
          );
        },
        onError: () {
          setState(() => isLoading = false);
        },
      );
    } else {
      context.showErrorToast(
        description:
            "${context.tr('mb_enter')} $maxPhoneLength ${context.tr('mb_digit_number')}",
      );
    }
  }
}