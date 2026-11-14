import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/library_query.dart';
import '../theme/library_colors.dart';

class LibraryFilterSelection {
  const LibraryFilterSelection({
    this.status,
    this.genre,
    this.favoritesOnly = false,
    this.sort = LibrarySort.newest,
  });

  final BookStatus? status;
  final String? genre;
  final bool favoritesOnly;
  final LibrarySort sort;
}

Future<LibraryFilterSelection?> showLibraryFilterSheet(
  BuildContext context, {
  required List<String> genres,
  required LibraryFilterSelection initial,
}) {
  return showModalBottomSheet<LibraryFilterSelection>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (_) {
      return LibraryFilterSheet(genres: genres, initial: initial);
    },
  );
}

class LibraryFilterSheet extends StatefulWidget {
  const LibraryFilterSheet({
    super.key,
    required this.genres,
    required this.initial,
  });

  final List<String> genres;
  final LibraryFilterSelection initial;

  @override
  State<LibraryFilterSheet> createState() => _LibraryFilterSheetState();
}

class _LibraryFilterSheetState extends State<LibraryFilterSheet> {
  late BookStatus? _status = widget.initial.status;
  late String? _genre = widget.initial.genre;
  late bool _favoritesOnly = widget.initial.favoritesOnly;
  late LibrarySort _sort = widget.initial.sort;

  static const Color _background = Color(0xFFF7F6F0);
  static const Color _textColor = Color(0xFF252A24);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.92,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7E1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Lọc sách',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: _textColor,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close,
                              color: Color(0xFF687066),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      _sectionTitle('Trạng thái đọc'),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final entry in const [
                            ('Muốn đọc', BookStatus.wantToRead),
                            ('Đang đọc', BookStatus.reading),
                            ('Đã đọc', BookStatus.completed),
                            ('Tạm dừng', BookStatus.paused),
                          ])
                            _filterChip(entry.$1, _status == entry.$2, () {
                              setState(() {
                                _status = _status == entry.$2 ? null : entry.$2;
                              });
                            }),
                        ],
                      ),

                      const SizedBox(height: 18),

                      _sectionTitle('Thể loại'),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final genre in widget.genres)
                            _filterChip(genre, _genre == genre, () {
                              setState(() {
                                _genre = _genre == genre ? null : genre;
                              });
                            }),
                        ],
                      ),

                      const SizedBox(height: 18),

                      _sectionTitle('Yêu thích'),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        children: [
                          _filterChip('Tất cả', !_favoritesOnly, () {
                            setState(() {
                              _favoritesOnly = false;
                            });
                          }),
                          _filterChip('Chỉ yêu thích', _favoritesOnly, () {
                            setState(() {
                              _favoritesOnly = true;
                            });
                          }),
                        ],
                      ),

                      const SizedBox(height: 18),

                      _sectionTitle('Sắp xếp'),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final entry in const [
                            ('Mới thêm nhất', LibrarySort.newest),
                            ('Tên A–Z', LibrarySort.titleAsc),
                            ('Cũ nhất', LibrarySort.oldest),
                            ('Tên Z–A', LibrarySort.titleDesc),
                          ])
                            _filterChip(entry.$1, _sort == entry.$2, () {
                              setState(() {
                                _sort = entry.$2;
                              });
                            }),
                        ],
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: _resetFilters,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFE8EEE5),
                            foregroundColor: const Color(0xFF354B36),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Đặt lại',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: _applyFilters,
                          style: FilledButton.styleFrom(
                            backgroundColor: libraryGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Áp dụng',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: _textColor,
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? libraryGreen : _background,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : libraryMuted,
          ),
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _status = null;
      _genre = null;
      _favoritesOnly = false;
      _sort = LibrarySort.newest;
    });
  }

  void _applyFilters() {
    Navigator.pop(
      context,
      LibraryFilterSelection(
        status: _status,
        genre: _genre,
        favoritesOnly: _favoritesOnly,
        sort: _sort,
      ),
    );
  }
}
