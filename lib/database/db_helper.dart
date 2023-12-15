import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "tasks";
  // initilization of database
  static Future<void> initDB() async {
    if (_db != null) {
      debugPrint('not null db');
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'task.db';
      debugPrint('in database path');
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (Database db, int version) async {
          debugPrint('Create new one'); // when create db create table
          return db.execute(
            'CREATE TABLE $_tableName('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'title STRING,note TEXT,date STRING,'
            'startTime STRING,endTime STRING,'
            'color INTEGER,'
            'isCompleted INTEGER)',
          );
        },
      );
      print('DATA Base Created');
    } catch (e) {
      print(e);
    }
  }

  // insert taks in db
  static Future<int> insert(Task? task) async {
    print('Insert method called');
    try {
      return await _db!.insert(_tableName, task!.toJson());
    } catch (e) {
      print('we are here!');
      return 90000;
    }
  }

// delete task
  static Future<int> delete(Task task) async {
    print('delete method called');
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [
      task.id
    ]); // ?s in the where clause, which will be replaced by the values from [whereArgs]
  }

// deleteAll tasks
  static Future<int> deleteAll() async {
    print('deleteAll method called');
    return await _db!.delete(_tableName); // will delete the entire table
  }

  // read contents of table
  static Future<List<Map<String, dynamic>>> query() async {
    print('query method called');
    return await _db!.query(_tableName);
  }

// update task
 static Future<int>update(int id)async{
    print('Update function called');
    return await _db!.rawUpdate(''' 
       UPDATE tasks
       SET  isCompleted = ?
       WHERE   id = ?
    ''',[1,id]);
 }
}
