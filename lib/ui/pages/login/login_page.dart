import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/extensions/toaster_extension.dart';
import 'package:eagle_cargo/core/utils/palette.dart';
import 'package:eagle_cargo/core/utils/utc_format_extenstion.dart';
import 'package:eagle_cargo/ui/pages/login/login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends LoginViewModel {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Important!
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    const Spacer(flex: 2), // Push content down a bit from top
                    // Title & Subtitle
                    Text(
                      context.tr('mb_sign_in_title'),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.tr('mb_sign_in_subtitle'),
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 50),

                    // Phone Number Label
                    Text(
                      context.tr('table_phone').toSentenceCase(),
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    // Phone Input
                    TextField(
                      key: ValueKey('phone_field'),
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(maxPhoneLength),
                      ],
                      decoration: InputDecoration(
                        prefixIcon: IntrinsicWidth(
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedPrefix,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 20,
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: context.textColor(),
                                    fontSize: 17,
                                  ),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        selectedPrefix = newValue;
                                        phoneController.clear();
                                      });
                                    }
                                  },
                                  items: prefixes
                                      .map<DropdownMenuItem<String>>((
                                        String value,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      })
                                      .toList(),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 1,
                                height: 24,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                        hintText: selectedPrefix == "+993"
                            ? "65 123123"
                            : "138 0013 8000",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        key: Key('login_btn'),
                        onPressed: isLoading ? null : onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                context.tr('mb_continue'),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => SafeArea(
                              child: Column(
                                mainAxisSize: .min,
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: context.tr(
                                            'footer_contact_phone',
                                          ),
                                        ),
                                      ).then((v) {
                                        context.showInfoToast(
                                          description: context.tr(
                                            'mb_copied_to_clipboard',
                                          ),
                                        );
                                      });
                                    },
                                    leading: Icon(CupertinoIcons.phone),
                                    title: Text(
                                      context.tr('footer_contact_phone'),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: context.tr('footer_contact_mail'),
                                        ),
                                      ).then((v) {
                                        if (!context.mounted) return;
                                        context.showInfoToast(
                                          description: context.tr(
                                            'mb_copied_to_clipboard',
                                          ),
                                        );
                                      });
                                    },
                                    leading: Icon(CupertinoIcons.mail),
                                    title: Text(
                                      context.tr('footer_contact_mail'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Text(context.tr('mb_tech_support')),
                      ),
                    ),

                    // Resend Code
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.popUntil(context, (route) => route.isFirst);
                    //     Navigator.pushReplacementNamed(
                    //       context,
                    //       Routes.register,
                    //     );
                    //   },
                    //   child: const Text(
                    //     "Do not you have an account? Create account",
                    //     style: TextStyle(color: Palette.primary, fontSize: 15),
                    //   ),
                    // ),
                    const Spacer(flex: 3), // Push button up from bottom nicely
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
