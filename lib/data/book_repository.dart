import '../models/book.dart';
import 'book_database.dart';

/// Local CRUD operations shared by the library, home and statistics screens.
class BookRepository {
  BookRepository(this._storage);

  final BookDatabase _storage;

  Future<List<Book>> getAll() async {
    final db = await _storage.connection;
    final rows = await db.query(
      'books',
      orderBy: 'created_at DESC, id DESC',
    );
    return rows.map(Book.fromDatabaseMap).toList();
  }

  Future<Book?> getById(int id) async {
    final db = await _storage.connection;
    final rows = await db.query('books', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : Book.fromDatabaseMap(rows.single);
  }

  Future<int> insert(Book book) async {
    if (book.id != null) {
      throw ArgumentError.value(book.id, 'book.id', 'Must be null for insert');
    }
    final db = await _storage.connection;
    return db.insert('books', book.toDatabaseMap());
  }

  Future<bool> update(Book book) async {
    final id = book.id;
    if (id == null) {
      throw ArgumentError.value(id, 'book.id', 'Required for update');
    }
    final db = await _storage.connection;
    final values = book.toDatabaseMap()
      ..remove('id')
      ..remove('created_at')
      ..['updated_at'] = DateTime.now().toUtc().millisecondsSinceEpoch;
    final changed = await db.update('books', values, where: 'id = ?', whereArgs: [id]);
    return changed == 1;
  }

  Future<bool> delete(int id) async {
    final db = await _storage.connection;
    final changed = await db.delete('books', where: 'id = ?', whereArgs: [id]);
    return changed == 1;
  }
}
