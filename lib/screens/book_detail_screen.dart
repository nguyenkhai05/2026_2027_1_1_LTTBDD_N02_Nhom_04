import 'package:flutter/material.dart';

import '../components/book_detail_sections.dart';
import '../data/book_repository.dart';
import '../models/book.dart';
import '../theme/library_colors.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({super.key, required this.bookId, required this.repository});

  final int bookId;
  final BookCatalog repository;

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late Future<Book?> _bookFuture;

  @override
  void initState() {
    super.initState();
    _bookFuture = widget.repository.getById(widget.bookId);
  }

  void _reload() => setState(() => _bookFuture = widget.repository.getById(widget.bookId));

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F6F0),
    appBar: AppBar(
      title: const Text('Chi tiết sách'),
      backgroundColor: const Color(0xFFF7F6F0),
      foregroundColor: libraryInk,
    ),
    body: SafeArea(
      child: FutureBuilder<Book?>(
        future: _bookFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _message('Không thể tải chi tiết sách', retry: _reload);
          }
          if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final book = snapshot.data;
          if (book == null) return _message('Không tìm thấy sách');
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              BookDetailIdentity(book: book),
              const SizedBox(height: 28),
              BookDetailReading(book: book),
            ],
          );
        },
      ),
    ),
  );

  Widget _message(String text, {VoidCallback? retry}) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text),
        if (retry != null) TextButton(onPressed: retry, child: const Text('Thử lại')),
      ],
    ),
  );
}
