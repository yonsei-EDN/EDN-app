import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = 'memos';

class Spec {
  int? id;
  int type;
  String? category;
  int? method;
  String? contents;
  int money;
  String? dateTime;

  Spec(
      {this.id,
      required this.type,
      this.category,
      this.method,
      this.contents,
      required this.money,
      this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'category': category,
      'method': method,
      'contents': contents,
      'money': money,
      'dateTime': dateTime,
    };
  }
}

class SpecProvider {
  late Database _database;

  Future<Database?> get database async {
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'Specs.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
            CREATE TABLE Specs(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              type INTEGER NOT NULL,
              category TEXT,
              method INTEGER,
              contents TEXT,
              money INT NOT NULL,
              dateTime TEXT
            )
          ''');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  Future<List<Spec>> getDB() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(tableName);
    if (maps.isEmpty) return [];
    List<Spec> list = List.generate(maps.length, (index) {
      return Spec(
        id: maps[index]["id"],
        type: maps[index]["type"],
        category: maps[index]["category"],
        method: maps[index]["method"],
        contents: maps[index]["contents"],
        money: maps[index]["money"],
        dateTime: maps[index]["dateTime"],
      );
    });
    return list;
  }
}
