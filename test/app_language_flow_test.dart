import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/app.dart';
import 'package:lt_tbdd/data/app_language_store.dart';
import 'package:lt_tbdd/data/book_repository.dart';
import 'package:lt_tbdd/models/app_language.dart';
import 'package:lt_tbdd/models/book.dart';

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
  @override
  Future<List<Book>> getAll() async => [];
  @override
  Future<Book?> getById(int id) async => null;
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
}
