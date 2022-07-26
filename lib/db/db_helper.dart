import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static const int version = 1;
  static const String tableName = 'tasks';

//initialize the database
 static Future<void>initDb()async{
    if(_db==null){
      print('database trying to initialize');
      try{
        String _path = await getDatabasesPath() + 'tasks.db';
        _db = await openDatabase(
          _path,
          version: version,
          onCreate: (Database db, int version) async {
            await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            note TEXT,
            isCompleted INTEGER,
            date TEXT,
            startTime TEXT,
            endTime TEXT,
            color INTEGER,
            remind INTEGER,
            repeat TEXT
          )
          ''');
          },
        );
      }catch(e){
        print(e);
      }
    }else{
      print('db is not null');
    }
  }
//insert task into database
  static Future<int> insertTask(Task task) async {
   print('insert task called');
     return await _db!.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

  }
//delete task from database
  static Future<void> deleteTask(int id) async {
   print('delete task id: $id');
    try {
      await _db!.delete(tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print(e);
    }
  }

//delete all tasks
  static Future<void> deleteAllTask() async {
      await _db!.delete(tableName).then((value){
         print('success delete all tasks ');
      }).catchError((error){
        print(error.toString());
      });
  }
//update task in database
  static Future<void> updateTask(int id) async {
    try {
      print('update task called');
      await _db!.rawUpdate(
          '''
          UPDATE $tableName,
          SET isCompleted = ?,
          WHERE id = ?
          ''',
          [1, id]);
    } catch (e) {
      print(e);
    }
  }
  //query database
  static Future< List<Map<String, dynamic>>> query() async {
   print('query called');
     return await _db!.query(tableName);
  }




}
