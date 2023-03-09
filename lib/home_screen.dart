//import 'package:beatcounter/main.dart';
import 'package:flutter/material.dart';

class home_screen extends StatefulWidget {
  const home_screen({Key? key}) : super(key: key);

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  var bpm;
  var bpermin;
  bool isnullbpm = true;
  List clickB = [];

  void click_button() {
    DateTime dt = DateTime.now();
    clickB.add(dt);

    if (clickB.length > 1) {
      DateTime startTime = DateTime.parse(clickB[0].toString());
      DateTime endTime = DateTime.parse(clickB[1].toString());

      Duration diffSec = endTime.difference(startTime);
      bpm = diffSec.inMilliseconds;
      bpermin = 60000 / bpm;
      bpermin = bpermin.ceil().toString();
      clickB.removeAt(0);
      isnullbpm = false;
    } else if (clickB.length == 1) {
      isnullbpm = true;
    }

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
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
                onPressed: click_button,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
