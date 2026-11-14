import 'package:flutter/material.dart';

import '../components/home_book_section.dart';
import '../components/home_bottom_navigation.dart';
import '../components/home_header.dart';
import '../components/overview_card.dart';
import '../data/book_repository.dart';
import '../models/book.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.repository,
    required this.onTabSelected,
    this.onAddBook,
    this.onOpenBook,
  });

  final BookCatalog repository;
  final ValueChanged<int> onTabSelected;
  final Future<bool> Function()? onAddBook;
  final Future<void> Function(Book)? onOpenBook;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = widget.repository.getAll();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repository != widget.repository) {
      _booksFuture = widget.repository.getAll();
    }
  }

  Future<void> _refresh() async {
    final future = widget.repository.getAll();
    setState(() {
      _booksFuture = future;
    });
    try {
      await future;
    } catch (_) {
      // The FutureBuilder below shows the retry state.
    }
  }

  Future<void> _addBook() async {
    final openForm = widget.onAddBook;
    if (openForm == null) return;
    final added = await openForm();
    if (mounted && added) await _refresh();
  }

  Future<void> _openBook(Book book) async {
    final open = widget.onOpenBook;
    if (open == null) return;
    await open(book);
    if (mounted) await _refresh();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Không thể tải trang chủ.'),
                  TextButton(onPressed: _refresh, child: const Text('Thử lại')),
                ],
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final books = snapshot.data!;
          final recent = [...books]
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          final reading = books.where((book) => book.status == BookStatus.reading).length;
          final completed = books.where((book) => book.status == BookStatus.completed).length;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeHeader(),
                  const SizedBox(height: 20),
                  OverviewCard(
                    total: books.length,
                    reading: reading,
                    completed: completed,
                  ),
                  const SizedBox(height: 24),
                  HomeBookSection(
                    title: 'Đọc tiếp',
                    books: recent
                        .where((book) => book.status == BookStatus.reading)
                        .take(2)
                        .toList(),
                    emptyTitle: 'Chưa có sách đang đọc',
                    emptyDescription:
                        'Hãy chọn một cuốn sách và bắt đầu hành trình đọc nhé!',
                    onViewAll: () => widget.onTabSelected(1),
                    onBookTap: widget.onOpenBook == null ? null : _openBook,
                  ),
                  const SizedBox(height: 24),
                  HomeBookSection(
                    title: 'Mới thêm gần đây',
                    books: recent.take(3).toList(),
                    emptyTitle: 'Thư viện của bạn đang trống',
                    emptyDescription:
                        'Thêm sách đầu tiên để bắt đầu quản lý thư viện nhé!',
                    onViewAll: () => widget.onTabSelected(1),
                    onBookTap: widget.onOpenBook == null ? null : _openBook,
                    onAddBook: widget.onAddBook == null ? null : _addBook,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
    bottomNavigationBar: HomeBottomNavigation(
      currentIndex: 0,
      onTap: widget.onTabSelected,
    ),
  );
}
