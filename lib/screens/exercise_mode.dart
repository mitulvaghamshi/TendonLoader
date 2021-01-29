import 'package:flutter/material.dart';

import '../bluetooth/bluetooth.dart';

class ExerciseMode extends StatefulWidget {
  ExerciseMode({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<ExerciseMode> {
  TextEditingController ctrl1 = new TextEditingController();
  TextEditingController ctrl2 = new TextEditingController();
  TextEditingController ctrl3 = new TextEditingController();
  TextEditingController ctrl4 = new TextEditingController();
  TextEditingController ctrl5 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Card(
          elevation: 16.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Please enter your exercise prescriptions',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Target Load (units)'),
                    Expanded(
                      child: TextField(
                        controller: ctrl1,
                        onChanged: (value) => {},
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Hold time (sec)'),
                    Expanded(
                      child: TextField(
                        controller: ctrl2,
                        onChanged: (value) => {},
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sets'),
                    Expanded(
                      child: TextField(
                        controller: ctrl3,
                        onChanged: (value) => {},
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Reps'),
                    Expanded(
                      child: TextField(
                        controller: ctrl4,
                        onChanged: (value) => {},
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rest time (sec)'),
                    Expanded(
                      child: TextField(
                        controller: ctrl5,
                        onChanged: (value) => {},
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => Bluetooth(
              title: 'Bluetooth',
            ),
          ),
        ),
        tooltip: 'Connect to Bluetooth',
        label: const Text('Connect'),
        icon: Icon(Icons.bluetooth),
      ),
    );
  }
}
