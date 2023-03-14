import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  main_sub();
}

void main_sub() async {
  //DB 경로지정 및 테이블 생성
  final recordDb = openDatabase(
    join(await getDatabasesPath(), 'srrDb.db'),
    //데이터베이스가 처음 생성될때 Record를 저장하기위한 테이블을 생성
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE dailyRecord(id INTEGER PRIMARY KEY, whetSu TEXT, nalJja TEXT)",
      );
    },
    version: 1, //버전설정 하면 업그레이드와 다운그레이드를 수행하기 위한 경로 제공
  );

  Future<List<DayRecords>> dailyRecord() async {
    //데이터베이스 reference를 얻습니다.
    final Database db = await recordDb;

    //모든 dailyRecord의 자료를 얻기 위해 테이블에 질의
    final List<Map<String, dynamic>> maps = await db.query('dailyRecord');

    //List<Map<String,dynamic>>을 List<Dog?으로 변환합니다.

    return List.generate(maps.length, (i) {
      return DayRecords(
        id: maps[i]['id'],
        whetSu: maps[i]['whetSu'],
        nalJja: maps[i]['nalJja'],
      );
    });
  }

  Future<void> inSertRecord(DayRecords dailyRecord) async {
    //데이터베이스 reference를 얻음
    final Database db = await recordDb;

    await db.insert(
      'dailyRecord',
      dailyRecord.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  final addR1 = DayRecords(
    id: 0,
    whetSu: "20",
    nalJja: '2023 - 03 - 15',
  );
  await inSertRecord(addR1);
  print(await dailyRecord());
}

class DayRecords {
  //테이블과 코드상 위젯 연결
  final int id;
  final String whetSu;
  final String nalJja;

  DayRecords({required this.id, required this.whetSu, required this.nalJja});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'whetSu': whetSu,
      'nalJja': nalJja,
    };
  }
}
