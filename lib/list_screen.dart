import 'package:flutter/material.dart';
import 'package:beatcounter/recordDb.dart';
import 'package:flutter/src/rendering/box.dart';

class ListScreenPage extends StatefulWidget {
  const ListScreenPage({super.key});

  @override
  State<ListScreenPage> createState() => _ListScreenPageState();
}

class _ListScreenPageState extends State<ListScreenPage> {
  final DBHelper dbHelper = DBHelper();

  //var items = List<String>.generate(100, (i) => 'Item $i');
  Future<List<DayRecords>> callAllrecord() async {
    return await dbHelper.getAllRecord();
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
                    padding: EdgeInsets.all(10),
                    child: Text(
                      dayRecords.nalJja.toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      dayRecords.whetSu.toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return Container(
            child: const Text('자료없음!'),
          );
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
              onPressed: () {},
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
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text('Record Graph'),
            ),
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
