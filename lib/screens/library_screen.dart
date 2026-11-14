import 'package:flutter/material.dart';

import '../components/home_bottom_navigation.dart';
import '../components/library_book_card.dart';
import '../components/library_empty_state.dart';
import '../components/library_delete_dialog.dart';
import '../components/library_filter_sheet.dart';
import '../components/library_search_field.dart';
import '../components/library_status_filters.dart';
import '../components/update_progress_sheet.dart';
import '../data/book_repository.dart';
import '../models/book.dart';
import '../models/library_query.dart';
import '../theme/library_colors.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({
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
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _search = TextEditingController();
  late Future<List<Book>> _booksFuture;
  BookStatus? _status;
  String? _genre;
  bool _favoritesOnly = false;
  LibrarySort _sort = LibrarySort.newest;
  final Set<int> _updating = {};

  @override
  void initState() {
    super.initState();
    _booksFuture = widget.repository.getAll();
    _search.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(covariant LibraryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repository != widget.repository) {
      _booksFuture = widget.repository.getAll();
    }
  }

  void _onSearchChanged() => setState(() {});

  @override
  void dispose() {
    _search.removeListener(_onSearchChanged);
    _search.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final future = widget.repository.getAll();
    setState(() {
      _booksFuture = future;
    });
    try {
      await future;
    } catch (_) {
      // The error is displayed by FutureBuilder, with a retry control.
    }
  }

  Future<void> _toggleFavorite(Book book) async {
    final id = book.id;
    if (id == null || _updating.contains(id)) return;
    setState(() => _updating.add(id));
    try {
      final updated = await widget.repository.update(
        book.copyWith(isFavorite: !book.isFavorite),
      );
      if (!updated) throw StateError('The book no longer exists');
      if (mounted) await _refresh();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể cập nhật yêu thích. Thử lại nhé.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _updating.remove(id));
    }
  }

  Future<void> _updateProgress(Book book) async {
    final id = book.id;
    if (id == null || _updating.contains(id)) return;

    final currentPage = await showUpdateProgressSheet(
      context,
      book: book,
      onEditBook: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Màn hình chỉnh sửa sách chưa được triển khai. Hãy bổ sung tổng số trang trước.',
            ),
          ),
        );
      },
    );

    if (!mounted || currentPage == null || currentPage == book.currentPage) {
      return;
    }

    setState(() => _updating.add(id));
    try {
      final updated = await widget.repository.update(
        book.copyWith(currentPage: currentPage),
      );
      if (!updated) throw StateError('The book no longer exists');
      if (!mounted) return;
      await _refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            currentPage == book.totalPages
                ? 'Bạn đã đọc hết sách. Có thể chuyển trạng thái sang Đã đọc.'
                : 'Đã cập nhật tiến độ đọc.',
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể cập nhật tiến độ. Thử lại nhé.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _updating.remove(id));
    }
  }

  Future<void> _deleteBook(Book book) async {
    final id = book.id;
    if (id == null || _updating.contains(id)) return;

    final confirmed = await showLibraryDeleteDialog(
      context,
      bookTitle: book.title,
    );

    if (!confirmed || !mounted) return;

    setState(() => _updating.add(id));

    try {
      final deleted = await widget.repository.delete(id);

      if (!deleted) {
        throw StateError('The book no longer exists');
      }

      if (!mounted) return;

      await _refresh();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã xóa sách thành công.')));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể xóa sách. Hãy thử lại.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _updating.remove(id));
      }
    }
  }

  Future<void> _handleAddBook() async {
    final openForm = widget.onAddBook;
    if (openForm == null) return;
    final added = await openForm();
    if (!mounted || !added) return;
    await _refresh();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã thêm sách thành công.')));
    }
  }

  Future<void> _openBook(Book book) async {
    final open = widget.onOpenBook;
    if (open == null || _updating.contains(book.id)) return;
    await open(book);
    if (mounted) await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F0),
      bottomNavigationBar: HomeBottomNavigation(
        currentIndex: 1,
        onTap: widget.onTabSelected,
      ),
      floatingActionButton: widget.onAddBook == null
          ? null
          : FloatingActionButton(
              onPressed: _handleAddBook,
              backgroundColor: libraryGreen,
              foregroundColor: Colors.white,
              tooltip: 'Thêm sách',
              child: const Icon(Icons.add),
            ),
      body: SafeArea(
        child: FutureBuilder<List<Book>>(
          future: _booksFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _messageView(
                icon: Icons.error_outline,
                title: 'Không thể tải thư viện',
                description: 'Kiểm tra bộ nhớ trên thiết bị rồi thử lại.',
                action: 'Thử lại',
                onAction: _refresh,
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final all = snapshot.data!;
            if (all.isEmpty) {
              return _messageView(
                icon: Icons.menu_book_outlined,
                title: 'Thư viện của bạn đang trống',
                description: 'Thêm cuốn sách đầu tiên để bắt đầu quản lý hành trình đọc.',
                action: widget.onAddBook == null ? null : 'Thêm sách đầu tiên',
                onAction: widget.onAddBook == null ? null : _handleAddBook,
              );
            }
            return _bookList(all);
          },
        ),
      ),
    );
  }

  Widget _bookList(List<Book> all) {
    final visible = filterLibraryBooks(
      all,
      query: _search.text,
      status: _status,
      genre: _genre,
      favoritesOnly: _favoritesOnly,
      sort: _sort,
    );
    final hasQuery = _search.text.trim().isNotEmpty;
    final filtersActive = _status != null || _genre != null || _favoritesOnly;
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 100),
        children: [
          const Text(
            'Thư viện của tôi',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: libraryInk,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${all.length} cuốn sách · Góc đọc của bạn',
            style: const TextStyle(fontSize: 14, color: libraryMuted),
          ),
          const SizedBox(height: 22),
          LibrarySearchField(controller: _search),
          const SizedBox(height: 20),
          LibraryStatusFilters(
            selected: _status,
            onChanged: (status) => setState(() => _status = status),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  filtersActive || hasQuery
                      ? '${visible.length} cuốn sách'
                      : 'Tất cả sách',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: libraryInk,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.tune,
                  color: filtersActive ? libraryGreen : libraryMuted,
                ),
                tooltip: 'Lọc sách',
                onPressed: () => _openFilters(all),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (visible.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: _emptyResults(hasQuery),
            )
          else
            for (final book in visible)
              LibraryBookCard(
                key: ValueKey(book.id),
                book: book,
                onTap: widget.onOpenBook == null ? null : () => _openBook(book),
                onFavorite: _updating.contains(book.id)
                    ? null
                    : () => _toggleFavorite(book),
                onDelete: _updating.contains(book.id)
                    ? null
                    : () => _deleteBook(book),
                onUpdateProgress: _updating.contains(book.id)
                    ? null
                    : () => _updateProgress(book),
              ),
        ],
      ),
    );
  }

  Widget _emptyResults(bool hasQuery) => LibraryEmptyState(
    icon: Icons.menu_book_outlined,
    title: hasQuery ? 'Không tìm thấy sách' : 'Không có sách phù hợp',
    description: hasQuery
        ? 'Thử tìm bằng tên sách hoặc tác giả khác.'
        : 'Thử chọn trạng thái hoặc bộ lọc khác.',
    action: hasQuery ? 'Xóa từ khóa' : 'Đặt lại bộ lọc',
    onAction: hasQuery
        ? _search.clear
        : () => setState(() {
            _status = null;
            _genre = null;
            _favoritesOnly = false;
          }),
  );

  Widget _messageView({
    required IconData icon,
    required String title,
    required String description,
    String? action,
    VoidCallback? onAction,
  }) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
    children: [
      const Text(
        'Thư viện của tôi',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: libraryInk,
        ),
      ),
      const SizedBox(height: 90),
      LibraryEmptyState(
        icon: icon,
        title: title,
        description: description,
        action: action,
        onAction: onAction,
      ),
    ],
  );

  Future<void> _openFilters(List<Book> books) async {
    final genres =
        books.map((book) => book.genre).whereType<String>().toSet().toList()
          ..sort();
    final selected = await showLibraryFilterSheet(
      context,
      genres: genres,
      initial: LibraryFilterSelection(
        status: _status,
        genre: _genre,
        favoritesOnly: _favoritesOnly,
        sort: _sort,
      ),
    );
    if (!mounted || selected == null) return;
    setState(() {
      _status = selected.status;
      _genre = selected.genre;
      _favoritesOnly = selected.favoritesOnly;
      _sort = selected.sort;
    });
  }
}
