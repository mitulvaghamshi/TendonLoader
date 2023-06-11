import 'package:flutter/material.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/models/prescription.dart';
import 'package:tendon_loader/common/router/router.dart';
import 'package:tendon_loader/common/widgets/custom_widget.dart';
import 'package:tendon_loader/screens/mvctest/widgets/time_picker_tile.dart';
import 'package:tendon_loader/screens/settings/models/app_state.dart';

class NewMVCTest extends StatefulWidget {
  const NewMVCTest({super.key, required this.duration});

  final int duration;

  @override
  NewMVCTestState createState() => NewMVCTestState();
}

class NewMVCTestState extends State<NewMVCTest> {
  bool _useLastDuration = false;
  late int _duration;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('New MVC Test'),
        actions: <Widget>[
          CustomWidget.two(
            left: const Text('OK', style: Styles.titleStyle),
            right: const Icon(Icons.arrow_forward),
            onPressed: _onSubmit,
          ),
        ],
      ),
      body: IgnorePointer(
        ignoring: !AppState.of(context).isCustomPrescriptions(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
            TimePickerTile(
              time: _duration,
              desc: 'MVC test duration',
              onSelected: (duration) => setState(() => _duration = duration),
            ),
          ],
        ),
      ),
    );
  }
}

extension on NewMVCTestState {
  void _initFields() {
    _duration = _useLastDuration
        ? AppState.of(context).getLastMvcDuration()
        : widget.duration;
  }

  void _onSubmit() {
    if (_duration > 0) {
      AppState.of(context).settings((settings) {
        settings.prescription =
            settings.prescription.copyWith(mvcDuration: _duration);
      });
      if (mounted) const MVCTestingRoute().go(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select test duration.')));
    }
  }
}
