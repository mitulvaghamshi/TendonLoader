import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/bar_graph.dart';
import 'package:tendon_loader/utils/bluetooth_args.dart';

class LiveData extends StatefulWidget {
  static const name = 'Live Data';
  static const routeName = '/liveData';

  LiveData({Key key}) : super(key: key);

  @override
  _LiveDataState createState() => _LiveDataState();
}

class _LiveDataState extends State<LiveData> {
  BluetoothArgs args;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: const Text(LiveData.name)),
      body: SingleChildScrollView(
        child: Card(
          elevation: 16.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Current Load (Units)'), Text('100.8')],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Time'), Text('05:10')],
                    ),
                  ],
                ),
                BarGraph(args: args),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
