import 'package:beatcounter/main.dart';
import 'package:flutter/material.dart';

//void main() => runApp(home_screen());

class home_screen extends StatefulWidget {
  const home_screen({Key? key}) : super(key: key);

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  var bpm;
  var bpermin;
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
      if (bpermin < 0) {
        bpermin = 0;
      }
      ;
      bpermin = bpermin.ceil().toString();
      clickB.removeAt(0);
    }
    ;

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
          title: Text('Beat per Minute'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  //color: Colors.red,
                  border: Border.all(
                    color: Colors.green,
                    style: BorderStyle.solid,
                    width: 10,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "${bpermin}",
                  style: TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              Container(
                child: IconButton(
                  iconSize: 300,
                  icon: const Icon(
                    Icons.radio_button_checked_rounded,
                    color: Colors.deepOrange,
                  ),
                  onPressed: click_button,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
