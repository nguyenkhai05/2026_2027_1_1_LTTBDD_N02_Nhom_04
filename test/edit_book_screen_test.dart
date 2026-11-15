import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/models/book.dart';
import 'package:lt_tbdd/screens/edit_book_screen.dart';

void main() {
  testWidgets('prefills fields, validates pages and preserves stored data', (tester) async {
    final original = Book(
      id: 7, title: 'Sách cũ', author: 'Tác giả cũ', genre: 'Thể loại riêng',
      totalPages: 200, currentPage: 120, status: BookStatus.reading,
      coverPath: '/missing/cover.png', isFavorite: true,
      description: 'Mô tả cũ', notes: 'Ghi chú cũ',
    );
    Book? saved;
    await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) => Scaffold(
      body: TextButton(
        onPressed: () => Navigator.of(context).push<bool>(MaterialPageRoute(
          builder: (_) => EditBookScreen(
            book: original,
            onSave: (book) async { saved = book; return true; },
          ),
        )),
        child: const Text('Mở form'),
      ),
    ))));
    await tester.tap(find.text('Mở form'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    expect(tester.widget<TextFormField>(fields.at(0)).controller!.text, 'Sách cũ');
    expect(tester.widget<TextFormField>(fields.at(1)).controller!.text, 'Tác giả cũ');
    expect(tester.widget<TextFormField>(fields.at(2)).controller!.text, '200');
    expect(tester.widget<TextFormField>(fields.at(3)).controller!.text, '120');

    await tester.enterText(fields.at(0), '  Sách mới  ');
    await tester.ensureVisible(fields.at(2));
    await tester.enterText(fields.at(2), '100');
    await tester.tap(find.text('Lưu thay đổi'));
    await tester.pumpAndSettle();
    expect(find.text('Số trang đã đọc không thể lớn hơn tổng số trang'), findsOneWidget);
    expect(saved, isNull);

    await tester.ensureVisible(fields.at(3));
    await tester.enterText(fields.at(3), '80');
    await tester.tap(find.text('Lưu thay đổi'));
    await tester.pumpAndSettle();

    expect(saved, isNotNull);
    expect(saved!.id, 7);
    expect(saved!.title, 'Sách mới');
    expect(saved!.totalPages, 100);
    expect(saved!.currentPage, 80);
    expect(saved!.genre, 'Thể loại riêng');
    expect(saved!.coverPath, '/missing/cover.png');
    expect(saved!.isFavorite, isTrue);
    expect(saved!.description, 'Mô tả cũ');
    expect(saved!.notes, 'Ghi chú cũ');
    expect(find.text('Mở form'), findsOneWidget);
  });

  testWidgets('failed update keeps edit form and entered values', (tester) async {
    final original = Book(id: 1, title: 'Sách cũ', author: 'Tác giả');
    await tester.pumpWidget(MaterialApp(home: EditBookScreen(
      book: original, onSave: (_) async => false,
    )));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Sách mới');
    await tester.tap(find.text('Lưu thay đổi'));
    await tester.pumpAndSettle();

    expect(find.byType(EditBookScreen), findsOneWidget);
    expect(find.text('Không thể lưu thay đổi. Hãy thử lại.'), findsOneWidget);
    expect(tester.widget<TextFormField>(find.byType(TextFormField).first).controller!.text, 'Sách mới');
  });
}
