import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/models/book.dart';

void main() {
  test('book validates page counts and normalizes text', () {
    final book = Book(
      title: '  Nhà Giả Kim  ',
      author: '  Paulo Coelho  ',
      genre: '  Văn học ',
      totalPages: 200,
      currentPage: 120,
      status: BookStatus.reading,
    );

    expect(book.title, 'Nhà Giả Kim');
    expect(book.author, 'Paulo Coelho');
    expect(book.genre, 'Văn học');
    expect(book.progress, 0.6);
    expect(
      Book(title: 'Atomic Habits', author: 'James Clear').progress,
      isNull,
    );

    expect(() => Book(title: ' ', author: 'Tác giả'), throwsArgumentError);
    expect(() => Book(title: 'Sách', author: ''), throwsArgumentError);
    expect(
      () => Book(title: 'Sách', author: 'Tác giả', totalPages: 0),
      throwsArgumentError,
    );
    expect(
      () => Book(title: 'Sách', author: 'Tác giả', currentPage: -1),
      throwsArgumentError,
    );
    expect(
      () => Book(title: 'Sách', author: 'Tác giả', currentPage: 1),
      throwsArgumentError,
    );
    expect(
      () => Book(
        title: 'Sách',
        author: 'Tác giả',
        totalPages: 100,
        currentPage: 101,
      ),
      throwsArgumentError,
    );
  });

  test('status has a stable database representation', () {
    for (final status in BookStatus.values) {
      expect(BookStatus.fromStorageValue(status.storageValue), status);
    }
    expect(() => BookStatus.fromStorageValue('unknown'), throwsFormatException);
  });
}
