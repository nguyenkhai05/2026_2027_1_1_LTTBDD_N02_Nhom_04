import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/components/library_book_card.dart';
import 'package:lt_tbdd/components/library_filter_sheet.dart';
import 'package:lt_tbdd/data/book_repository.dart';
import 'package:lt_tbdd/models/book.dart';
import 'package:lt_tbdd/screens/library_screen.dart';

class _MemoryBooks implements BookCatalog {
  _MemoryBooks(this.books);

  List<Book> books;

  @override
  Future<List<Book>> getAll() async => List.of(books);

  @override
  Future<bool> update(Book book) async {
    final index = books.indexWhere((item) => item.id == book.id);
    if (index < 0) return false;
    books[index] = book;
    return true;
  }
}

void main() {
  testWidgets('shows the empty library with no stored books', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LibraryScreen(
          repository: _MemoryBooks([]),
          onTabSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Thư viện của bạn đang trống'), findsOneWidget);
  });

  testWidgets('search, status and favorite act on stored books', (
    tester,
  ) async {
    final repository = _MemoryBooks([
      Book(
        id: 1,
        title: 'Nhà Giả Kim',
        author: 'Paulo Coelho',
        status: BookStatus.reading,
      ),
      Book(
        id: 2,
        title: 'Clean Code',
        author: 'Robert Martin',
        status: BookStatus.completed,
      ),
    ]);
    await tester.pumpWidget(
      MaterialApp(
        home: LibraryScreen(repository: repository, onTabSelected: (_) {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LibraryBookCard), findsNWidgets(2));
    await tester.enterText(find.byType(TextField), 'COELHO');
    await tester.pumpAndSettle();
    expect(find.byType(LibraryBookCard), findsOneWidget);
    expect(find.text('Nhà Giả Kim'), findsOneWidget);

    await tester.tap(find.byTooltip('Thêm vào yêu thích'));
    await tester.pumpAndSettle();
    expect(repository.books.first.isFavorite, isTrue);

    await tester.tap(find.byTooltip('Xóa từ khóa'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Đã đọc').first);
    await tester.pumpAndSettle();
    expect(find.byType(LibraryBookCard), findsOneWidget);
    expect(find.text('Clean Code'), findsOneWidget);
  });

  testWidgets('filter sheet applies favorite selection', (tester) async {
    final repository = _MemoryBooks([
      Book(
        id: 1,
        title: 'Nhà Giả Kim',
        author: 'Paulo Coelho',
        isFavorite: true,
      ),
      Book(id: 2, title: 'Clean Code', author: 'Robert Martin'),
    ]);
    await tester.pumpWidget(
      MaterialApp(
        home: LibraryScreen(repository: repository, onTabSelected: (_) {}),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Lọc sách'));
    await tester.pumpAndSettle();
    expect(find.byType(LibraryFilterSheet), findsOneWidget);
    await tester.tap(find.text('Chỉ yêu thích'));
    await tester.ensureVisible(find.text('Áp dụng'));
    await tester.tap(find.text('Áp dụng'));
    await tester.pumpAndSettle();

    expect(find.byType(LibraryBookCard), findsOneWidget);
    expect(find.text('Nhà Giả Kim'), findsOneWidget);
  });
}
