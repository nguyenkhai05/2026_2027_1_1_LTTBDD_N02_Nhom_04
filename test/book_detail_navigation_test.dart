import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/components/home_book_card.dart';
import 'package:lt_tbdd/components/library_book_card.dart';
import 'package:lt_tbdd/data/book_repository.dart';
import 'package:lt_tbdd/models/book.dart';
import 'package:lt_tbdd/screens/app_shell.dart';
import 'package:lt_tbdd/screens/book_detail_screen.dart';

class _MemoryStore implements BookStore {
  _MemoryStore(this.books);
  final List<Book> books;

  @override
  Future<List<Book>> getAll() async => List.of(books);

  @override
  Future<Book?> getById(int id) async {
    for (final book in books) {
      if (book.id == id) return book;
    }
    return null;
  }

  @override
  Future<int> insert(Book book) async => throw UnimplementedError();

  @override
  Future<bool> update(Book book) async {
    final index = books.indexWhere((item) => item.id == book.id);
    if (index < 0) return false;
    books[index] = book;
    return true;
  }

  @override
  Future<bool> delete(int id) async {
    final index = books.indexWhere((book) => book.id == id);
    if (index < 0) return false;
    books.removeAt(index);
    return true;
  }
}

void main() {
  testWidgets('Home book card opens detail and refreshes after returning', (tester) async {
    final store = _MemoryStore([Book(
      id: 1, title: 'Nhà Giả Kim', author: 'Paulo Coelho',
      status: BookStatus.reading, totalPages: 200, currentPage: 120,
    )]);
    await tester.pumpWidget(MaterialApp(home: AppShell(repository: store)));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(HomeBookCard).first);
    await tester.pumpAndSettle();
    expect(find.byType(BookDetailScreen), findsOneWidget);
    await tester.tap(find.byTooltip('Thêm vào yêu thích'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Quay lại'));
    await tester.pumpAndSettle();

    expect(store.books.single.isFavorite, isTrue);
    expect(find.byType(HomeBookCard), findsWidgets);
    expect(find.byIcon(Icons.favorite), findsWidgets);
  });

  testWidgets('Library book card opens detail and refreshes its progress', (tester) async {
    final store = _MemoryStore([Book(
      id: 1, title: 'Nhà Giả Kim', author: 'Paulo Coelho',
      status: BookStatus.reading, totalPages: 200, currentPage: 120,
    )]);
    await tester.pumpWidget(MaterialApp(home: AppShell(repository: store)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Thư viện').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(LibraryBookCard).first);
    await tester.pumpAndSettle();
    expect(find.byType(BookDetailScreen), findsOneWidget);
    await tester.tap(find.text('Cập nhật tiến độ'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '160');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu tiến độ'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Quay lại'));
    await tester.pumpAndSettle();

    expect(find.text('160 / 200 · 80%'), findsOneWidget);
  });
}
