import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'profile.dart';

class DatabaseHelper {
  static const _databaseName = "profiles.db";
  static const _databaseVersion = 1;

  static const table = 'profiles';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnMacAddress = 'macAddress';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnMacAddress TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Profile profile) async {
    Database db = await instance.database;
    return await db.insert(table, profile.toMap());
  }

  Future<List<Profile>> getProfiles() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Profile.fromMap(maps[i]);
    });
  }

  Future<int> update(Profile profile) async {
    Database db = await instance.database;
    return await db.update(table, profile.toMap(),
        where: '$columnId = ?', whereArgs: [profile.id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
