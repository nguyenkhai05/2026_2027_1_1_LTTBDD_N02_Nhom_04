import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/components/home_book_card.dart';
import 'package:lt_tbdd/components/overview_card.dart';
import 'package:lt_tbdd/data/book_repository.dart';
import 'package:lt_tbdd/models/book.dart';
import 'package:lt_tbdd/screens/home_screen.dart';

class _MemoryBooks implements BookCatalog {
  _MemoryBooks(this.books);

  List<Book> books;

  @override
  Future<List<Book>> getAll() async => List.of(books);

  @override
  Future<bool> update(Book book) async => true;

  @override
  Future<bool> delete(int id) async => true;
}

void main() {
  testWidgets('empty Home has zero counts and no sample book', (tester) async {
    final repository = _MemoryBooks([]);
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(
        repository: repository,
        onTabSelected: (_) {},
        onAddBook: () async {
          repository.books = [Book(id: 1, title: 'Sách mới', author: 'Tác giả')];
          return true;
        },
      ),
    ));
    await tester.pumpAndSettle();

    final summary = tester.widget<OverviewCard>(find.byType(OverviewCard));
    expect((summary.total, summary.reading, summary.completed), (0, 0, 0));
    expect(find.text('Thư viện của bạn đang trống'), findsOneWidget);
    expect(find.text('Nhà Giả Kim'), findsNothing);

    await tester.ensureVisible(find.text('Thêm sách đầu tiên'));
    await tester.tap(find.text('Thêm sách đầu tiên'));
    await tester.pumpAndSettle();
    expect(tester.widget<OverviewCard>(find.byType(OverviewCard)).total, 1);
    expect(find.text('Sách mới'), findsOneWidget);
  });

  testWidgets('Home counts stored statuses and opens Library', (tester) async {
    var selectedTab = -1;
    final books = [
      Book(id: 1, title: 'Nhà Giả Kim', author: 'Paulo Coelho', status: BookStatus.reading),
      Book(id: 2, title: 'Clean Code', author: 'Robert Martin', status: BookStatus.completed),
      Book(id: 3, title: 'Hoàng Tử Bé', author: 'Saint-Exupéry'),
    ];
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(
        repository: _MemoryBooks(books),
        onTabSelected: (index) => selectedTab = index,
      ),
    ));
    await tester.pumpAndSettle();

    final summary = tester.widget<OverviewCard>(find.byType(OverviewCard));
    expect((summary.total, summary.reading, summary.completed), (3, 1, 1));
    expect(find.byType(HomeBookCard), findsNWidgets(4));
    await tester.tap(find.text('Xem tất cả').first);
    expect(selectedTab, 1);
  });
}
