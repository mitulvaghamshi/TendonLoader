import 'package:flutter/material.dart';

import '../bluetooth/bluetooth.dart';
import '../bluetooth/bluetooth_args.dart';
import '../screens/bar_graph.dart';

class LiveData extends StatefulWidget {
  static const name = 'Live Data';
  static const routeName = '/liveData';

  LiveData({Key key}) : super(key: key);

  @override
  _LiveDataState createState() => _LiveDataState();
}

class _LiveDataState extends State<LiveData> {
  @override
  Widget build(BuildContext context) {
    final BluetoothArgs args = ModalRoute.of(context).settings.arguments;

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
                      children: [
                        Text('Current Load (Units)'),
                        Text('100.8'),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Time'),
                        Text('05:10'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                Container(height: 400.0, child: BarGraph()),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton(
                      onPressed: null,
                      heroTag: 'tag-stop-btn',
                      child: Icon(Icons.play_arrow_rounded),
                    ),
                    FloatingActionButton(
                      onPressed: null,
                      heroTag: 'tag-play-btn',
                      child: Icon(Icons.stop_rounded),
                    ),
                    FloatingActionButton(
                      onPressed: null,
                      heroTag: 'tag-reset-btn',
                      child: Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
