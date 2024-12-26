import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'smart_recycle.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE user_auth (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uid TEXT NOT NULL,
            email TEXT,
            displayName TEXT,
            lastLoginAt INTEGER
          )
        ''');
      },
    );
  }

  Future<void> saveUserAuth(User user) async {
    final Database db = await database;
    
    // 清除旧数据
    await db.delete('user_auth');
    
    // 插入新数据
    await db.insert('user_auth', {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'lastLoginAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<Map<String, dynamic>?> getLastUser() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'user_auth',
      orderBy: 'lastLoginAt DESC',
      limit: 1,
    );
    
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<void> clearUserAuth() async {
    final Database db = await database;
    await db.delete('user_auth');
  }
} 