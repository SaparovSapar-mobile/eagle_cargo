import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kargoo_core/core/extensions/theme_extension.dart';
import 'package:kargoo_core/core/extensions/translate_extension.dart';

import 'package:eagle_cargo/core/utils/form_field_validator.dart';
import 'package:eagle_cargo/core/utils/palette.dart';
import 'package:eagle_cargo/ui/pages/register/register_view_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends RegisterViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                // <----- keeps container centered
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: .start,

                    children: [
                      const Spacer(flex: 2), // Push content down a bit from top
                      // Title & Subtitle
                      Text(
                        context.tr('mb_sign_up_title'),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.tr('mb_sign_up_subtitle'),
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 50),

                      // Phone Number Label
                      Text(
                        context.tr('mb_fullname'),
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: tecName,
                        validator: CustomFormFieldValidator().isNotEmpty,
                        decoration: InputDecoration(
                          prefixStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: context.textColor(),
                            fontSize: 17,
                          ),
                          prefixIcon: Icon(CupertinoIcons.person),
                          // hintText: "Fullname",
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
                      const SizedBox(height: 15),
                      Text(context.tr('email'), style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: tecEmail,
                        validator: CustomFormFieldValidator().emailValidator,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.mail),
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
                      const SizedBox(height: 15),
                      Text(
                        context.tr('mb_password'),
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: tecPassword,
                        obscureText: true,
                        validator: CustomFormFieldValidator().passwordValidator,
                        decoration: InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.lock_circle),
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
                      const SizedBox(height: 15),
                      Text(
                        context.tr('mb_select_location'),
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: selectedLocationGuid,
                        items: regions.map((region) {
                          return DropdownMenuItem<String>(
                            value: region.locationGuid,
                            child: Text(region.name ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLocationGuid = value;
                          });
                        },
                        validator: CustomFormFieldValidator().isNotEmpty,
                        decoration: InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.location),
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

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            context.tr('mb_continue'),
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.popUntil(context, (route) => route.isFirst);
                      //     Navigator.pushReplacementNamed(context, Routes.login);
                      //   },
                      //   child: const Text(
                      //     "Do not you have an account? Create account",
                      //     style: TextStyle(color: Palette.primary, fontSize: 15),
                      //   ),
                      // ),
                      const Spacer(
                        flex: 3,
                      ), // Push button up from bottom nicely
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
