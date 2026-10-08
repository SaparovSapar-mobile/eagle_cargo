// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:provider/provider.dart';
import 'package:eagle_cargo/core/api/providers/index.dart';
import 'package:eagle_cargo/ui/pages/profile/components/edit_profile_bottom_sheet.dart';

import '../../../../core/utils/palette.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const double avatarSize = 90.0;
    User? profile = context.watch<AuthProvider>().profile;
    final lang = Localizations.localeOf(context).languageCode;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Palette.primary, Palette.primary2],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- Avatar ---
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/app_logo.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // --- Fullname ---
                SelectableText.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "${profile?.fullname ?? 'User'} "),
                      TextSpan(
                        text: "[${profile?.login ?? 'User'}]",
                        // style: const TextStyle(
                        //   decoration: TextDecoration
                        //       .underline, // Optional: visual cue it's special
                        //   // fontStyle: FontStyle.italic,
                        // ),
                      ),
                    ],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 4),

                // --- Phone ---
                if (profile?.phone != null)
                  Text(
                    profile!.phone!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),

                const SizedBox(height: 4),

                // --- Location ---
                if (profile?.location?.name != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.location_solid,
                        size: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        profile!.location!.name!.get(lang),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const EditProfileBottomSheet(),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
