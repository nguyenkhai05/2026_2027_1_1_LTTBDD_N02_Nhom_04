import 'package:flutter/material.dart';
import '../l10n/app_text.dart';

import '../models/book.dart';
import '../theme/library_colors.dart';

class LibraryStatusFilters extends StatelessWidget {
  const LibraryStatusFilters({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final BookStatus? selected;
  final ValueChanged<BookStatus?> onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        _chip('Tất cả', null),
        _chip('Muốn đọc', BookStatus.wantToRead),
        _chip('Đang đọc', BookStatus.reading),
        _chip('Đã đọc', BookStatus.completed),
        _chip('Tạm dừng', BookStatus.paused),
      ],
    ),
  );

  Widget _chip(String label, BookStatus? value) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ChoiceChip(
      label: LText(label),
      selected: selected == value,
      onSelected: (_) => onChanged(value),
      showCheckmark: false,
      selectedColor: libraryGreen,
      backgroundColor: Colors.white,
      side: BorderSide.none,
      labelStyle: TextStyle(color: selected == value ? Colors.white : libraryMuted),
    ),
  );
}
