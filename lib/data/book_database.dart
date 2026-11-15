import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

/// Owns the single SQLite connection used by the book repository.
class BookDatabase {
  BookDatabase({DatabaseFactory? factory, this.databasePath})
    : _factory = factory ?? databaseFactory;

  final DatabaseFactory _factory;
  final String? databasePath;
  Future<Database>? _opening;

  Future<Database> get connection => _opening ??= _open();

  Future<Database> _open() async {
    final location = databasePath ??
        path.join(await _factory.getDatabasesPath(), 'myshelf.db');

    return _factory.openDatabase(
      location,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE books (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL CHECK (length(trim(title)) > 0),
              author TEXT NOT NULL CHECK (length(trim(author)) > 0),
              genre TEXT,
              description TEXT,
              notes TEXT,
              cover_path TEXT,
              status TEXT NOT NULL DEFAULT 'want_to_read'
                CHECK (status IN ('want_to_read', 'reading', 'completed', 'paused')),
              total_pages INTEGER CHECK (total_pages IS NULL OR total_pages > 0),
              current_page INTEGER NOT NULL DEFAULT 0 CHECK (current_page >= 0),
              is_favorite INTEGER NOT NULL DEFAULT 0 CHECK (is_favorite IN (0, 1)),
              created_at INTEGER NOT NULL,
              updated_at INTEGER NOT NULL,
              CHECK (total_pages IS NOT NULL OR current_page = 0),
              CHECK (total_pages IS NULL OR current_page <= total_pages)
            )
          ''');
          await db.execute(
            'CREATE INDEX books_status_idx ON books(status)',
          );
          await db.execute(
            'CREATE INDEX books_created_at_idx ON books(created_at DESC)',
          );
          await _createSettingsTable(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) await _createSettingsTable(db);
        },
      ),
    );
  }

  Future<void> _createSettingsTable(Database db) => db.execute('''
    CREATE TABLE app_settings (
      key TEXT PRIMARY KEY,
      value TEXT NOT NULL
    )
  ''');

  Future<void> close() async {
    final opening = _opening;
    _opening = null;
    if (opening != null) await (await opening).close();
  }
}
