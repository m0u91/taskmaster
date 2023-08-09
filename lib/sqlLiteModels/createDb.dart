
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'tasksModel.dart';


class Sql{
  static Database? _db;
  Future<Database?> get db async {
    if(_db == null){
      _db = await intialDb();
      return _db;
    }else{
      return _db;
    }
  }

  intialDb()async{
    String dbPath = await getDatabasesPath();
    String path = join(dbPath,'taskmanager.db');
    Database myDb = await openDatabase(path,onCreate: onCreate,version: 2,onUpgrade: onUpgrade);
    return myDb;
  }
  onCreate(Database db, int version){
    db.execute('''
    create table "taskTable" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT ,
    "name" TEXT , 
    "des" TEXT , 
    "done" INTEGER DEFAULT 0 , 
    "create" TEXT , 
    "images" TEXT , 
    "notification" INTEGER DEFAULT 0 , 
    "date" TEXT   
    )
    ''');
    print('create done');
  }
  onUpgrade(Database db, int oldVersion, int newVersion){
    db.execute('''
    create table "taskTable" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT ,
    "name" TEXT , 
    "des" TEXT , 
    "done" INTEGER DEFAULT 0 , 
    "create" TEXT , 
    "images" TEXT , 
    "notification" INTEGER DEFAULT 0 , 
    "date" TEXT  
    )
    ''');
    print('update done');
  }
  Future<List<TasksModel>> readDataSql(String table)async{
    Database? myDb = await db;
    List<Map<String,dynamic>> maps = await myDb!.query(table);
    return List.generate(maps.length, (i) {
      return TasksModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        des: maps[i]['des'],
        images: maps[i]['images'],
        date: maps[i]['date'],
        create: maps[i]['create'],
        done: maps[i]['done'],
        notification: maps[i]['notification'],
      );
    });
  }
  Future<List<TasksModel>> readDataSqlOne(String table)async{
    Database? myDb = await db;
    List<Map<String,dynamic>> maps = await myDb!.query(table);
    return List.generate(maps.length, (i) {
      return TasksModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        des: maps[i]['des'],
        images: maps[i]['images'],
        date: maps[i]['date'],
        create: maps[i]['create'],
        done: maps[i]['done'],
        notification: maps[i]['notification'],
      );
    });
  }

  insertDataSql(table,Map<String, dynamic> sql,tableNameDocument)async{
    Database? myDb = await db;
    //onCreate(myDb!,3,tableNameDocument);
    int response = await myDb!.insert(table, sql);
    //await myDb.insert(tableNameDocument, sql);
    return response;
  }

  updateDataSql(String table,TasksModel sql,String wher,id,tableNameDocument)async{
    Database? myDb = await db;
    int response = await myDb!.update(table,sql.toMap(),where: wher,whereArgs: [id]);
    return response;
  }

  deleteDataSql(String table,String wher,id)async{
    Database? myDb = await db;
    int response = await myDb!.delete(table,where: wher,whereArgs: [id]);
    return response;
  }

}