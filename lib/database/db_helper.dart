import 'package:module_5/model/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dbhelper {
  static const DB_NAME = 'TASK_DB';
  static const DB_VERSION = 1;

  static const TABLE_NAME = 'Task';

  static final COL_ID = 'id';
  static final COL_NAME = 'name';
  static final COL_DESCRIPTION = 'description';
  static final COL_PRIORITY = 'priority';
  static final COL_CREATE_AT = 'createdAt';
  static final COL_COMPLETE = 'complete';

  static final _instance = Dbhelper._internal();

  Dbhelper._internal();

  factory Dbhelper() {
    return _instance;
  }

  static Database? _database;

  Future<Database?> getDatabase() async {
    _database = await createDatabase();
    return _database;
  }

  Future<Database?> createDatabase() async {
    var dbpath = await getDatabasesPath();
    var dbname = 'TASK_DB';

    var path = join(dbpath, dbname);
    print('path : $path');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE $TABLE_NAME ('
            '$COL_ID INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$COL_NAME TEXT NOT NULL, '
            '$COL_DESCRIPTION TEXT NOT NULL, '
            '$COL_PRIORITY TEXT NOT NULL, '
            '$COL_COMPLETE TEXT NOT NULL, '
            '$COL_CREATE_AT INTEGER)');
      },
    );
  }

  Future<int> insertRecord(Task task) async {
    Database? db = await getDatabase();
    if (db != null) {
      return db.insert(TABLE_NAME, task.toMap());
    }
    return -1;
  }

  Future<List<Task>> getAllData() async {
    Database? db = await getDatabase();
    List<Map<String, dynamic>> mapList = await db!.query(TABLE_NAME);
    return List.generate(
        mapList.length, (index) => Task.fromMap(mapList[index])).toList();
  }

  Future<int> updateRecord(Task task) async {
    Database? db = await getDatabase();
    if (db != null) {
      return db.update(TABLE_NAME, {COL_COMPLETE: 'true'},
          whereArgs: [task.id], where: "$COL_ID = ?");
    }
    return -1;
  }

  Future<int> deleteRecord(Task task) async {
    Database? db = await getDatabase();
    if (db != null) {
      return db.delete(TABLE_NAME, where: '$COL_ID = ?', whereArgs: [task.id]);
    }
    return -1;
  }
}
