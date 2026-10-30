import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class AuthService {
  static final AuthService instance = AuthService._init();
  static Database? _database;

  AuthService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    // Inicializa a fábrica do FFI para ambiente desktop
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    _database = await _initAuthDB('p2_elias_auth.db');
    return _database!;
  }

  Future<Database> _initAuthDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Registar novo utilizador
  Future<bool> register(String email, String password) async {
    try {
      final db = await database;
      await db.insert('users', {
        'email': email,
        'password': password,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Validar login
  Future<bool> login(String email, String password) async {
    try {
      final db = await database;
      final result = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}