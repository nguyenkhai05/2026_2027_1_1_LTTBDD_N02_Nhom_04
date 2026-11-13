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
}) => showModalBottomSheet<LibraryFilterSelection>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => LibraryFilterSheet(genres: genres, initial: initial),
);

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

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Lọc sách',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Đóng',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Trạng thái đọc', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final entry in const [
                ('Muốn đọc', BookStatus.wantToRead),
                ('Đang đọc', BookStatus.reading),
                ('Đã đọc', BookStatus.completed),
                ('Tạm dừng', BookStatus.paused),
              ])
                _chip(
                  entry.$1,
                  _status == entry.$2,
                  () => setState(() => _status =
                      _status == entry.$2 ? null : entry.$2),
                ),
            ],
          ),
          if (widget.genres.isNotEmpty) ...[
            const SizedBox(height: 18),
            const Text('Thể loại', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final item in widget.genres)
                  _chip(
                    item,
                    _genre == item,
                    () => setState(() => _genre = _genre == item ? null : item),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 18),
          const Text('Yêu thích', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _chip('Tất cả', !_favoritesOnly,
                  () => setState(() => _favoritesOnly = false)),
              _chip('Chỉ yêu thích', _favoritesOnly,
                  () => setState(() => _favoritesOnly = true)),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Sắp xếp', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final entry in const [
                ('Mới thêm nhất', LibrarySort.newest),
                ('Tên A–Z', LibrarySort.titleAsc),
                ('Cũ nhất', LibrarySort.oldest),
                ('Tên Z–A', LibrarySort.titleDesc),
              ])
                _chip(entry.$1, _sort == entry.$2,
                    () => setState(() => _sort = entry.$2)),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    _status = null;
                    _genre = null;
                    _favoritesOnly = false;
                    _sort = LibrarySort.newest;
                  }),
                  child: const Text('Đặt lại'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: () => Navigator.pop(
                    context,
                    LibraryFilterSelection(
                      status: _status,
                      genre: _genre,
                      favoritesOnly: _favoritesOnly,
                      sort: _sort,
                    ),
                  ),
                  style: FilledButton.styleFrom(backgroundColor: libraryGreen),
                  child: const Text('Áp dụng'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _chip(String label, bool selected, VoidCallback onTap) => ChoiceChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onTap(),
    showCheckmark: false,
    selectedColor: libraryGreen,
    labelStyle: TextStyle(color: selected ? Colors.white : libraryMuted),
    side: BorderSide.none,
  );
}
