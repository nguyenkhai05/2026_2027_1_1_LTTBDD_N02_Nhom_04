import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/app.dart';
import 'package:lt_tbdd/data/app_language_store.dart';
import 'package:lt_tbdd/data/book_repository.dart';
import 'package:lt_tbdd/models/app_language.dart';
import 'package:lt_tbdd/models/book.dart';
import 'package:lt_tbdd/components/library_book_card.dart';
import 'package:lt_tbdd/screens/edit_book_screen.dart';

class _MemoryLanguage implements AppLanguageStore {
  AppLanguage value = AppLanguage.vietnamese;
  bool failSave = false;

  @override
  Future<AppLanguage> load() async => value;

  @override
  Future<void> save(AppLanguage language) async {
    if (failSave) throw StateError('disk full');
    value = language;
  }
}

class _EmptyBooks implements BookStore {
  _EmptyBooks([this.books = const []]);
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
  Future<int> insert(Book book) async => 1;
  @override
  Future<bool> update(Book book) async => false;
  @override
  Future<bool> delete(int id) async => false;
}

void main() {
  testWidgets('language selection changes UI and is restored on restart', (tester) async {
    final settings = _MemoryLanguage();
    final books = _EmptyBooks();
    await tester.pumpWidget(MyApp(repository: books, languageStore: settings));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ngôn ngữ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(settings.value, AppLanguage.english);
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('English'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(MyApp(repository: books, languageStore: settings));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('English'), findsOneWidget);
  });

  testWidgets('storage failure leaves language selection open', (tester) async {
    final settings = _MemoryLanguage()..failSave = true;
    await tester.pumpWidget(MyApp(repository: _EmptyBooks(), languageStore: settings));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ngôn ngữ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(settings.value, AppLanguage.vietnamese);
    expect(find.text('Ngôn ngữ của bạn'), findsOneWidget);
    expect(find.text('Không thể lưu ngôn ngữ. Hãy thử lại.'), findsOneWidget);
  });

  testWidgets('English translates screens but leaves book titles unchanged', (tester) async {
    final settings = _MemoryLanguage()..value = AppLanguage.english;
    final books = _EmptyBooks([
      Book(id: 1, title: 'Đang đọc', author: 'Tác giả',
          genre: 'Văn học', status: BookStatus.reading,
          totalPages: 200, currentPage: 50),
    ]);
    await tester.pumpWidget(MyApp(repository: books, languageStore: settings));
    await tester.pumpAndSettle();

    expect(find.text('Hello!'), findsOneWidget);
    expect(find.text('Đang đọc'), findsWidgets);
    expect(find.text('Reading'), findsWidgets);
    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();
    expect(find.text('My library'), findsOneWidget);
    expect(find.text('Đang đọc'), findsOneWidget);

    await tester.tap(find.byType(LibraryBookCard));
    await tester.pumpAndSettle();
    expect(find.text('Book details'), findsOneWidget);
    expect(find.text('Đang đọc'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Edit'), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.byType(EditBookScreen), findsOneWidget);
    expect(find.text('Book title *'), findsOneWidget);
    expect(tester.widget<TextFormField>(find.byType(TextFormField).first)
        .controller!.text, 'Đang đọc');
  });
}
