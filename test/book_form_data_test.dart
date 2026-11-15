import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/models/book.dart';
import 'package:lt_tbdd/models/book_form_data.dart';

void main() {
  test('accepts required fields and optional page count', () {
    const data = BookFormData(
      title: '  Hoàng Tử Bé  ',
      author: '  Antoine de Saint-Exupéry  ',
      genre: 'Văn học',
      totalPagesText: '120',
      currentPageText: '40',
      status: BookStatus.reading,
    );
    expect(data.validate().isValid, isTrue);
    final book = data.toBook();
    expect(book.title, 'Hoàng Tử Bé');
    expect(book.author, 'Antoine de Saint-Exupéry');
    expect(book.genre, 'Văn học');
    expect(book.totalPages, 120);
    expect(book.currentPage, 40);
    expect(book.status, BookStatus.reading);

    const withoutPages = BookFormData(title: 'Sách', author: 'Tác giả');
    expect(withoutPages.toBook().totalPages, isNull);
    expect(withoutPages.toBook().currentPage, 0);
  });

  test('rejects empty fields and invalid page counts', () {
    const missing = BookFormData(title: '  ', author: '');
    expect(missing.validate().title, 'Vui lòng nhập tên sách');
    expect(missing.validate().author, 'Vui lòng nhập tác giả');
    expect(missing.toBook, throwsFormatException);

    for (final value in ['0', '-1', '3.5', 'abc']) {
      expect(
        BookFormData(title: 'Sách', author: 'Tác giả', totalPagesText: value)
            .validate()
            .totalPages,
        'Tổng số trang phải là số nguyên dương',
      );
    }

    expect(
      const BookFormData(
        title: 'Sách', author: 'Tác giả', totalPagesText: '120', currentPageText: '-1',
      ).validate().currentPage,
      'Số trang đã đọc không được âm',
    );
    expect(
      const BookFormData(
        title: 'Sách', author: 'Tác giả', totalPagesText: '120', currentPageText: '140',
      ).validate().currentPage,
      'Số trang đã đọc không thể lớn hơn tổng số trang',
    );
    expect(
      const BookFormData(title: 'Sách', author: 'Tác giả', currentPageText: '1')
          .validate().currentPage,
      'Hãy nhập tổng số trang để theo dõi tiến độ',
    );
  });

  test('editing retains stored identity and optional fields while allowing clears', () {
    final created = DateTime.utc(2026, 1, 1);
    final original = Book(
      id: 42,
      title: 'Sách cũ',
      author: 'Tác giả cũ',
      genre: 'Văn học',
      description: 'Mô tả cũ',
      notes: 'Ghi chú cũ',
      coverPath: '/local/cover.png',
      isFavorite: true,
      totalPages: 200,
      currentPage: 120,
      createdAt: created,
    );
    final edited = const BookFormData(
      title: '  Sách mới  ',
      author: 'Tác giả mới',
      totalPagesText: '250',
      currentPageText: '160',
      status: BookStatus.reading,
      description: '',
      notes: 'Ghi chú mới',
    ).toUpdatedBook(original);

    expect(edited.id, original.id);
    expect(edited.title, 'Sách mới');
    expect(edited.author, 'Tác giả mới');
    expect(edited.genre, isNull);
    expect(edited.description, isNull);
    expect(edited.notes, 'Ghi chú mới');
    expect(edited.coverPath, original.coverPath);
    expect(edited.isFavorite, isTrue);
    expect(edited.createdAt, created);
    expect(edited.totalPages, 250);
    expect(edited.currentPage, 160);

    final noPages = const BookFormData(
      title: 'Sách mới', author: 'Tác giả mới', currentPageText: '0',
    ).toUpdatedBook(edited);
    expect(noPages.totalPages, isNull);
    expect(noPages.currentPage, 0);
    expect(
      () => const BookFormData(
        title: 'Sách', author: 'Tác giả', totalPagesText: '100',
        currentPageText: '160',
      ).toUpdatedBook(original),
      throwsFormatException,
    );
  });
}
