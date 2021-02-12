import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/bar_graph.dart';

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
                Text('05:10'),
                BarGraph(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
