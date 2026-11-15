import 'package:flutter/material.dart';

import '../components/book_cover_thumbnail.dart';
import '../components/book_form_field.dart';
import '../models/book.dart';
import '../models/book_form_data.dart';
import '../theme/library_colors.dart';

/// Edits an existing book. [onSave] reports whether storage updated that ID.
class EditBookScreen extends StatefulWidget {
  const EditBookScreen({
    super.key,
    required this.book,
    required this.onSave,
  });

  final Book book;
  final Future<bool> Function(Book book) onSave;

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _author;
  late final TextEditingController _totalPages;
  late final TextEditingController _currentPage;
  late final TextEditingController _description;
  late final TextEditingController _notes;
  String? _genre;
  late BookStatus _status;
  bool _saving = false;

  static const _commonGenres = [
    'Văn học', 'Công nghệ', 'Kinh tế', 'Kỹ năng sống', 'Khoa học',
  ];

  BookFormData get _data => BookFormData(
    title: _title.text,
    author: _author.text,
    genre: _genre,
    totalPagesText: _totalPages.text,
    currentPageText: _currentPage.text,
    status: _status,
    description: _description.text,
    notes: _notes.text,
  );

  @override
  void initState() {
    super.initState();
    final book = widget.book;
    _title = TextEditingController(text: book.title);
    _author = TextEditingController(text: book.author);
    _totalPages = TextEditingController(text: book.totalPages?.toString() ?? '');
    _currentPage = TextEditingController(text: book.currentPage.toString());
    _description = TextEditingController(text: book.description ?? '');
    _notes = TextEditingController(text: book.notes ?? '');
    _genre = book.genre;
    _status = book.status;
  }

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _totalPages.dispose();
    _currentPage.dispose();
    _description.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể lưu. Vui lòng kiểm tra thông tin.')),
      );
      return;
    }
    setState(() { _saving = true; });
    try {
      final updated = await widget.onSave(_data.toUpdatedBook(widget.book));
      if (!updated) throw StateError('The book no longer exists');
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể lưu thay đổi. Hãy thử lại.')),
        );
      }
    } finally {
      if (mounted) setState(() { _saving = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final genres = [
      if (_genre != null && !_commonGenres.contains(_genre)) _genre!,
      ..._commonGenres,
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F0),
      appBar: AppBar(
        title: const Text('Chỉnh sửa sách', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF7F6F0),
        foregroundColor: libraryInk,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: BookCoverThumbnail(book: widget.book, width: 100, height: 150)),
                const SizedBox(height: 28),
                const Text('Thông tin cơ bản', style: TextStyle(
                  fontSize: 19, fontWeight: FontWeight.bold, color: libraryInk,
                )),
                const SizedBox(height: 18),
                BookFormField(
                  label: 'Tên sách *', hint: 'Nhập tên sách', controller: _title,
                  textInputAction: TextInputAction.next,
                  validator: (_) => _data.validate().title,
                ),
                const SizedBox(height: 22),
                BookFormField(
                  label: 'Tác giả *', hint: 'Nhập tên tác giả', controller: _author,
                  textInputAction: TextInputAction.next,
                  validator: (_) => _data.validate().author,
                ),
                const SizedBox(height: 22),
                BookFormDropdown<String>(
                  label: 'Thể loại', hint: 'Chưa phân loại', value: _genre,
                  items: [
                    const DropdownMenuItem<String>(value: null, child: Text('Chưa phân loại')),
                    for (final genre in genres)
                      DropdownMenuItem<String>(value: genre, child: Text(genre)),
                  ],
                  onChanged: (value) => setState(() { _genre = value; }),
                ),
                const SizedBox(height: 22),
                BookFormField(
                  label: 'Tổng số trang', hint: 'Chưa nhập', controller: _totalPages,
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  validator: (_) => _data.validate().totalPages,
                ),
                const SizedBox(height: 22),
                BookFormField(
                  label: 'Số trang đã đọc', hint: '0', controller: _currentPage,
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  validator: (_) => _data.validate().currentPage,
                ),
                const SizedBox(height: 22),
                BookFormDropdown<BookStatus>(
                  label: 'Trạng thái đọc *', hint: 'Chọn trạng thái đọc', value: _status,
                  items: const [
                    DropdownMenuItem(value: BookStatus.wantToRead, child: Text('Muốn đọc')),
                    DropdownMenuItem(value: BookStatus.reading, child: Text('Đang đọc')),
                    DropdownMenuItem(value: BookStatus.completed, child: Text('Đã đọc')),
                    DropdownMenuItem(value: BookStatus.paused, child: Text('Tạm dừng')),
                  ],
                  onChanged: (value) => setState(() { _status = value ?? _status; }),
                ),
                const SizedBox(height: 22),
                BookFormField(
                  label: 'Mô tả', hint: 'Thông tin về cuốn sách',
                  controller: _description, maxLines: 3,
                ),
                const SizedBox(height: 22),
                BookFormField(
                  label: 'Ghi chú cá nhân', hint: 'Ghi chú của bạn',
                  controller: _notes, maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(backgroundColor: libraryGreen),
              child: _saving
                  ? const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Lưu thay đổi'),
            ),
          ),
        ),
      ),
    );
  }
}
