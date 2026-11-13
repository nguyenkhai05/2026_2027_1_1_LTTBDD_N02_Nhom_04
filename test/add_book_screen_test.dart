import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/models/book.dart';
import 'package:lt_tbdd/screens/add_book_screen.dart';

void main() {
  testWidgets('validates inputs and returns after saving one book', (tester) async {
    final saved = <Book>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.push<bool>(
                context,
                MaterialPageRoute<bool>(
                  builder: (_) => AddBookScreen(
                    onSave: (book) async => saved.add(book),
                  ),
                ),
              ),
              child: const Text('Mở form'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Mở form'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lưu sách'));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập tên sách'), findsOneWidget);
    expect(find.text('Vui lòng nhập tác giả'), findsOneWidget);
    expect(saved, isEmpty);

    await tester.enterText(find.byType(TextFormField).at(0), '  Hoàng Tử Bé  ');
    await tester.enterText(find.byType(TextFormField).at(1), 'Antoine de Saint-Exupéry');
    await tester.ensureVisible(find.byType(TextFormField).at(2));
    await tester.enterText(find.byType(TextFormField).at(2), '120');
    await tester.ensureVisible(find.byType(TextFormField).at(3));
    await tester.enterText(find.byType(TextFormField).at(3), '140');
    await tester.tap(find.text('Lưu sách'));
    await tester.pumpAndSettle();
    expect(find.text('Số trang đã đọc không thể lớn hơn tổng số trang'), findsOneWidget);
    expect(saved, isEmpty);

    await tester.enterText(find.byType(TextFormField).at(3), '40');
    await tester.tap(find.text('Lưu sách'));
    await tester.pumpAndSettle();
    expect(saved, hasLength(1));
    expect(saved.single.title, 'Hoàng Tử Bé');
    expect(saved.single.totalPages, 120);
    expect(saved.single.currentPage, 40);
    expect(find.text('Mở form'), findsOneWidget);
  });

  testWidgets('storage errors keep the form open', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AddBookScreen(onSave: (_) async => throw StateError('disk full')),
    ));
    await tester.enterText(find.byType(TextFormField).at(0), 'Sách');
    await tester.enterText(find.byType(TextFormField).at(1), 'Tác giả');
    await tester.tap(find.text('Lưu sách'));
    await tester.pumpAndSettle();

    expect(find.text('Không thể lưu sách. Hãy thử lại.'), findsOneWidget);
    expect(find.byType(AddBookScreen), findsOneWidget);
  });
}
