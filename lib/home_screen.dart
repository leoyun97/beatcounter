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
  Color txtColor = Color.fromARGB(249, 162, 239, 180);

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
          txtColor = Color.fromARGB(249, 162, 239, 180);
        } else if (eveFive > 25 && eveFive <= 30) {
          txtChange = "높습니다. 매일측정권장";
          txtColor = Color.fromARGB(248, 236, 144, 73);
        } else if (eveFive > 30) {
          txtChange = "주의! 병원으로 연락하세요.";
          txtColor = Color.fromARGB(248, 245, 55, 84);
        }
      } else if (clickTotal.length == 11) {
        eveFive = clickTotal.reduce((value, element) => value + element) / 10;
        eveFives = eveFive.ceil().toString();
        timesPermin = clickTotal.length - 1;
        //clickTotal = [];
        underFive = false;
        if (eveFive <= 25) {
          txtChange = "정상입니다";
          txtColor = Color.fromARGB(249, 162, 239, 180);
        } else if (eveFive > 25 && eveFive <= 30) {
          txtChange = "높습니다. 매일측정권장";
          txtColor = Color.fromARGB(248, 236, 144, 73);
        } else if (eveFive > 30) {
          txtChange = "주의! 병원으로 연락하세요.";
          txtColor = Color.fromARGB(248, 245, 55, 84);
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
    });
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    underFive
                        ? "아래 버튼을 탭하세요."
                        : "$timesPermin회 평균: $eveFives회/분, $txtChange",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: txtColor,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: true,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.save_alt_rounded),
                      color: Colors.white,
                      iconSize: 50,
                    ),
                  ),
                  Container(
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
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Transform.translate(
                    offset: const Offset(0, 110),
                    child: Text(
                      'TAP',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 200, 188, 188)
                            .withOpacity(0.5),
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -120),
                    child: IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      iconSize: 350,
                      icon: Icon(
                        Icons.monitor_heart_rounded,
                        color: const Color.fromARGB(255, 241, 128, 137)
                            .withOpacity(0.5),
                      ),
                      onPressed: clickButton,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
