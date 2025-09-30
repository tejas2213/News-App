import 'package:news_app/features/news/data/models/news_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:news_app/core/constants/app_constants.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(AppConstants.databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE news (
        article_id TEXT PRIMARY KEY,
        title TEXT,
        link TEXT,
        creator TEXT,
        description TEXT,
        content TEXT,
        pubDate TEXT,
        image_url TEXT,
        source_id TEXT,
        source_name TEXT
      )
    ''');
  }

  Future<List<NewsModel>> getNews() async {
    final db = await instance.database;
    final result = await db.query('news');
    return result.map((json) => NewsModel.fromDbMap(json)).toList();
  }

  Future<int> insertNews(NewsModel news) async {
    final db = await instance.database;
    return await db.insert(
      'news',
      news.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteNews(String articleId) async {
    final db = await instance.database;
    return await db.delete(
      'news',
      where: 'article_id = ?',
      whereArgs: [articleId],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
