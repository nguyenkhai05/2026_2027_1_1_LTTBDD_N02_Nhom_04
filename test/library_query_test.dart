import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/models/book.dart';
import 'package:lt_tbdd/models/library_query.dart';

void main() {
  final books = [
    Book(
      id: 1,
      title: 'Nhà Giả Kim',
      author: 'Paulo Coelho',
      genre: 'Văn học',
      status: BookStatus.reading,
      isFavorite: true,
      createdAt: DateTime.utc(2026, 11, 1),
    ),
    Book(
      id: 2,
      title: 'Clean Code',
      author: 'Robert Martin',
      genre: 'Công nghệ',
      status: BookStatus.completed,
      createdAt: DateTime.utc(2026, 11, 3),
    ),
  ];

  test('searches title and author without case or surrounding spaces', () {
    expect(filterLibraryBooks(books, query: '  COELHO ').single.id, 1);
    expect(filterLibraryBooks(books, query: 'clean').single.id, 2);
    expect(filterLibraryBooks(books, query: 'unknown'), isEmpty);
  });

  test('combines status, genre and favorites and sorts results', () {
    expect(filterLibraryBooks(books).map((book) => book.id), [2, 1]);
    expect(
      filterLibraryBooks(
        books,
        sort: LibrarySort.oldest,
      ).map((book) => book.id),
      [1, 2],
    );
    expect(
      filterLibraryBooks(
        books,
        sort: LibrarySort.titleAsc,
      ).map((book) => book.id),
      [2, 1],
    );
    expect(
      filterLibraryBooks(
        books,
        status: BookStatus.reading,
        genre: 'Văn học',
        favoritesOnly: true,
      ).single.id,
      1,
    );
    expect(
      filterLibraryBooks(
        books,
        status: BookStatus.completed,
        favoritesOnly: true,
      ),
      isEmpty,
    );
  });
}
