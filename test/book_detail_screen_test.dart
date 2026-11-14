import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/data/book_repository.dart';
import 'package:lt_tbdd/models/book.dart';
import 'package:lt_tbdd/screens/book_detail_screen.dart';

class _MemoryBooks implements BookCatalog {
  _MemoryBooks(this.book);
  Book? book;

  @override
  Future<Book?> getById(int id) async => book?.id == id ? book : null;

  @override
  Future<List<Book>> getAll() async => [if (book != null) book!];

  @override
  Future<bool> update(Book value) async {
    if (book?.id != value.id) return false;
    book = value;
    return true;
  }

  @override
  Future<bool> delete(int id) async {
    if (book?.id != id) return false;
    book = null;
    return true;
  }
}

void main() {
  testWidgets('shows stored details and progress', (tester) async {
    final store = _MemoryBooks(Book(
      id: 1,
      title: 'Nhà Giả Kim',
      author: 'Paulo Coelho',
      genre: 'Văn học',
      description: 'Hành trình của Santiago',
      notes: 'Đọc chậm hơn',
      status: BookStatus.reading,
      totalPages: 200,
      currentPage: 120,
    ));
    await tester.pumpWidget(MaterialApp(home: BookDetailScreen(bookId: 1, repository: store)));
    await tester.pumpAndSettle();

    expect(find.text('Nhà Giả Kim'), findsOneWidget);
    expect(find.text('Paulo Coelho'), findsOneWidget);
    expect(find.text('120 / 200 trang'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('Hành trình của Santiago'), findsOneWidget);
    expect(find.text('Đọc chậm hơn'), findsOneWidget);
  });

  testWidgets('handles unknown pages and missing book', (tester) async {
    final store = _MemoryBooks(Book(id: 1, title: 'Atomic Habits', author: 'James Clear'));
    await tester.pumpWidget(MaterialApp(home: BookDetailScreen(bookId: 1, repository: store)));
    await tester.pumpAndSettle();
    expect(find.text('Chưa có thông tin tổng số trang'), findsOneWidget);

    await tester.pumpWidget(MaterialApp(home: BookDetailScreen(
      key: const ValueKey('missing-book'), bookId: 2, repository: store,
    )));
    await tester.pumpAndSettle();
    expect(find.text('Không tìm thấy sách'), findsOneWidget);
  });
}
