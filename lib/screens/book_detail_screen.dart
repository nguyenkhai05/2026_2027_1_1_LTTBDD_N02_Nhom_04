import 'package:flutter/material.dart';

import '../components/book_detail_sections.dart';
import '../components/library_delete_dialog.dart';
import '../components/update_progress_sheet.dart';
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
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _bookFuture = widget.repository.getById(widget.bookId);
  }

  @override
  void didUpdateWidget(covariant BookDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bookId != widget.bookId || oldWidget.repository != widget.repository) {
      _bookFuture = widget.repository.getById(widget.bookId);
    }
  }

  void _reload() => setState(() => _bookFuture = widget.repository.getById(widget.bookId));

  void _notify(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _toggleFavorite(Book book) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      if (!await widget.repository.update(book.copyWith(isFavorite: !book.isFavorite))) {
        throw StateError('The book no longer exists');
      }
      if (mounted) _reload();
    } catch (_) {
      if (mounted) _notify('Không thể cập nhật yêu thích. Thử lại nhé.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _updateProgress(Book book) async {
    if (_saving) return;
    final page = await showUpdateProgressSheet(context, book: book);
    if (!mounted || page == null || page == book.currentPage) return;
    setState(() => _saving = true);
    try {
      if (!await widget.repository.update(book.copyWith(currentPage: page))) {
        throw StateError('The book no longer exists');
      }
      if (!mounted) return;
      _reload();
      _notify(page == book.totalPages
          ? 'Bạn đã đọc hết sách. Có thể chuyển trạng thái sang Đã đọc.'
          : 'Đã cập nhật tiến độ đọc.');
    } catch (_) {
      if (mounted) _notify('Không thể cập nhật tiến độ. Thử lại nhé.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _deleteBook(Book book) async {
    if (_saving) return;
    final confirmed = await showLibraryDeleteDialog(context, bookTitle: book.title);
    if (!mounted || !confirmed) return;
    setState(() => _saving = true);
    try {
      if (!await widget.repository.delete(book.id!)) {
        throw StateError('The book no longer exists');
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) _notify('Không thể xóa sách. Hãy thử lại.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F6F0),
    body: SafeArea(
      child: FutureBuilder<Book?>(
        future: _bookFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Column(children: [
              _header(null),
              Expanded(child: _message('Không thể tải chi tiết sách', retry: _reload)),
            ]);
          }
          if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final book = snapshot.data;
          return Column(
            children: [
              _header(book),
              if (book == null)
                Expanded(child: _message('Không tìm thấy sách'))
              else ...[
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                    children: [
                      BookDetailIdentity(book: book),
                      const SizedBox(height: 28),
                      BookDetailReading(book: book),
                      const SizedBox(height: 30),
                      OutlinedButton.icon(
                        onPressed: _saving ? null : () => _deleteBook(book),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Xóa sách'),
                        style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFB74742)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _saving ? null : () => _updateProgress(book),
                      style: FilledButton.styleFrom(backgroundColor: libraryGreen),
                      child: const Text('Cập nhật tiến độ'),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    ),
  );

  Widget _header(Book? book) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 16, 6),
    child: Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Quay lại',
          icon: const Icon(Icons.arrow_back, color: libraryGreen),
        ),
        const Expanded(
          child: Text('Chi tiết sách', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: libraryInk)),
        ),
        if (book != null)
          IconButton(
            onPressed: _saving ? null : () => _toggleFavorite(book),
            tooltip: book.isFavorite ? 'Bỏ khỏi yêu thích' : 'Thêm vào yêu thích',
            icon: Icon(book.isFavorite ? Icons.favorite : Icons.favorite_border, color: libraryGreen),
          ),
      ],
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
