import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/models/location_model.dart';
import 'package:eagle_cargo/core/api/providers/index.dart';
import 'package:eagle_cargo/core/api/services/location_service.dart';
import 'package:eagle_cargo/core/extensions/toaster_extension.dart';
import 'package:eagle_cargo/core/utils/form_field_validator.dart';
import 'package:eagle_cargo/core/utils/palette.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;

class EditProfileBottomSheet extends StatefulWidget {
  const EditProfileBottomSheet({super.key});

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tecName;
  String? _selectedLocationGuid;
  List<LocationModel> _regions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().profile;
    _tecName = TextEditingController(text: user?.fullname);
    _selectedLocationGuid = user?.location?.locationGuid;
    _fetchRegions();
  }

  Future<void> _fetchRegions() async {
    try {
      final regions = await LocationService.fetchRegions();
      setState(() {
        _regions = regions;
      });
    } catch (e) {
      debugPrint("Error fetching regions: $e");
    }
  }

  void _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await context.read<AuthProvider>().updateProfile(
        name: _tecName.text,
        locationGuid: _selectedLocationGuid,
        onSuccess: () {
          Navigator.pop(context);
          context.showSuccessToast(description: context.tr('mb_edit_success'));
        },
        onError: () {
          setState(() => _isLoading = false);
          context.showErrorToast(description: context.tr('mb_error_occured'));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: context.isDarkRead() ? Palette.darkSurface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                context.tr('edit'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                context.tr('mb_fullname'),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _tecName,
                validator: CustomFormFieldValidator().isNotEmpty,
                decoration: InputDecoration(
                  prefixIcon: const Icon(CupertinoIcons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.tr('mb_select_location'),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedLocationGuid,
                items: _regions.map((region) {
                  return DropdownMenuItem<String>(
                    value: region.locationGuid,
                    child: Text(region.name ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLocationGuid = value;
                  });
                },
                validator: CustomFormFieldValidator().isNotEmpty,
                decoration: InputDecoration(
                  prefixIcon: const Icon(CupertinoIcons.location),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : Text(
                          context.tr('mb_save'),
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
