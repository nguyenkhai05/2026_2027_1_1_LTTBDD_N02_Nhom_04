import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/data/app_language_store.dart';
import 'package:lt_tbdd/data/book_database.dart';
import 'package:lt_tbdd/models/app_language.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  test('language persists across database reopening', () async {
    final dir = await Directory.systemTemp.createTemp('myshelf_lang_');
    final file = path.join(dir.path, 'books.db');
    var db = BookDatabase(factory: databaseFactoryFfi, databasePath: file);
    try {
      var store = SqliteAppLanguageStore(db);
      expect(await store.load(), AppLanguage.vietnamese);
      await store.save(AppLanguage.english);
      await db.close();
      db = BookDatabase(factory: databaseFactoryFfi, databasePath: file);
      store = SqliteAppLanguageStore(db);
      expect(await store.load(), AppLanguage.english);
      await store.save(AppLanguage.vietnamese);
      expect(await store.load(), AppLanguage.vietnamese);
    } finally {
      await db.close();
      await dir.delete(recursive: true);
    }
  });

  test('version 1 book database upgrades without removing books', () async {
    final dir = await Directory.systemTemp.createTemp('myshelf_upgrade_');
    final file = path.join(dir.path, 'books.db');
    final old = await databaseFactoryFfi.openDatabase(file,
        options: OpenDatabaseOptions(version: 1, onCreate: (db, _) async {
      await db.execute('CREATE TABLE books (id INTEGER PRIMARY KEY, title TEXT)');
      await db.insert('books', {'id': 1, 'title': 'Sách cũ'});
    }));
    await old.close();

    final db = BookDatabase(factory: databaseFactoryFfi, databasePath: file);
    try {
      expect(await SqliteAppLanguageStore(db).load(), AppLanguage.vietnamese);
      final rows = await (await db.connection).query('books');
      expect(rows.single['title'], 'Sách cũ');
    } finally {
      await db.close();
      await dir.delete(recursive: true);
    }
  });
}
