import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/text_styles.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/handlers/mvc_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';

class MVCTesting extends StatefulWidget {
  const MVCTesting({Key? key}) : super(key: key);

  static const String name = 'MVC Testing';
  static const String route = '/mvcTesting';

  @override
  _MVCTestingState createState() => _MVCTestingState();
}

class _MVCTestingState extends State<MVCTesting> {
  late final MVCHandler _handler = MVCHandler(context: context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(MVCTesting.name)),
      body: CustomGraph(
        handler: _handler,
        header: StreamBuilder<ChartData>(
          initialData: ChartData(),
          stream: GraphHandler.stream,
          builder: (_, AsyncSnapshot<ChartData> snapshot) {
            _handler.graphData.insert(0, snapshot.data!);
            _handler.graphCtrl?.updateDataSource(updatedDataIndex: 0);
            return FittedBox(
              child: Column(children: <Widget>[
                Text(_handler.maxForceValue, style: tsG40B),
                Text(_handler.timeDiffValue, style: tsR40B),
              ]),
            );
          },
        ),
      ),
    );
  }
}
