import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/data/book_repository.dart';
import 'package:lt_tbdd/models/book.dart';
import 'package:lt_tbdd/screens/app_shell.dart';

class _MemoryStore implements BookStore {
  final List<Book> books = [];
  int _nextId = 0;

  @override
  Future<List<Book>> getAll() async => List.of(books);

  @override
  Future<int> insert(Book book) async {
    final id = ++_nextId;
    books.add(Book.fromDatabaseMap({...book.toDatabaseMap(), 'id': id}));
    return id;
  }

  @override
  Future<bool> update(Book book) async {
    final index = books.indexWhere((saved) => saved.id == book.id);
    if (index < 0) return false;
    books[index] = book;
    return true;
  }
}

void main() {
  testWidgets('Library opens Add Book, saves and reloads its list', (tester) async {
    final store = _MemoryStore();
    await tester.pumpWidget(MaterialApp(home: AppShell(repository: store)));

    await tester.tap(find.text('Thư viện'));
    await tester.pumpAndSettle();
    expect(find.text('Thư viện của bạn đang trống'), findsOneWidget);
    await tester.tap(find.text('Thêm sách đầu tiên'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Hoàng Tử Bé');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Antoine de Saint-Exupéry',
    );
    await tester.tap(find.text('Lưu sách'));
    await tester.pumpAndSettle();

    expect(store.books, hasLength(1));
    expect(find.text('Hoàng Tử Bé'), findsOneWidget);
    expect(find.text('Đã thêm sách thành công.'), findsOneWidget);
  });
}
