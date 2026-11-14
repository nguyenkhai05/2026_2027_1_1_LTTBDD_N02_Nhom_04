import 'package:flutter/material.dart';

import '../data/book_database.dart';
import '../data/book_repository.dart';
import 'add_book_screen.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'settings_screen.dart';

/// Shares one local repository between the available tabs.
class AppShell extends StatefulWidget {
  const AppShell({super.key, this.repository});

  /// Optional store for tests; the app owns its default SQLite database.
  final BookStore? repository;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final BookDatabase? _database = widget.repository == null
      ? BookDatabase()
      : null;
  late final BookStore _books = widget.repository ?? BookRepository(_database!);
  int _tab = 0;
  String _language = 'Tiếng Việt';

  void _selectTab(int index) {
    // Statistics is not implemented yet; keep its tab inactive for now.
    if ((index != 0 && index != 1 && index != 3) || index == _tab) return;
    setState(() => _tab = index);
  }

  Future<bool> _openAddBook() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddBookScreen(
          onSave: (book) async {
            await _books.insert(book);
          },
        ),
      ),
    );
    return added ?? false;
  }

  @override
  void dispose() {
    _database?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tab == 1) {
      return LibraryScreen(
        repository: _books,
        onTabSelected: _selectTab,
        onAddBook: _openAddBook,
      );
    }

    if (_tab == 3) {
      return SettingsScreen(
        onTabSelected: _selectTab,
        language: _language,
        onLanguageChanged: (language) {
          setState(() => _language = language);
        },
      );
    }

    return HomeScreen(onTabSelected: _selectTab);
  }
}
