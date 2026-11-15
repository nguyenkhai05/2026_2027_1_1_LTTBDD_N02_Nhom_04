import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/data/book_repository.dart';
import 'package:lt_tbdd/models/book.dart';
import 'package:lt_tbdd/screens/book_detail_screen.dart';
import 'package:lt_tbdd/screens/edit_book_screen.dart';

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

  testWidgets('favorite and progress changes are saved and shown', (tester) async {
    final store = _MemoryBooks(Book(
      id: 1, title: 'Nhà Giả Kim', author: 'Paulo Coelho',
      status: BookStatus.reading, totalPages: 200, currentPage: 120,
    ));
    await tester.pumpWidget(MaterialApp(home: BookDetailScreen(bookId: 1, repository: store)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Thêm vào yêu thích'));
    await tester.pumpAndSettle();
    expect(store.book!.isFavorite, isTrue);
    expect(find.byTooltip('Bỏ khỏi yêu thích'), findsOneWidget);
    expect(find.text('Không thể cập nhật yêu thích. Thử lại nhé.'), findsNothing);

    await tester.tap(find.text('Cập nhật tiến độ'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '160');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu tiến độ'));
    await tester.pumpAndSettle();
    expect(store.book!.currentPage, 160);
    expect(find.text('160 / 200 trang'), findsOneWidget);
  });

  testWidgets('deletion asks for confirmation then returns to caller', (tester) async {
    final store = _MemoryBooks(Book(id: 1, title: 'Sách cần xóa', author: 'Tác giả'));
    bool? deleted;
    await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) => Scaffold(
      body: TextButton(
        onPressed: () async {
          deleted = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => BookDetailScreen(bookId: 1, repository: store)),
          );
        },
        child: const Text('Mở sách'),
      ),
    ))));
    await tester.tap(find.text('Mở sách'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Xóa sách'));
    await tester.tap(find.text('Xóa sách'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hủy'));
    await tester.pumpAndSettle();
    expect(store.book, isNotNull);

    await tester.tap(find.text('Xóa sách'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xóa'));
    await tester.pumpAndSettle();
    expect(store.book, isNull);
    expect(deleted, isTrue);
    expect(find.text('Mở sách'), findsOneWidget);
  });

  testWidgets('editing from detail reloads saved fields', (tester) async {
    final store = _MemoryBooks(Book(
      id: 1, title: 'Sách cũ', author: 'Tác giả',
      totalPages: 200, currentPage: 120,
    ));
    await tester.pumpWidget(MaterialApp(home: BookDetailScreen(bookId: 1, repository: store)));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Chỉnh sửa'));
    await tester.tap(find.text('Chỉnh sửa'));
    await tester.pumpAndSettle();
    expect(find.byType(EditBookScreen), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Sách mới');
    await tester.ensureVisible(find.byType(TextFormField).at(3));
    await tester.enterText(find.byType(TextFormField).at(3), '150');
    await tester.tap(find.text('Lưu thay đổi'));
    await tester.pumpAndSettle();

    expect(store.book!.title, 'Sách mới');
    expect(store.book!.currentPage, 150);
    expect(find.byType(BookDetailScreen), findsOneWidget);
    expect(find.text('Sách mới'), findsOneWidget);
    expect(find.text('150 / 200 trang'), findsOneWidget);
  });

  testWidgets('missing page count opens edit from progress sheet', (tester) async {
    final store = _MemoryBooks(Book(id: 1, title: 'Atomic Habits', author: 'James Clear'));
    await tester.pumpWidget(MaterialApp(home: BookDetailScreen(bookId: 1, repository: store)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cập nhật tiến độ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chỉnh sửa sách'));
    await tester.pumpAndSettle();
    expect(find.byType(EditBookScreen), findsOneWidget);

    await tester.ensureVisible(find.byType(TextFormField).at(2));
    await tester.enterText(find.byType(TextFormField).at(2), '100');
    await tester.tap(find.text('Lưu thay đổi'));
    await tester.pumpAndSettle();

    expect(store.book!.totalPages, 100);
    expect(find.text('0 / 100 trang'), findsOneWidget);
  });
}
