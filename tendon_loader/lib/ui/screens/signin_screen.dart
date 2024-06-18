import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/api/network_status.dart';
import 'package:tendon_loader/states/app_scope.dart';
import 'package:tendon_loader/ui/widgets/app_logo.dart';
import 'package:tendon_loader/ui/widgets/input_field.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  late final state = AppScope.of(context);

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    NetworkStatus(); // Initialize singleton
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (kDebugMode) {
      _usernameCtrl.text = 'user@email.com';
      _passwordCtrl.text = '123456';
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    setState(() => _isLoading = true);
    await state.authenticate(
      username: _usernameCtrl.text,
      password: _passwordCtrl.text,
    );
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading && state.user.id != null) return widget.builder(context);
    return Form(
      child: Column(children: [
        const AppLogo(radius: 150, padding: EdgeInsets.all(16)),
        InputField.form(
          label: 'Enter username',
          controller: _usernameCtrl,
          keyboardType: TextInputType.emailAddress,
        ),
        InputField.form(
          label: 'Enter password',
          controller: _passwordCtrl,
          keyboardType: TextInputType.visiblePassword,
        ),
        const SizedBox(height: 16),
        AnimatedCrossFade(
          crossFadeState:
              _isLoading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 500),
          firstChild: RawButton.tile(
            onTap: _authenticate,
            color: Colors.indigo,
            child: const Text('Login', style: Styles.whiteBold),
          ),
          secondChild: const RawButton.loading(),
        ),
      ]),
    );
  }
}
