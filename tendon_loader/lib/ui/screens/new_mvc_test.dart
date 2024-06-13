import 'package:flutter/material.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class NewMVCTest extends StatefulWidget {
  const NewMVCTest({super.key});

  // final int duration;

  @override
  State<NewMVCTest> createState() => _NewMVCTestState();
}

class _NewMVCTestState extends State<NewMVCTest> {
  bool _useLastDuration = false;
  late int _duration;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initFields();
  }

  @override
  Widget build(BuildContext context) {
    // final settings = AppScope.of(context).settingsState.settings;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('New MVC Test'),
        actions: [
          RawButton.tile(
            leading: const Text('OK', style: Styles.bold18),
            onTap: _onSubmit,
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: IgnorePointer(
        // ignoring: !settings.editablePrescription,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              leading: Icon(Icons.timer),
              title: Text(
                'MVC Test Duration',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xff3ddc85),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SwitchListTile(
              value: _useLastDuration,
              contentPadding: Styles.tilePadding,
              title: const Text('Use previous duration.'),
              onChanged: (value) => setState(() {
                _useLastDuration = value;
                _initFields();
              }),
            ),
            // TimePickerTile(
            //   time: _duration,
            //   label: 'MVC test duration',
            //   onChange: (duration) => setState(() => _duration = duration),
            // ),
          ],
        ),
      ),
    );
  }
}

extension on _NewMVCTestState {
  void _initFields() {
    // _duration = _useLastDuration
    //     ? AppScope.of(context).userState.prescription.mvcDuration
    //     : 0;
  }

  void _onSubmit() {
    if (_duration > 0) {
      // AppScope.of(context).watch<Prescription>((item) {
      //   return item.copyWith(mvcDuration: _duration);
      // });
      if (mounted) const MVCTestingRoute().go(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select test duration.')));
    }
  }
}
