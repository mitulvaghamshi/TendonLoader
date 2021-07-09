import 'package:archive/archive_io.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';

ArchiveFile generateExcel(Export export) {
  int iR = 0;
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  // date
  iR++; // 1
  sheet.getRangeByIndex(iR, 1).text = 'Date:';
  sheet.getRangeByIndex(iR, 4).dateTime = export.timestamp.toDate();
  sheet.getRangeByIndex(iR, 4).numberFormat = 'yyyy-mmm-dd, dddd';

  // time
  iR++; // 2
  sheet.getRangeByIndex(iR, 1).text = 'Time:';
  sheet.getRangeByIndex(iR, 4).dateTime = export.timestamp.toDate();
  sheet.getRangeByIndex(iR, 4).numberFormat = 'hh:mm:ss AM/PM';

  // user id
  iR++; // 3
  sheet.getRangeByIndex(iR, 1).text = 'User ID:';
  sheet.getRangeByIndex(iR, 4).text = export.userId;

  // progressor id
  iR += 2; // 5
  sheet.getRangeByIndex(iR, 1).text = 'Progressor ID:';
  sheet.getRangeByIndex(iR, 4).text = export.progressorId;

  if (!export.isMVC) {
    final Prescription pre = export.prescription!;
    // Exercise info
    iR += 2; // 7
    sheet.getRangeByIndex(iR, 1).text = 'Exercise Info';

    // Last MVC test recorded
    iR++; // 8
    sheet.getRangeByIndex(iR, 1).text = 'Last MVC Test Recorded [Kg]';
    // TODO(me): adjust last recorded MVC
    sheet.getRangeByIndex(iR, 4).number = 0;

    // Target Load
    iR++; // 9
    sheet.getRangeByIndex(iR, 1).text = 'Target Load [Kg]';
    sheet.getRangeByIndex(iR, 4).number = pre.targetLoad;

    // Hold Time
    iR++; // 10
    sheet.getRangeByIndex(iR, 1).text = 'Hold Time [Sec]';
    sheet.getRangeByIndex(iR, 4).number = pre.holdTime.toDouble();

    // Rest Time
    iR++; // 11
    sheet.getRangeByIndex(iR, 1).text = 'Rest Time [Sec]';
    sheet.getRangeByIndex(iR, 4).number = pre.restTime.toDouble();

    // Sets
    iR++; // 12
    sheet.getRangeByIndex(iR, 1).text = 'Sets [#]';
    sheet.getRangeByIndex(iR, 4).number = pre.sets.toDouble();

    // Reps
    iR++; // 13
    sheet.getRangeByIndex(iR, 1).text = 'Reps [#]';
    sheet.getRangeByIndex(iR, 4).number = pre.reps.toDouble();
  }

  // data headers
  iR += 2; // 15
  sheet.getRangeByIndex(iR, 1).setText('TIME [s]');
  sheet.getRangeByIndex(iR, 2).setText('LOAD [Kg]');

  for (final ChartData chartData in export.exportData) {
    iR++; // 16..N
    sheet.getRangeByIndex(iR, 1).number = chartData.time;
    sheet.getRangeByIndex(iR, 2).number = chartData.load;
  }

  // final ChartCollection charts = ChartCollection(sheet);
  // final Chart lineChart = charts.add();
  // lineChart.chartType = ExcelChartType.line;
  // lineChart.dataRange = sheet.getRangeByName('A1:C13');
  // lineChart.isSeriesInRows = false;
  // lineChart.chartTitleArea.bold = true;
  // lineChart.chartTitleArea.size = 11;
  // lineChart.chartTitleArea.color = '#595959';
  // lineChart.chartTitleArea.text = 'Internet Sales vs Reseller Sales';
  // lineChart.legend!.position = ExcelLegendPosition.bottom;
  // lineChart.legend!.textArea.size = 9;
  // lineChart.legend!.textArea.color = '#595959';
  // lineChart.topRow = 20;
  // lineChart.bottomRow = 32;
  // lineChart.leftColumn = 1;
  // lineChart.rightColumn = 8;
  // lineChart.primaryValueAxis.numberFormat = r'$#,###';
  // lineChart.primaryValueAxis.hasMajorGridLines = false;
  // lineChart.primaryCategoryAxis.titleArea.size = 9;
  // lineChart.primaryCategoryAxis.titleArea.color = '#595959';
  // lineChart.primaryValueAxis.titleArea.size = 9;
  // lineChart.primaryValueAxis.titleArea.color = '#595959';
  // sheet.charts = charts;

  final List<int> fileBytes = workbook.saveAsStream();
  final InputStream inputStream = InputStream(fileBytes);
  final ArchiveFile archiveFile = ArchiveFile.stream(export.fileName, inputStream.length, inputStream);
  workbook.dispose();

  return archiveFile;
}
