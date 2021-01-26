import 'package:sqflite/sqflite.dart';

import 'AlarmInfo.dart';

final String alarm = 'amitAlar';
final String columnId = 'id';
final String columntitle = 'title';
final String columnDateTime = 'alarmDateTime';
final String columnSunday = 'sunday';
final String columnAlarmId = 'alarmId';
final String columnDaysOn = 'dayson';

class Data {
  static Database _database;
  static Data _data;
  Data._createInstance();
  factory Data() {
    if (_data == null) {
      _data = Data._createInstance();
    }
    return _data;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "amitAlar.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE $alarm(
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columntitle TEXT NOT NULL,
          $columnAlarmId INTEGER,
          $columnDateTime TEXT NOT NULL,
          $columnDaysOn UINT8LIST
          )        
         ''');
      },
    );
    return database;
  }

  void inserAalarm(AlarmInfo alarmInfo) async {
    var db = await this.database;
    var result = await db.insert(alarm, alarmInfo.toJson());
    print('$result');
    print('success');
  }

  Future<List<AlarmInfo>> getAlarms() async {
    var db = await this.database;
    var result = await db.query(alarm);
    List<AlarmInfo> _alarms = result.isNotEmpty
        ? result.map((element) => AlarmInfo.fromJson(element)).toList()
        : [];

    return _alarms;
  }

  Future deleteAlarms(int id) async {
    var db = await this.database;
    var count = await db.delete(alarm, where: 'id = ?', whereArgs: [id]);
    print('---deleting');
    print(count.toString());
    return count;
  }
}

//var count = await db.delete('my_table', where: 'name = ?', whereArgs: ['cat']);
