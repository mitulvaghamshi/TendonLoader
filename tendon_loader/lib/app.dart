import 'package:flutter/material.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/widgets/app_logo.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/router/router.dart';

@immutable
final class TendonLoaderApp extends StatelessWidget {
  const TendonLoaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Hero(tag: 'hero-app-logo', child: AppLogo.sized()),
      const SizedBox(height: 30),
      RawButton.tile(
        color: Colors.orange,
        child: const Text('Access as a Patient', style: Styles.boldWhite),
        onTap: () => const HomeScreenRoute().go(context),
      ),
      const SizedBox(height: 8),
      RawButton.tile(
        color: Colors.orange,
        child: const Text('Clinician - Manage Users', style: Styles.boldWhite),
        onTap: () => const HomePageRoute().go(context),
      ),
      const SizedBox(height: 8),
      Hero(
        tag: 'hero-settings-button',
        child: RawButton.tile(
          color: Colors.green,
          child: const Text('View all settings', style: Styles.boldWhite),
          onTap: () => const SettingScreenRoute().push(context),
        ),
      ),
    ]);
  }
}
