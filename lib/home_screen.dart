//import 'package:beatcounter/main.dart';
import 'dart:math';
import 'package:beatcounter/record_db.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
  double eveFive = 0;
  String eveFives = "";
  bool isnullbpm = true; // 초기 입력값이 null일 경우
  Color btnVisible = Colors.white; // 저장버튼 보이기
  bool underFive = true;
  List clickB = [];
  List clickTotal = [];
  Color txtColor = Colors.black.withOpacity(0.6);

  void clickButton() {
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
      isnullbpm = false;

      clickTotal.add(double.parse(bpermin));
      if (clickTotal.length == 5) {
        eveFive = clickTotal.reduce((value, element) => value + element) / 5;
        eveFives = eveFive.ceil().toString();
        timesPermin = clickTotal.length;
        //clickTotal = [];
        underFive = false;
        if (eveFive <= 25) {
          txtChange = "정상입니다";
          txtColor = Colors.black.withOpacity(0.6);
          btnVisible = Colors.black;
        } else if (eveFive > 25 && eveFive <= 30) {
          txtChange = "높습니다. 매일측정권장";
          txtColor = Colors.blue;
          btnVisible = Colors.black;
        } else if (eveFive > 30) {
          txtChange = "주의! 병원으로 연락하세요.";
          txtColor = const Color.fromARGB(248, 245, 55, 84);
          btnVisible = Colors.black;
        }
      } else if (clickTotal.length == 11) {
        eveFive = clickTotal.reduce((value, element) => value + element) / 10;
        eveFives = eveFive.ceil().toString();
        timesPermin = clickTotal.length - 1;
        //clickTotal = [];
        underFive = false;
        if (eveFive <= 25) {
          txtChange = "정상입니다";
          txtColor = Colors.black.withOpacity(0.6);
          btnVisible = Colors.black;
        } else if (eveFive > 25 && eveFive <= 30) {
          txtChange = "높습니다. 매일측정권장";
          txtColor = txtColor = Colors.blue;
          btnVisible = Colors.black;
        } else if (eveFive > 30) {
          txtChange = "주의! 병원으로 연락하세요.";
          txtColor = const Color.fromARGB(248, 245, 55, 84);
          btnVisible = Colors.black;
        }
      } else if (clickTotal.length > 11) {
        clickRefresh();
      }
    } else if (clickB.length == 1) {
      isnullbpm = true;
    }

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
      btnVisible = Colors.white;
    });
  }

  void saveRc() {
    //Navigator.push(
    //    context, MaterialPageRoute(builder: (context) => record_db()),);
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
          title: const Text('Beat per Minute'),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              iconSize: 30,
              onPressed: () {},
              icon: const Icon(Icons.access_alarm),
            ),
            IconButton(
              iconSize: 50,
              onPressed: clickRefresh,
              icon: const Icon(Icons.refresh),
            ),
            const SizedBox(
              width: 30,
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  underFive
                      ? "아래 빨간 버튼을 호흡에 맞춰 탭하세요."
                      : "$timesPermin회 평균: $eveFives회/분, $txtChange",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: txtColor,
                    fontSize: 15,
                  ),
                ),
                Visibility(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.save_alt_rounded),
                    color: btnVisible,
                    iconSize: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green.withOpacity(0.6),
                        style: BorderStyle.solid,
                        width: 10,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      isnullbpm ? "0" : "$bpermin",
                      style: const TextStyle(
                        fontSize: 90,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  iconSize: 300,
                  icon: Icon(
                    Icons.monitor_heart_rounded,
                    weight: 0.1,
                    color: const Color.fromARGB(255, 241, 128, 137)
                        .withOpacity(0.6),
                  ),
                  onPressed: clickButton,
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'A'),
          BottomNavigationBarItem(icon: Icon(Icons.forward), label: 'Next'),
        ]),
      ),
    );
  }
}
