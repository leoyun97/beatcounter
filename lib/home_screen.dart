//import 'package:beatcounter/main.dart';
//import 'dart:math';
import 'package:beatcounter/list_screen.dart';
import 'package:beatcounter/recordDb.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/foundation.dart';
//import 'package:flutter/gestures.dart';
//import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class home_screen extends StatefulWidget {
  const home_screen({Key? key}) : super(key: key);

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  var bpm;
  var bpermin;
  String txtChange = "정상입니다.";
  int timesPermin = 0;
  int rawCounts = 0; //데이터 수
  double eveFive = 0;
  String eveFives = "";
  bool isnullbpm = true; // 초기 입력값이 null일 경우
  bool btnVisible = false; // 저장버튼 보이기
  bool btnVisibleRef = false;
  bool startClick = true;
  bool clickedOrNot = true; //클릭할때마다 버튼 모양 바꾸기
  bool underFive = true; // 깊이 잠들었을때 클릭하라는 멘트 보이기
  List clickB = [];
  List clickTotal = []; //클릭 때마다 추가되는 데이타 리스트
  Color txtColor = Colors.black.withOpacity(0.6);
  final DBHelper dbHelper = DBHelper();

  void clickButton() {
    isnullbpm = false;

    DateTime dt = DateTime.now();
    clickB.add(dt);

    if (clickB.length > 1) {
      DateTime startTime = DateTime.parse(clickB[0].toString());
      DateTime endTime = DateTime.parse(clickB[1].toString());

      Duration diffSec = endTime.difference(startTime);
      bpm = diffSec.inMilliseconds; //밀리세컨으로 변환해서
      bpermin = 60000 / bpm; //1분의 밀리세컨을 bpm으로 나눠서 횟수 구함

      bpermin = bpermin.ceil().toString(); // ceil-> 반올림 함수 사용

      clickB.removeAt(0); //배열에서 첫번째값을 삭제
      startClick = true;

      clickTotal.add(double.parse(bpermin));
      if (clickTotal.length == 5) {
        eveFive = clickTotal.reduce((value, element) => value + element) / 5;
        eveFives = eveFive.ceil().toString();
        timesPermin = clickTotal.length;
        underFive = false;
        if (eveFive <= 25) {
          txtChange = "정상입니다";
          txtColor = Colors.black.withOpacity(0.6);
          btnVisible = true;
        } else if (eveFive > 25 && eveFive <= 30) {
          txtChange = "높습니다. 매일측정권장";
          txtColor = Colors.blue;
          btnVisible = true;
        } else if (eveFive > 30 && eveFive < 40) {
          txtChange = "주의! 병원으로 연락하세요.";
          txtColor = const Color.fromARGB(248, 245, 55, 204);
          btnVisible = true;
        } else if (eveFive >= 40) {
          txtChange = "경고! 병원으로 즉시 연락하세요.";
          txtColor = const Color.fromARGB(248, 245, 55, 84);
          btnVisible = true;
        }
      } else if (clickTotal.length == 10) {
        eveFive = clickTotal.reduce((value, element) => value + element) / 10;
        eveFives = eveFive.ceil().toString();
        timesPermin = clickTotal.length;
        //clickTotal = [];
        underFive = false;
        if (eveFive <= 25) {
          txtChange = "정상입니다";
          txtColor = Colors.black.withOpacity(0.6);
          btnVisible = true;
        } else if (eveFive > 25 && eveFive <= 30) {
          txtChange = "높습니다. 매일측정권장";
          txtColor = txtColor = Colors.blue;
          btnVisible = true;
        } else if (eveFive > 30 && eveFive < 40) {
          txtChange = "주의! 병원으로 연락하세요.";
          txtColor = const Color.fromARGB(248, 245, 55, 204);
          btnVisible = true;
        } else if (eveFive >= 40) {
          txtChange = "경고! 병원으로 즉시 연락하세요.";
          txtColor = const Color.fromARGB(248, 245, 55, 84);
          btnVisible = true;
        }
      } else if (clickTotal.length > 10) {
        clickRefresh();
      }
    } else if (clickB.length == 1) {
      startClick = false;
      btnVisibleRef = true;
      bpermin = 'START';
    }

    //print(clickTotal.toList()); //Delete
    setState(() {});
  }

  void clickRefresh() {
    setState(() {
      bpm = null;
      bpermin = null;
      clickB = [];
      clickTotal = [];
      eveFive = 0;
      eveFives = "";
      isnullbpm = true;
      underFive = true;
      txtColor = Colors.black.withOpacity(0.6);
      btnVisible = false;
      btnVisibleRef = false;
      startClick = true;
    });
  }

  void clickedBtn() {
    setState(
      () {
        if (clickedOrNot == true) {
          clickedOrNot == false;
        } else if (clickedOrNot == false) {
          clickedOrNot == true;
        }
      },
    );
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

  void insertRecord() async {
    DateTime now = DateTime.now();
    String dt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    String rawCount = await dbHelper.getDBrawcount();
    rawCounts = int.parse(rawCount) + 1;

    dbHelper.insertRecord(
      DayRecords(
        id: rawCounts,
        whetSu: eveFives,
        nalJja: dt,
      ),
    );
    setState(() {
      //btnVisible = false;
      clickRefresh();
    });
  }

  void deleteAllrecords() {
    dbHelper.deleteAllRecord();
  }

  void gotoPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ListScreenPage(),
        fullscreenDialog: false,
      ),
    );
  }

  void showAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          content: Text('$timesPermin회 평균 호흡수를 저장하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                insertRecord();
              },
              child: const Text('저장'),
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

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SRR측정보조',
      home: Scaffold(
        //backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            '호흡수 측정',
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () => gotoPage(),
            icon: const Icon(Icons.insert_chart_outlined_rounded),
            iconSize: 40,
          ),
          /*actions: [
            IconButton(
              iconSize: 35,
              onPressed: () {},
              icon: const Icon(Icons.list),
            ),
          ],*/
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 80.0, 30.0, 50.0),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 197, 198, 197)
                              .withOpacity(0.6),
                          style: BorderStyle.solid,
                          width: 10,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: SizedBox(
                        height: 100,
                        child: Text(
                          isnullbpm ? "0" : "$bpermin",
                          style: startClick
                              ? const TextStyle(
                                  fontSize: 90,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )
                              : const TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 220, 104, 104),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    underFive
                        ? "깊게 잠들었을 때 들숨일때만 아래 버튼을 탭하세요."
                        : "$timesPermin회 평균: $eveFives회/분, $txtChange",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: txtColor,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Visibility(
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        visible: btnVisible,
                        child: ElevatedButton(
                          onPressed: () => showAlert(), //insertRecord,
                          child: const Text(
                            '저장',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        maintainAnimation: true,
                        maintainSize: true,
                        maintainState: true,
                        visible: btnVisibleRef,
                        child: IconButton(
                          color: Colors.black.withOpacity(0.6),
                          iconSize: 50,
                          onPressed: () => clickRefresh(),
                          icon: const Icon(Icons.refresh),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    iconSize: 300,
                    icon: Icon(
                      clickedOrNot
                          ? Icons.monitor_heart
                          : Icons.monitor_heart_outlined,
                      weight: 0.1,
                      color: const Color.fromARGB(255, 241, 128, 137)
                          .withOpacity(0.6),
                    ),
                    onPressed: () {
                      clickButton();
                      clickedBtn();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        /*bottomNavigationBar: BottomNavigationBar(items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'A'),
          BottomNavigationBarItem(icon: Icon(Icons.forward), label: 'Next'),
        ]),*/
      ),
    );
  }
}
