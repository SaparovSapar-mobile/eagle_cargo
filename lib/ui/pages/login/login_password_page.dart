import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/providers/auth_provider.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/extensions/toaster_extension.dart';
import 'package:eagle_cargo/core/routes/routes.dart';
import 'package:eagle_cargo/core/utils/palette.dart';

class LoginPasswordPage extends StatefulWidget {
  final String phoneNumber;
  const LoginPasswordPage({super.key, required this.phoneNumber});

  @override
  State<LoginPasswordPage> createState() => _LoginPasswordPageState();
}

class _LoginPasswordPageState extends State<LoginPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() {
    if (_passwordController.text.isEmpty) {
      context.showInfoToast(description: context.tr('mb_password_required'));
      return;
    }

    setState(() => _isLoading = true);

    context.read<AuthProvider>().loginWithPassword(
      phone: widget.phoneNumber,
      password: _passwordController.text,
      onSuccess: () {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacementNamed(context, Routes.main);
      },
      onError: () {
        setState(() => _isLoading = false);
        context.showErrorToast(description: context.tr('mb_invalid_password'));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              Text(
                context.tr('mb_password'),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${context.tr('mb_enter_password_for')} \n${widget.phoneNumber}",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 50),
              Text(
                context.tr('mb_password'),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "******",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          context.tr('login'),
                          style: const TextStyle(
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
                      builder: (context) => Column(
                        mainAxisSize: .min,
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              Clipboard.setData(
                                ClipboardData(
                                  text: context.tr('footer_contact_phone'),
                                ),
                              ).then((v) {
                                if (!context.mounted) return;
                                context.showInfoToast(
                                  description: context.tr('mb_copied_to_clipboard'));
                              });
                            },
                            leading: Icon(CupertinoIcons.phone),
                            title: Text(context.tr('footer_contact_phone')),
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
                                context.showInfoToast(description: context.tr('mb_copied_to_clipboard'));
                              });
                            },
                            leading: Icon(CupertinoIcons.mail),
                            title: Text(context.tr('footer_contact_mail')),
                          ),
                          SizedBox(height: kToolbarHeight / 2),
                        ],
                      ),
                    );
                  },
                  child: Text(context.tr('mb_tech_support')),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
