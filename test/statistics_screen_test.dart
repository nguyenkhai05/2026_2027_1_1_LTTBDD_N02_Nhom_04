import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/components/statistics_components.dart';
import 'package:lt_tbdd/data/book_repository.dart';
import 'package:lt_tbdd/models/book.dart';
import 'package:lt_tbdd/screens/statistics_screen.dart';

class _MemoryBooks implements BookCatalog {
  _MemoryBooks(this.books);
  final List<Book> books;

  @override
  Future<List<Book>> getAll() async => List.of(books);

  @override
  Future<bool> update(Book book) async {
    final index = books.indexWhere((item) => item.id == book.id);
    if (index < 0) return false;
    books[index] = book;
    return true;
  }

  @override
  Future<bool> delete(int id) async {
    final index = books.indexWhere((item) => item.id == id);
    if (index < 0) return false;
    books.removeAt(index);
    return true;
  }
}

void main() {
  testWidgets('shows empty state when there are no books', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StatisticsScreen(
          repository: _MemoryBooks([]),
          onTabSelected: (_) {},
          onAddBook: () async => false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chưa có dữ liệu thống kê'), findsOneWidget);
    expect(find.text('Thêm sách'), findsOneWidget);
  });

  testWidgets('calculates total and status counts from stored books', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StatisticsScreen(
          repository: _MemoryBooks([
            Book(
              id: 1,
              title: 'Book 1',
              author: 'Author',
              status: BookStatus.reading,
            ),
            Book(
              id: 2,
              title: 'Book 2',
              author: 'Author',
              status: BookStatus.completed,
            ),
            Book(
              id: 3,
              title: 'Book 3',
              author: 'Author',
              status: BookStatus.wantToRead,
            ),
            Book(
              id: 4,
              title: 'Book 4',
              author: 'Author',
              status: BookStatus.paused,
            ),
            Book(
              id: 5,
              title: 'Book 5',
              author: 'Author',
              status: BookStatus.reading,
            ),
          ]),
          onTabSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Thống kê đọc sách'), findsOneWidget);
    expect(find.text('Tổng số sách'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('Đang đọc'), findsOneWidget);
    expect(find.text('Đã đọc'), findsOneWidget);
    expect(find.text('Muốn đọc'), findsOneWidget);
    expect(find.text('Tạm dừng'), findsOneWidget);
    final cards = tester.widgetList<StatisticsSummaryCard>(
      find.byType(StatisticsSummaryCard),
    );
    expect(
      {for (final card in cards) card.label: card.value},
      {
        'Tổng số sách': 5,
        'Đang đọc': 2,
        'Đã đọc': 1,
        'Muốn đọc': 1,
        'Tạm dừng': 1,
      },
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('adding a book from the empty state reloads the counts', (tester) async {
    final repository = _MemoryBooks([]);
    await tester.pumpWidget(MaterialApp(
      home: StatisticsScreen(
        repository: repository,
        onTabSelected: (_) {},
        onAddBook: () async {
          repository.books.add(Book(id: 1, title: 'Sách mới', author: 'Tác giả'));
          return true;
        },
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Thêm sách'));
    await tester.pumpAndSettle();
    expect(find.byType(StatisticsSummaryCard), findsNWidgets(5));
    expect(
      tester.widgetList<StatisticsSummaryCard>(find.byType(StatisticsSummaryCard))
          .first.value,
      1,
    );
  });
}
