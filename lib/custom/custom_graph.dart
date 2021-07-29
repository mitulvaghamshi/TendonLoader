import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/screens/exercise/exercise_handler.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomGraph extends StatefulWidget {
  const CustomGraph({Key? key, required this.builder, required this.handler}) : super(key: key);

  final GraphHandler handler;
  final Widget Function() builder;

  @override
  _CustomGraphState createState() => _CustomGraphState();
}

class _CustomGraphState extends State<CustomGraph> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Title')),
      body: AppFrame(
        onExit: widget.handler.exit,
        child: Column(children: <Widget>[
          StreamBuilder<ChartData>(
            initialData: ChartData(),
            stream: GraphHandler.stream,
            builder: (BuildContext context, AsyncSnapshot<ChartData> snapshot) {
              widget.handler.graphData.insert(0, snapshot.data!);
              widget.handler.graphCtrl?.updateDataSource(updatedDataIndex: 0);
              return FittedBox(child: widget.builder());
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: widget.handler.lineData != null
                    ? NumericAxis(minimum: 0, isVisible: false)
                    : CategoryAxis(minimum: 0, maximum: 0, isVisible: false),
                primaryYAxis: NumericAxis(
                  labelFormat: '{value} kg',
                  axisLine: const AxisLine(width: 0),
                  maximum: context.model.settingsState!.graphSize,
                  majorGridLines: MajorGridLines(color: Theme.of(context).accentColor),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                series: <ChartSeries<ChartData?, int>>[
                  ColumnSeries<ChartData?, int>(
                    width: 0.9,
                    borderWidth: 1,
                    animationDuration: 0,
                    color: colorGoogleGreen,
                    dataSource: widget.handler.graphData,
                    onRendererCreated: (ChartSeriesController ctrl) => widget.handler.graphCtrl = ctrl,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      showZeroValue: false,
                      labelAlignment: ChartDataLabelAlignment.bottom,
                      textStyle: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    xValueMapper: (ChartData? data, _) => 1,
                    yValueMapper: (ChartData? data, _) => data!.load,
                  ),
                  if (widget.handler.lineData != null)
                    LineSeries<ChartData, int>(
                      width: 5,
                      color: colorRed400,
                      animationDuration: 0,
                      dataSource: widget.handler.lineData!,
                      onRendererCreated: (ChartSeriesController ctrl) => widget.handler.lineCtrl = ctrl,
                      yValueMapper: (ChartData data, _) => data.load,
                      xValueMapper: (ChartData data, _) => data.time.toInt(),
                    ),
                ],
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
            CustomButton(
              rounded: true,
              onPressed: widget.handler.start,
              left: const Icon(Icons.play_arrow),
            ),
            if (widget.handler is ExerciseHandler)
              CustomButton(
                rounded: true,
                onPressed: widget.handler.pause,
                left: const Icon(Icons.pause),
              ),
            CustomButton(
              rounded: true,
              onPressed: widget.handler.stop,
              left: const Icon(Icons.stop),
            ),
          ]),
        ]),
      ),
    );
  }
}
