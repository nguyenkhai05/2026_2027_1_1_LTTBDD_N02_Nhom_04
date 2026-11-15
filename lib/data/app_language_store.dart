import 'package:sqflite/sqflite.dart';

import '../models/app_language.dart';
import 'book_database.dart';

abstract interface class AppLanguageStore {
  Future<AppLanguage> load();
  Future<void> save(AppLanguage language);
}

class SqliteAppLanguageStore implements AppLanguageStore {
  SqliteAppLanguageStore(this.database);

  final BookDatabase database;
  static const _key = 'language';

  @override
  Future<AppLanguage> load() async {
    final db = await database.connection;
    final rows = await db.query('app_settings',
        columns: ['value'], where: 'key = ?', whereArgs: [_key], limit: 1);
    return AppLanguage.fromCode(rows.isEmpty ? null : rows.single['value'] as String?);
  }

  @override
  Future<void> save(AppLanguage language) async {
    final db = await database.connection;
    await db.insert('app_settings', {'key': _key, 'value': language.code},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
