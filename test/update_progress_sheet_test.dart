import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/components/update_progress_sheet.dart';
import 'package:lt_tbdd/models/book.dart';

void main() {
  testWidgets('rejects pages beyond the total and returns a valid page', (tester) async {
    int? savedPage;
    final book = Book(
      id: 1,
      title: 'Nhà Giả Kim',
      author: 'Paulo Coelho',
      totalPages: 200,
      currentPage: 120,
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              savedPage = await showUpdateProgressSheet(context, book: book);
            },
            child: const Text('Mở tiến độ'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Mở tiến độ'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '201');
    await tester.pumpAndSettle();
    expect(find.text('Số trang đã đọc không thể lớn hơn số trang'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Lưu tiến độ')).onPressed, isNull);

    await tester.enterText(find.byType(TextField), '160');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu tiến độ'));
    await tester.pumpAndSettle();
    expect(savedPage, 160);
  });

  testWidgets('a book without total pages offers editing instead', (tester) async {
    var editRequested = false;
    final book = Book(id: 1, title: 'Sách', author: 'Tác giả');
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showUpdateProgressSheet(
              context,
              book: book,
              onEditBook: () => editRequested = true,
            ),
            child: const Text('Mở tiến độ'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Mở tiến độ'));
    await tester.pumpAndSettle();
    expect(find.text('Chưa có thông tin tổng số trang'), findsOneWidget);
    await tester.tap(find.text('Chỉnh sửa sách'));
    expect(editRequested, isTrue);
  });
}
