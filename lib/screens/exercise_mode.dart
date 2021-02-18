import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_textfield.dart';
import 'package:tendon_loader/utils/bar_graph.dart';

class ExerciseMode extends StatefulWidget {
  static const name = 'Exercise Mode';
  static const routeName = '/exerciseMode';

  ExerciseMode({Key key}) : super(key: key);

  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<ExerciseMode> {
  TextEditingController ctrl1 = TextEditingController();
  TextEditingController ctrl2 = TextEditingController();
  TextEditingController ctrl3 = TextEditingController();
  TextEditingController ctrl4 = TextEditingController();
  TextEditingController ctrl5 = TextEditingController();

  @override
  void dispose() {
    ctrl1.dispose();
    ctrl2.dispose();
    ctrl3.dispose();
    ctrl4.dispose();
    ctrl5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(milliseconds: Duration.millisecondsPerSecond), () => _showDialog(context));
    return Scaffold(
      appBar: AppBar(
        title: const Text(ExerciseMode.name),
        actions: [
          IconButton(
            tooltip: 'Create new exercise',
            icon: Icon(Icons.add_circle_outline_rounded),
            onPressed: () async => await _showDialog(context),
          ),
        ],
      ),
      body: BarGraph(),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          scrollable: true,
          title: Text('Create new exercise', textAlign: TextAlign.center),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            FlatButton(
              child: Text('OK'),
              color: Colors.blue,
              onPressed: () {
                Navigator.pop(context);
                // print(ctrl1.text);
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
                ctrl1.clear();
                ctrl2.clear();
                ctrl3.clear();
                ctrl4.clear();
                ctrl5.clear();
              },
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(hint: 'Target Load (units)', controller: ctrl1),
              CustomTextField(hint: 'Hold time (sec)', controller: ctrl2),
              CustomTextField(hint: 'Sets', controller: ctrl3),
              CustomTextField(hint: 'Reps', controller: ctrl4),
              CustomTextField(hint: 'Rest time (sec)', controller: ctrl5),
            ],
          ),
        );
      },
    );
  }
}
