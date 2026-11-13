import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/data/book_database.dart';
import 'package:lt_tbdd/data/book_repository.dart';
import 'package:lt_tbdd/models/book.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  test('books survive reopening the database and support CRUD', () async {
    final directory = await Directory.systemTemp.createTemp('myshelf_test_');
    final databasePath = path.join(directory.path, 'books.db');
    var storage = BookDatabase(
      factory: databaseFactoryFfi,
      databasePath: databasePath,
    );

    try {
      var repository = BookRepository(storage);
      expect(await repository.getAll(), isEmpty);
      expect(await repository.getById(99), isNull);

      final createdAt = DateTime.utc(2026, 11, 13);
      final id = await repository.insert(
        Book(
          title: 'Nhà Giả Kim',
          author: 'Paulo Coelho',
          genre: 'Văn học',
          description: 'Hành trình của Santiago',
          notes: 'Đọc chậm hơn',
          coverPath: '/covers/book.png',
          status: BookStatus.reading,
          totalPages: 200,
          currentPage: 120,
          isFavorite: true,
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
      );
      expect(id, greaterThan(0));

      await storage.close();
      storage = BookDatabase(
        factory: databaseFactoryFfi,
        databasePath: databasePath,
      );
      repository = BookRepository(storage);

      final saved = await repository.getById(id);
      expect(saved, isNotNull);
      expect(saved!.title, 'Nhà Giả Kim');
      expect(saved.status, BookStatus.reading);
      expect(saved.currentPage, 120);
      expect(saved.progress, 0.6);
      expect(saved.genre, 'Văn học');
      expect(saved.description, 'Hành trình của Santiago');
      expect(saved.notes, 'Đọc chậm hơn');
      expect(saved.coverPath, '/covers/book.png');
      expect(saved.isFavorite, isTrue);
      expect(saved.createdAt, createdAt);
      expect((await repository.getAll()).map((book) => book.id), [id]);

      expect(
        await repository.update(
          saved.copyWith(status: BookStatus.completed, currentPage: 200),
        ),
        isTrue,
      );
      final completed = await repository.getById(id);
      expect(completed!.status, BookStatus.completed);
      expect(completed.progress, 1);
      expect(completed.createdAt, createdAt);
      expect(completed.notes, 'Đọc chậm hơn');
      expect(completed.isFavorite, isTrue);

      expect(await repository.delete(id), isTrue);
      expect(await repository.delete(id), isFalse);
      expect(await repository.getAll(), isEmpty);
    } finally {
      await storage.close();
      await directory.delete(recursive: true);
    }
  });
}
