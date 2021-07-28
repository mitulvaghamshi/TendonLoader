import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/screens/exercise/exercise_handler.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomGraph extends StatelessWidget {
  const CustomGraph({Key? key, required this.handler, required this.progressbar}) : super(key: key);

  final GraphHandler handler;
  final Widget progressbar;

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      onExit: handler.exit,
      child: Column(children: <Widget>[
        progressbar,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: handler.lineData != null
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
                  dataSource: handler.graphData,
                  onRendererCreated: (ChartSeriesController ctrl) => handler.graphCtrl = ctrl,
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
                if (handler.lineData != null)
                  LineSeries<ChartData, int>(
                    width: 5,
                    color: colorRed400,
                    animationDuration: 0,
                    dataSource: handler.lineData!,
                    onRendererCreated: (ChartSeriesController ctrl) => handler.lineCtrl = ctrl,
                    yValueMapper: (ChartData data, _) => data.load,
                    xValueMapper: (ChartData data, _) => data.time.toInt(),
                  ),
              ],
            ),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
          CustomButton(onPressed: handler.start, left: const Icon(Icons.play_arrow)),
          if (handler is ExerciseHandler) CustomButton(onPressed: handler.pause, left: const Icon(Icons.pause)),
          CustomButton(onPressed: handler.stop, left: const Icon(Icons.stop)),
        ]),
      ]),
    );
  }
}
