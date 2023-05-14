//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:beatcounter/recordDb.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:flutter/rendering.dart';

//import 'dart:io';
import 'dart:async';
//import 'dart:ui' as ui;
//import 'dart:typed_data';
//import 'dart:convert';

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
  bool delAll = true;
  late int delIndex;

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

  void delSelection(int item) {
    switch (item) {
      case 0:
        delAll = true;
        delAllorNot();
        break;
      case 1:
        delAll = false;
        break;
    }
    setState(() {});
  }

  void delAllorNot() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          content: delAll
              ? const Text('측정된 기록 모두를 삭제하고 데이터를 초기화 하시겠습니까?')
              : Text('$delIndex번째 기록을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  delAll
                      ? dbHelper.deleteAllRecord()
                      : dbHelper.deleteRecord(delIndex);
                });

                // reloadPage();
              },
              child: const Text('삭제'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      dayRecords.id.toString(),
                      style: const TextStyle(
                        fontSize: 17,
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
                        fontSize: 17,
                        color: Color.fromARGB(255, 117, 117, 117),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      '${dayRecords.whetSu} 회/분',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 117, 117, 117),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Visibility(
                      //maintainAnimation: true,
                      //maintainSize: true,
                      //maintainState: true,
                      visible: delAll ? false : true,
                      child: TextButton(
                        child: const Text(
                          '삭제',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          delIndex = dayRecords.id;
                          delAll = false;
                          delAllorNot();
                        },
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
        backgroundColor:
            const Color.fromARGB(255, 245, 241, 241).withOpacity(0.9),
        appBar: AppBar(
          title: const Text(
            '호흡수 측정기록',
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(this.context).pop();
            },
            icon: const Icon(Icons.arrow_back_rounded),
            iconSize: 35,
          ),
          actions: <Widget>[
            PopupMenuButton<int>(
              onSelected: (item) => delSelection(item),
              itemBuilder: (context) => [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text('모두삭제'),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text('삭제'),
                )
              ],
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            /*const Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                '1분당 호흡수 리스트',
                style: TextStyle(
                    fontSize: 15, color: Color.fromARGB(255, 117, 117, 119)),
              ),
            ),*/
            Expanded(
              child: SfCartesianChart(
                zoomPanBehavior: _zoomPanBehavior,
                primaryXAxis: CategoryAxis(isInversed: true),
                title: ChartTitle(
                  text: 'Graph',
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 117, 117, 119),
                  ),
                ),
                backgroundColor: Color.fromARGB(255, 248, 244, 244),
                borderColor: const Color.fromARGB(255, 26, 31, 172),
                legend: Legend(isVisible: false),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: callListBuilder(),
              ), //callListBuilder(),
            ),
          ],
        ),
      ),
    );
  }
}
