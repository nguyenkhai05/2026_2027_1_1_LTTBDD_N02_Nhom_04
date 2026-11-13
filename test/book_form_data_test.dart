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
}
