import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

//참고 싸이트
//https://velog.io/@jong/Flutter-sqlite-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0

class DayRecords {
  final int id;
  final String whetSu;
  final String nalJja;

  DayRecords({
    required this.id,
    required this.whetSu,
    required this.nalJja,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'whetSu': whetSu,
      'nalJja': nalJja,
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id, whetSu: $whetSu, age: $nalJja}';
  }
}

final String TableName = 'DayRecords';

class DBHelper {
  var _db;

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = openDatabase(join(await getDatabasesPath(), 'srrDb.db'),
        onCreate: (db, version) => _createDb(db), version: 1);
    return _db;
  }

  static void _createDb(Database db) {
    db.execute(
      "CREATE TABLE $TableName(id INTEGER PRIMARY KEY, whetSu TEXT, nalJja TEXT)",
    );
  }

//Insert
  Future<void> insertRecord(DayRecords dayRecords) async {
    final db = await database;

    await db.insert("$TableName", dayRecords.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<DayRecords>> getAllRecord() async {
    final db = await database;

    //final List<Map<String, dynamic>> maps = await db.query('$TableName');
    final List<Map<String, dynamic>> maps =
        await db.query('$TableName', orderBy: 'id DESC');
        //await db.query('$TableName');

    return List.generate(maps.length, (i) {
      return DayRecords(
        id: maps[i]['id'],
        whetSu: maps[i]['whetSu'],
        nalJja: maps[i]['nalJja'],
      );
    });
  }

  //id에 해당하는 레코드보기
  Future<dynamic> getRecord(int id) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = (await db.query(
      '$TableName',
      where: 'id = ?',
      whereArgs: [id],
    ));

    return maps.isNotEmpty ? maps : null;
  }

  //수정
  Future<void> updateRecord(DayRecords dayRecords) async {
    final db = await database;

    await db.update(
      "$TableName",
      dayRecords.toMap(),
      where: "id = ?",
      whereArgs: [dayRecords.id],
    );
  }

  //삭제
  Future<void> deleteRecord(int id) async {
    final db = await database;

    await db.delete(
      "$TableName",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAllRecord() async {
    final db = await database;
    await db.delete("$TableName");
    //await db.close();
  }

  Future<String> getDBrawcount() async {
    //int rawCount;
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName');
    String rawCount = res.last['id'].toString(); //카운트 숫자만 가져옴
    return rawCount;
  }

  Future<String> getDBIntactRawcount() async {
    //삭제전 전체 카운트
    //int rawCount;
    final db = await database;
    var res = await db.rawQuery('SELECT COUNT (*) FROM $TableName');
    String rawCount = Sqflite.firstIntValue(res).toString(); //카운트 숫자만 가져옴
    return rawCount;
  }
}

//특정 id에 해당하는 기록불러오기 -> 아래 주석부분을 실행하는곳(home_screen.dart)에 붙여넣기

/*
DBHelper dbHelper = DBHelper();

dbHelper.getRecord(12).then((value) {
if (value is List<Map<String, dynamic>>) {
value.forEach((element) {
element.forEach((key, value) {
print('$key: $value');
});
});
} else {
print('null');
}
});
*/
