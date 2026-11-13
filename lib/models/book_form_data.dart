import 'book.dart';

/// Values entered in the add/edit form before page counts are parsed.
class BookFormData {
  const BookFormData({
    required this.title,
    required this.author,
    this.genre,
    this.totalPagesText = '',
    this.currentPageText = '0',
    this.status = BookStatus.wantToRead,
  });

  final String title;
  final String author;
  final String? genre;
  final String totalPagesText;
  final String currentPageText;
  final BookStatus status;

  BookFormErrors validate() {
    final total = totalPagesText.trim();
    final current = currentPageText.trim();
    final totalPages = int.tryParse(total);
    final currentPage = int.tryParse(current);

    String? totalPagesError;
    if (total.isNotEmpty && (totalPages == null || totalPages <= 0)) {
      totalPagesError = 'Tổng số trang phải là số nguyên dương';
    }

    String? currentPageError;
    if (current.isNotEmpty && currentPage == null) {
      currentPageError = 'Số trang đã đọc phải là số nguyên không âm';
    } else if (currentPage != null && currentPage < 0) {
      currentPageError = 'Số trang đã đọc không được âm';
    } else if (currentPage != null && currentPage > 0 && total.isEmpty) {
      currentPageError = 'Hãy nhập tổng số trang để theo dõi tiến độ';
    } else if (totalPagesError == null &&
        totalPages != null &&
        currentPage != null &&
        currentPage > totalPages) {
      currentPageError = 'Số trang đã đọc không thể lớn hơn tổng số trang';
    }

    return BookFormErrors(
      title: title.trim().isEmpty ? 'Vui lòng nhập tên sách' : null,
      author: author.trim().isEmpty ? 'Vui lòng nhập tác giả' : null,
      totalPages: totalPagesError,
      currentPage: currentPageError,
    );
  }

  /// Call after [validate] succeeds; [Book] remains the storage boundary.
  Book toBook() {
    if (!validate().isValid) {
      throw const FormatException('Thông tin sách chưa hợp lệ');
    }
    return Book(
      title: title,
      author: author,
      genre: genre,
      status: status,
      totalPages: totalPagesText.trim().isEmpty
          ? null
          : int.parse(totalPagesText.trim()),
      currentPage: currentPageText.trim().isEmpty
          ? 0
          : int.parse(currentPageText.trim()),
    );
  }
}

class BookFormErrors {
  const BookFormErrors({this.title, this.author, this.totalPages, this.currentPage});

  final String? title;
  final String? author;
  final String? totalPages;
  final String? currentPage;

  bool get isValid =>
      title == null &&
      author == null &&
      totalPages == null &&
      currentPage == null;
}
