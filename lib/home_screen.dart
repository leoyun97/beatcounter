//import 'package:beatcounter/main.dart';
import 'dart:math';

import 'package:flutter/material.dart';

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
  bool underFive = true;
  List clickB = [];
  List clickTotal = [];

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
        if (eveFive < 25) {
          txtChange = "정상입니다";
        } else if (eveFive > 25 && eveFive < 35) {
          txtChange = "높습니다.";
        } else if (eveFive > 35) {
          txtChange = "위험! 병원으로 연락주세요.";
        }
      } else if (clickTotal.length == 11) {
        eveFive = clickTotal.reduce((value, element) => value + element) / 10;
        eveFives = eveFive.ceil().toString();
        timesPermin = clickTotal.length - 1;
        //clickTotal = [];
        if (eveFive > 25 && eveFive < 35) {
          txtChange = "높습니다.";
        } else if (eveFive > 35) {
          txtChange = "위험! 병원으로 연락주세요.";
        }
        underFive = false;
      } else if (clickTotal.length > 11) {
        clickRefresh();
      }
    } else if (clickB.length == 1) {
      isnullbpm = true;
    }

    print("$clickTotal");
    print("$eveFives");
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
    });
  }

  void showAlert() {
    setState(() {});
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
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Beat per Minute'),
          backgroundColor: Colors.black,
          actions: [
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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Text(
                  underFive ? "" : "$timesPermin회 평균: $eveFives회/분, $txtChange",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    style: BorderStyle.solid,
                    width: 10,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  isnullbpm ? "0" : "$bpermin",
                  style: const TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                iconSize: 350,
                icon: const Icon(
                  Icons.monitor_heart_rounded,
                  color: Color.fromARGB(255, 97, 61, 240),
                ),
                onPressed: clickButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
