import 'package:flutter/material.dart';
import 'package:beatcounter/recordDb.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ListScreenPage extends StatefulWidget {
  const ListScreenPage({super.key});

  @override
  State<ListScreenPage> createState() => _ListScreenPageState();
}

class _ListScreenPageState extends State<ListScreenPage> {
  final DBHelper dbHelper = DBHelper();
  var chartData;

  //var items = List<String>.generate(100, (i) => 'Item $i');
  Future<List<DayRecords>> callAllrecord() async {
    chartData = await dbHelper.getAllRecord();
    if (chartData == null) {
    } else {}
    return chartData;
  }

  void viewRecord() {
    dbHelper.getAllRecord().then(
          (value) => value.forEach(
            (element) {
              print(
                  'id:${element.id}\n 호흡수:${element.whetSu}\n 날짜:${element.nalJja}');
            },
          ),
        );
  }

  Widget callListBuilder() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.data != null) {
          return ListView.builder(
            itemCount: projectSnap.data!.length,
            itemBuilder: (context, index) {
              DayRecords dayRecords = projectSnap.data![index];

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Padding(
                  //   padding: EdgeInsets.all(10),
                  //   child: Text(
                  //     dayRecords.id.toString(),
                  //     style: TextStyle(fontSize: 20),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      dayRecords.nalJja.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      dayRecords.whetSu.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return const Text('자료없음!');
        }
      },
      future: callAllrecord(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '리스트',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            '호흡수 측정기록',
          ),
          actions: [
            IconButton(
              iconSize: 35,
              onPressed: () {
                print('${dbHelper.getAllRecord()}');
              },
              icon: const Icon(Icons.delete),
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text('Record List'),
            ),
            Expanded(
              child: callListBuilder(),
            ),
            SfCartesianChart(
                // --------안되는 코드 시작
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: 'SRR'),
                legend: Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<DayRecords, String>>[
                  LineSeries<DayRecords, String>(
                    dataSource: chartData!,
                    xValueMapper: (DayRecords day, _) => day.nalJja,
                    yValueMapper: (DayRecords count, _) =>
                        int.parse(count.whetSu),
                    name: '횟수',
                    // Enable data label
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ]),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                //Initialize the spark charts widget
                child: SfSparkLineChart.custom(
                  //Enable the trackball
                  trackball: const SparkChartTrackball(
                      activationMode: SparkChartActivationMode.tap),
                  //Enable marker
                  marker: const SparkChartMarker(
                      displayMode: SparkChartMarkerDisplayMode.all),
                  //Enable data label
                  labelDisplayMode: SparkChartLabelDisplayMode.all,
                  xValueMapper: (int index) => chartData[index].nalJja,
                  yValueMapper: (int index) => chartData[index].whetSu,
                  dataCount: 5,
                ),
              ),
            ), // -----------안되는 코드 끝
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.backspace),
          onPressed: () {
            Navigator.of(this.context).pop();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
