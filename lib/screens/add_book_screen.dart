import 'package:flutter/material.dart';

import '../components/book_cover_placeholder.dart';
import '../components/book_form_field.dart';
import '../models/book.dart';
import '../models/book_form_data.dart';
import '../theme/library_colors.dart';

/// Collects and validates a new book; persistence is supplied by its caller.
class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key, required this.onSave});

  final Future<void> Function(Book book) onSave;

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _totalPages = TextEditingController();
  final _currentPage = TextEditingController(text: '0');
  String? _genre;
  BookStatus _status = BookStatus.wantToRead;
  bool _saving = false;

  BookFormData get _data => BookFormData(
    title: _title.text,
    author: _author.text,
    genre: _genre,
    totalPagesText: _totalPages.text,
    currentPageText: _currentPage.text,
    status: _status,
  );

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _totalPages.dispose();
    _currentPage.dispose();
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
    setState(() => _saving = true);
    try {
      await widget.onSave(_data.toBook());
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể lưu sách. Hãy thử lại.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F6F0),
    appBar: AppBar(
      title: const Text('Thêm sách', style: TextStyle(fontWeight: FontWeight.bold)),
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
            const Center(child: BookCoverPlaceholder()),
            const SizedBox(height: 28),
            const Text(
              'Thông tin cơ bản',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: libraryInk,
              ),
            ),
            const SizedBox(height: 18),
            BookFormField(
              label: 'Tên sách *',
              hint: 'Nhập tên sách',
              controller: _title,
              textInputAction: TextInputAction.next,
              validator: (_) => _data.validate().title,
            ),
            const SizedBox(height: 22),
            BookFormField(
              label: 'Tác giả *',
              hint: 'Nhập tên tác giả',
              controller: _author,
              textInputAction: TextInputAction.next,
              validator: (_) => _data.validate().author,
            ),
            const SizedBox(height: 22),
            BookFormDropdown<String>(
              label: 'Thể loại',
              hint: 'Chọn thể loại',
              value: _genre,
              items: const [
                DropdownMenuItem(value: 'Văn học', child: Text('Văn học')),
                DropdownMenuItem(value: 'Công nghệ', child: Text('Công nghệ')),
                DropdownMenuItem(value: 'Kinh tế', child: Text('Kinh tế')),
                DropdownMenuItem(value: 'Kỹ năng sống', child: Text('Kỹ năng sống')),
              ],
              onChanged: (value) => setState(() => _genre = value),
            ),
            const SizedBox(height: 22),
            BookFormField(
              label: 'Tổng số trang',
              hint: 'Không bắt buộc',
              controller: _totalPages,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              validator: (_) => _data.validate().totalPages,
            ),
            const SizedBox(height: 22),
            BookFormField(
              label: 'Số trang đã đọc',
              hint: '0',
              controller: _currentPage,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              validator: (_) => _data.validate().currentPage,
            ),
            const SizedBox(height: 22),
            BookFormDropdown<BookStatus>(
              label: 'Trạng thái đọc *',
              hint: 'Chọn trạng thái đọc',
              value: _status,
              items: const [
                DropdownMenuItem(value: BookStatus.wantToRead, child: Text('Muốn đọc')),
                DropdownMenuItem(value: BookStatus.reading, child: Text('Đang đọc')),
                DropdownMenuItem(value: BookStatus.completed, child: Text('Đã đọc')),
                DropdownMenuItem(value: BookStatus.paused, child: Text('Tạm dừng')),
              ],
              onChanged: (value) => setState(() => _status = value ?? _status),
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
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Lưu sách'),
          ),
        ),
      ),
    ),
  );
}
