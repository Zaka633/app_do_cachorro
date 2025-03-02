import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'doguinhos.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE doguinhos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        raca TEXT,
        peso REAL,
        idade INTEGER,
        telefone TEXT,
        imagem TEXT,
        dataAdicao TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE doguinhos ADD COLUMN dataAdicao TEXT');
    }
  }

  Future<int> insertDog(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('doguinhos', row);
  }

  Future<List<Map<String, dynamic>>> queryAllDogs() async {
    Database db = await database;
    return await db.query('doguinhos', orderBy: 'dataAdicao DESC');
  }

  Future<void> deleteDog(int id) async {
    final db = await database;
    await db.delete('doguinhos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateDog(Map<String, dynamic> row) async {
    final db = await database;
    int id = row['id'];
    return await db.update('doguinhos', row, where: 'id = ?', whereArgs: [id]);
  }
}
