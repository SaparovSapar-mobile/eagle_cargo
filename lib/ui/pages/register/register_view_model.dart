import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/providers/auth_provider.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/api/models/location_model.dart';
import 'package:eagle_cargo/core/api/services/location_service.dart';
import 'package:eagle_cargo/core/extensions/toaster_extension.dart';
import 'package:eagle_cargo/core/routes/routes.dart';
import 'register_page.dart';

abstract class RegisterViewModel extends State<RegisterPage>{
  final formKey = GlobalKey<FormState>();
  final tecName = TextEditingController();
  final tecEmail = TextEditingController();
  final tecPassword = TextEditingController();
  List<LocationModel> regions = [];
  String? selectedLocationGuid;

  @override
  void initState() {
    super.initState();
    _fetchRegions();
  }

  Future<void> _fetchRegions() async {
    try {
      final regions = await LocationService.fetchRegions();
      setState(() {
        this.regions = regions;
      });
    } catch (e) {
      debugPrint("Error fetching regions: $e");
    }
  }

  void register() {
    if (formKey.currentState?.validate() ?? false) {
      context.read<AuthProvider>().register(
        name: tecName.text,
        email: tecEmail.text,
        password: tecPassword.text,
        locationGuid: selectedLocationGuid,
        onSuccess: () {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacementNamed(context, Routes.main);
        },
        onAlreadyRegistered: () {
          context.showInfoToast(description: context.tr('mb_alert_already_registered'));
        },
        onError: () {
          context.showErrorToast(description: context.tr('mb_error_occured'));
        },
      );
    }
  }
}