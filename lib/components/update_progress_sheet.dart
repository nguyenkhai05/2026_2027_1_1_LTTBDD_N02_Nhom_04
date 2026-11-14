import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/book.dart';
import '../theme/library_colors.dart';

Future<int?> showUpdateProgressSheet(
  BuildContext context, {
  required Book book,
  VoidCallback? onEditBook,
}) => showModalBottomSheet<int>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  backgroundColor: Colors.transparent,
  builder: (_) => UpdateProgressSheet(book: book, onEditBook: onEditBook),
);

class UpdateProgressSheet extends StatefulWidget {
  const UpdateProgressSheet({super.key, required this.book, this.onEditBook});

  final Book book;
  final VoidCallback? onEditBook;

  @override
  State<UpdateProgressSheet> createState() => _UpdateProgressSheetState();
}

class _UpdateProgressSheetState extends State<UpdateProgressSheet> {
  late final TextEditingController _pageController;
  String? _errorText;

  int? get _enteredPage => int.tryParse(_pageController.text.trim());

  int? get _totalPages => widget.book.totalPages;

  bool get _isValid {
    final page = _enteredPage;
    final total = _totalPages;
    return total != null && page != null && page >= 0 && page <= total;
  }

  double? get _previewProgress {
    final total = _totalPages;
    final page = _enteredPage;
    if (total == null || page == null || page < 0 || page > total) {
      return null;
    }
    return page / total;
  }

  @override
  void initState() {
    super.initState();
    _pageController = TextEditingController(
      text: widget.book.currentPage.toString(),
    )..addListener(_validateInput);
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_validateInput)
      ..dispose();
    super.dispose();
  }

  void _validateInput() {
    final page = _enteredPage;
    final total = _totalPages;
    String? error;

    if (_pageController.text.trim().isEmpty || page == null) {
      error = 'Vui lòng nhập số trang hợp lệ';
    } else if (page < 0) {
      error = 'Số trang đã đọc không được âm';
    } else if (total != null && page > total) {
      error = 'Số trang đã đọc không thể lớn hơn số trang';
    }

    setState(() => _errorText = error);
  }

  void _save() {
    if (!_isValid) {
      _validateInput();
      return;
    }
    Navigator.of(context).pop(_enteredPage);
  }

  @override
  Widget build(BuildContext context) {
    final total = _totalPages;
    final progress = _previewProgress;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7DF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Cập nhật tiến độ',
                      style: TextStyle(
                        color: libraryInk,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Đóng',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.close,
                      size: 19,
                      color: libraryMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                widget.book.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: libraryGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              if (total == null)
                _MissingTotalPages(onEditBook: widget.onEditBook)
              else ...[
                Text(
                  'Hiện tại: ${widget.book.currentPage} / $total trang',
                  style: const TextStyle(color: libraryMuted, fontSize: 11),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Bạn hiện đã đọc đến trang',
                  style: TextStyle(color: libraryInk, fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _pageController,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 13,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF7F6F0),
                    suffixText: '/ $total',
                    suffixStyle: const TextStyle(
                      color: libraryMuted,
                      fontSize: 11,
                    ),
                    errorText: _errorText,
                    enabledBorder: _inputBorder(),
                    focusedBorder: _inputBorder(
                      color: libraryGreen,
                      width: 1.4,
                    ),
                    errorBorder: _inputBorder(color: const Color(0xFFD65B54)),
                    focusedErrorBorder: _inputBorder(
                      color: const Color(0xFFD65B54),
                      width: 1.4,
                    ),
                  ),
                ),
                if (progress != null) ...[
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFE5E7DF),
                      valueColor: const AlwaysStoppedAnimation(libraryGreen),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(progress * 100).round()}% hoàn thành',
                    style: const TextStyle(
                      color: libraryGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: FilledButton(
                    onPressed: _isValid ? _save : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: libraryGreen,
                      disabledBackgroundColor: const Color(0xFFB7C2B5),
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Lưu tiến độ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _inputBorder({
    Color color = const Color(0xFFB9C5B5),
    double width = 1,
  }) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(9),
    borderSide: BorderSide(color: color, width: width),
  );
}

class _MissingTotalPages extends StatelessWidget {
  const _MissingTotalPages({this.onEditBook});

  final VoidCallback? onEditBook;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Chưa có thông tin tổng số trang',
        style: TextStyle(
          color: libraryGreen,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'Bổ sung tổng số trang trong Chỉnh sửa sách trước khi cập nhật tiến độ theo trang.',
        style: TextStyle(color: libraryMuted, fontSize: 11, height: 1.45),
      ),
      const SizedBox(height: 14),
      SizedBox(
        width: double.infinity,
        height: 46,
        child: FilledButton(
          onPressed: onEditBook,
          style: FilledButton.styleFrom(
            backgroundColor: libraryGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Chỉnh sửa sách',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    ],
  );
}
