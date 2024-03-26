import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static final _tableName = 'eventos';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'emergency.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT,
        titulo TEXT,
        descripcion TEXT,
        foto TEXT
      )
    ''');
  }

  Future<void> insertEvento(Map<String, dynamic> evento) async {
    final db = await database;
    await db.insert(_tableName, evento);
  }

  Future<List<Map<String, dynamic>>> getEventos() async {
    final db = await database;
    return await db.query(_tableName);
  }
}
