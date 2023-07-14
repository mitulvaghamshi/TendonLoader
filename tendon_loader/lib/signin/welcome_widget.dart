import 'package:flutter/material.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/widgets/image_widget.dart';
import 'package:tendon_loader/widgets/raw_button.dart';

@immutable
final class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Hero(tag: 'hero-app-logo', child: AppLogo.square()),
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
        onTap: () => const UserListRoute().go(context),
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
