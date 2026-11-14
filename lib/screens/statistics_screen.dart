import 'package:flutter/material.dart';

import '../components/home_bottom_navigation.dart';
import '../components/statistics_components.dart';
import '../data/book_repository.dart';
import '../models/book.dart';
import '../theme/library_colors.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({
    super.key,
    required this.repository,
    required this.onTabSelected,
    this.onAddBook,
  });

  final BookCatalog repository;
  final ValueChanged<int> onTabSelected;
  final Future<bool> Function()? onAddBook;

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = widget.repository.getAll();
  }

  Future<void> _refresh() async {
    final future = widget.repository.getAll();
    setState(() => _booksFuture = future);
    try {
      await future;
    } catch (_) {
      // FutureBuilder displays the error state.
    }
  }

  Future<void> _addBook() async {
    final addBook = widget.onAddBook;
    if (addBook == null) return;
    final added = await addBook();
    if (!mounted || !added) return;
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F0),
      bottomNavigationBar: HomeBottomNavigation(
        currentIndex: 2,
        onTap: widget.onTabSelected,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Book>>(
          future: _booksFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _MessageState(
                icon: Icons.error_outline,
                title: 'Không thể tải thống kê',
                description:
                    'Vui lòng kiểm tra bộ nhớ trên thiết bị và thử lại.',
                actionLabel: 'Thử lại',
                onAction: _refresh,
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: libraryGreen),
              );
            }

            final books = snapshot.data!;
            if (books.isEmpty) {
              return _EmptyStatistics(
                onAddBook: widget.onAddBook == null ? null : _addBook,
              );
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              color: libraryGreen,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                children: [
                  const Text(
                    'Thống kê đọc sách',
                    style: TextStyle(
                      color: libraryInk,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Mỗi cuốn sách là một hành trình.',
                    style: TextStyle(color: libraryMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  StatisticsSummaryCard(
                    label: 'Tổng số sách',
                    value: books.length,
                    icon: Icons.menu_book_outlined,
                    wide: true,
                  ),
                  const SizedBox(height: 12),
                  _statusCards(books),
                  const SizedBox(height: 12),
                  ReadingStatusChart(books: books),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statusCards(List<Book> books) {
    int count(BookStatus status) =>
        books.where((book) => book.status == status).length;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.35,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        StatisticsSummaryCard(
          label: 'Đang đọc',
          value: count(BookStatus.reading),
          icon: Icons.menu_book_outlined,
        ),
        StatisticsSummaryCard(
          label: 'Đã đọc',
          value: count(BookStatus.completed),
          icon: Icons.check,
        ),
        StatisticsSummaryCard(
          label: 'Muốn đọc',
          value: count(BookStatus.wantToRead),
          icon: Icons.menu_book_outlined,
        ),
        StatisticsSummaryCard(
          label: 'Tạm dừng',
          value: count(BookStatus.paused),
          icon: Icons.menu_book_outlined,
        ),
      ],
    );
  }
}

class _EmptyStatistics extends StatelessWidget {
  const _EmptyStatistics({this.onAddBook});

  final VoidCallback? onAddBook;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFE9EFE5),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.menu_book_outlined,
                color: libraryGreen,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Chưa có dữ liệu thống kê',
              style: TextStyle(
                color: Color(0xFF354B36),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Thêm sách để bắt đầu hành trình đọc của bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(color: libraryMuted, fontSize: 12),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: FilledButton(
                onPressed: onAddBook,
                style: FilledButton.styleFrom(
                  backgroundColor: libraryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Thêm sách'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: libraryGreen, size: 36),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(description, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            TextButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
