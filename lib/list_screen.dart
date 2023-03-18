import 'package:flutter/material.dart';
import 'package:beatcounter/recordDb.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ListScreenPage extends StatefulWidget {
  const ListScreenPage({super.key});

  @override
  State<ListScreenPage> createState() => _ListScreenPageState();
}

class _ListScreenPageState extends State<ListScreenPage> {
  final DBHelper dbHelper = DBHelper();
  List<DayRecords> chartData = <DayRecords>[];
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    siJacfuc();

    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
    );

    super.initState();
  }

  void siJacfuc() async {
    chartData = await dbHelper.getAllRecord();
    setState(() {});
  }

  void showAlert() {
    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          content: Text('측정된 기록 모두를 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(this.context).pop();
                dbHelper.deleteAllRecord();
              },
              child: const Text('모두삭제'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(this.context).pop();
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  Future<List<DayRecords>> callAllrecord() async {
    return await dbHelper.getAllRecord();
  }

  /*  void viewRecord() {
    dbHelper.getAllRecord().then(
          (value) => value.forEach(
            (element) {
              print(
                  'id:${element.id}\n 호흡수:${element.whetSu}\n 날짜:${element.nalJja}');
            },
          ),
        );
  } */

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
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      dayRecords.id.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      dayRecords.nalJja.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 117, 117, 117),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      dayRecords.whetSu.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 117, 117, 117),
                      ),
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
          leading: IconButton(
            onPressed: () {
              Navigator.of(this.context).pop();
            },
            icon: const Icon(Icons.arrow_circle_left_rounded),
            iconSize: 30,
          ),
          actions: [
            IconButton(
              iconSize: 35,
              onPressed: () => showAlert(),
              icon: const Icon(Icons.delete),
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                '1분당 호흡수 리스트',
                style: TextStyle(
                    fontSize: 15, color: Color.fromARGB(255, 117, 117, 119)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: callListBuilder(),
              ), //callListBuilder(),
            ),
            /* ElevatedButton(
                onPressed: () async {
                  chartData = await dbHelper.getAllRecord();
                  setState(() {});
                },
                child: Text('그래프보기')), */
            Expanded(
              child: SfCartesianChart(
                zoomPanBehavior: _zoomPanBehavior,
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(
                  text: 'Graph',
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 117, 117, 119),
                  ),
                ),
                borderColor: Color.fromARGB(255, 26, 31, 172),
                legend: Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<DayRecords, String>>[
                  LineSeries<DayRecords, String>(
                    dataSource: chartData,
                    xValueMapper: (DayRecords day, _) => day.nalJja.toString(),
                    yValueMapper: (DayRecords count, _) =>
                        int.parse(count.whetSu),
                    name: 'SRR',
                    // Enable data label
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
