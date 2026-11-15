import 'package:flutter/material.dart';

import '../models/app_language.dart';

/// The selected language is available to every page, including pushed routes.
class AppLanguageScope extends InheritedWidget {
  const AppLanguageScope({
    super.key,
    required this.language,
    required super.child,
  });

  final AppLanguage language;

  static AppLanguage of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppLanguageScope>()?.language ??
      AppLanguage.vietnamese;

  @override
  bool updateShouldNotify(AppLanguageScope oldWidget) => language != oldWidget.language;
}

// Vietnamese source strings are the stable lookup keys. Unknown strings, such
// as a user's book title, are never modified by the translation helper.
const englishText = <String, String>{
  'Trang chủ': 'Home',
  'Thư viện': 'Library',
  'Thống kê': 'Statistics',
  'Chỉnh sửa': 'Edit',
  'Chỉnh sửa sách': 'Edit book',
  'Xóa sách': 'Delete book',
  'Cập nhật tiến độ': 'Update progress',
  'Chi tiết sách': 'Book details',
  'Thử lại': 'Try again',
  'Không thể lưu. Vui lòng kiểm tra thông tin.': 'Could not save. Check the information entered.',
  'Không thể lưu sách. Hãy thử lại.': 'Could not save the book. Please try again.',
  'Không thể lưu thay đổi. Hãy thử lại.': 'Could not save changes. Please try again.',
  'Thêm sách': 'Add book',
  'Thông tin cơ bản': 'Basic information',
  'Văn học': 'Literature',
  'Công nghệ': 'Technology',
  'Kinh tế': 'Economics',
  'Kỹ năng sống': 'Life skills',
  'Khoa học': 'Science',
  'Muốn đọc': 'Want to read',
  'Đang đọc': 'Reading',
  'Đã đọc': 'Completed',
  'Tạm dừng': 'Paused',
  'Lưu sách': 'Save book',
  'Lưu thay đổi': 'Save changes',
  'Tên sách *': 'Book title *',
  'Nhập tên sách': 'Enter book title',
  'Tác giả *': 'Author *',
  'Nhập tên tác giả': 'Enter author',
  'Thể loại': 'Genre',
  'Chọn thể loại': 'Choose a genre',
  'Tổng số trang': 'Total pages',
  'Không bắt buộc': 'Optional',
  'Chưa nhập': 'Not entered',
  'Số trang đã đọc': 'Pages read',
  'Trạng thái đọc *': 'Reading status *',
  'Chọn trạng thái đọc': 'Choose a reading status',
  'Thông tin về cuốn sách': 'About the book',
  'Ghi chú của bạn': 'Your notes',
  'Chưa phân loại': 'Uncategorized',
  'Vui lòng nhập tên sách': 'Please enter a book title',
  'Vui lòng nhập tác giả': 'Please enter an author',
  'Tổng số trang phải là số nguyên dương': 'Total pages must be a positive whole number',
  'Số trang đã đọc phải là số nguyên không âm': 'Pages read must be a nonnegative whole number',
  'Số trang đã đọc không được âm': 'Pages read cannot be negative',
  'Hãy nhập tổng số trang để theo dõi tiến độ': 'Enter total pages to track reading progress',
  'Số trang đã đọc không thể lớn hơn tổng số trang': 'Pages read cannot exceed total pages',
  'Vui lòng nhập số trang hợp lệ': 'Enter a valid page number',
  'Số trang đã đọc không thể lớn hơn số trang': 'Pages read cannot exceed total pages',
  'Cài đặt': 'Settings',
  'Nhẹ nhàng, theo cách của bạn.': 'Make it yours, at your own pace.',
  'TÙY CHỈNH': 'PREFERENCES',
  'Ngôn ngữ': 'Language',
  'Ngôn ngữ của bạn': 'Your language',
  'Chọn ngôn ngữ hiển thị trong ứng dụng. Tên sách và tác giả sẽ được giữ nguyên.':
      'Choose the app language. Book titles and authors stay as you entered them.',
  'Không thể lưu ngôn ngữ. Hãy thử lại.': 'Could not save the language. Please try again.',
  'VỀ ỨNG DỤNG': 'ABOUT THE APP',
  'Thư viện cá nhân, luôn bên bạn.': 'Your personal library, always with you.',
  'Quản lý sách và theo dõi tiến độ đọc.': 'Organize books and track your reading.',
  'Thông tin nhóm': 'Team information',
  'Một góc đọc, của riêng bạn.': 'A reading corner of your own.',
  'Ứng dụng quản lý sách cá nhân': 'Personal book manager',
  'Ứng dụng hỗ trợ quản lý thư viện cá nhân và theo dõi tiến độ đọc.':
      'Organize your personal library and track reading progress.',
  'Thông tin thành viên': 'Team members',
  'Thông tin thành viên nhóm sẽ được cập nhật tại đây.': 'Team member details will be added here.',
  'Cảm ơn bạn đã sử dụng MyShelf.': 'Thank you for using MyShelf.',
  'Không thể tải trang chủ.': 'Could not load Home.',
  'Không thể tải thư viện': 'Could not load the library',
  'Không thể tải chi tiết sách': 'Could not load book details',
  'Kiểm tra bộ nhớ trên thiết bị rồi thử lại.': 'Check device storage and try again.',
  'Thư viện của tôi': 'My library',
  'Thư viện của bạn đang trống': 'Your library is empty',
  'Thêm cuốn sách đầu tiên để bắt đầu quản lý hành trình đọc.':
      'Add your first book to start tracking your reading journey.',
  'Tất cả sách': 'All books',
  'Không tìm thấy sách': 'No books found',
  'Không có sách phù hợp': 'No matching books',
  'Thử tìm bằng tên sách hoặc tác giả khác.': 'Try another title or author.',
  'Thử chọn trạng thái hoặc bộ lọc khác.': 'Try a different status or filter.',
  'Xóa từ khóa': 'Clear search',
  'Đặt lại bộ lọc': 'Reset filters',
  'Tìm tên sách hoặc tác giả': 'Search title or author',
  'Lọc sách': 'Filter books',
  'Đặt lại': 'Reset',
  'Áp dụng': 'Apply',
  'Yêu thích': 'Favorites',
  'Chỉ yêu thích': 'Favorites only',
  'Sắp xếp': 'Sort by',
  'Mới thêm nhất': 'Recently added',
  'Cũ nhất': 'Oldest',
  'Tên A–Z': 'Title A–Z',
  'Tên Z–A': 'Title Z–A',
  'Tất cả': 'All',
  'Đã thêm sách thành công.': 'Book added successfully.',
  'Đã xóa sách thành công.': 'Book deleted successfully.',
  'Không thể xóa sách. Hãy thử lại.': 'Could not delete the book. Please try again.',
  'Không thể cập nhật yêu thích. Thử lại nhé.': 'Could not update favorites. Please try again.',
  'Không thể cập nhật tiến độ. Thử lại nhé.': 'Could not update progress. Please try again.',
  'Đã cập nhật tiến độ đọc.': 'Reading progress updated.',
  'Bạn đã đọc hết sách. Có thể chuyển trạng thái sang Đã đọc.':
      'You reached the final page. You can mark this book completed.',
  'Bỏ khỏi yêu thích': 'Remove from favorites',
  'Thêm vào yêu thích': 'Add to favorites',
  'Đóng': 'Close',
  'Quay lại': 'Back',
  'Xóa sách?': 'Delete book?',
  'Bạn có chắc muốn xóa "{title}" khỏi thư viện không?':
      'Remove "{title}" from your library?',
  'Thao tác này không thể hoàn tác.': 'This action cannot be undone.',
  'Hủy': 'Cancel',
  'Xóa': 'Delete',
  'Chưa có bìa': 'No cover',
  'Xin chào!': 'Hello!',
  'Hôm nay bạn muốn đọc gì?': 'What would you like to read today?',
  'Xem tất cả': 'View all',
  'Đọc tiếp': 'Continue reading',
  'Chưa có sách đang đọc': 'No books in progress',
  'Hãy chọn một cuốn sách và bắt đầu hành trình đọc nhé!':
      'Pick a book and start your reading journey!',
  'Mới thêm gần đây': 'Recently added',
  'Thêm sách đầu tiên để bắt đầu quản lý thư viện nhé!':
      'Add your first book to start your library!',
  'Thêm sách đầu tiên': 'Add your first book',
  'Tổng số sách': 'Total books',
  'Không thể tải thống kê': 'Could not load statistics',
  'Vui lòng kiểm tra bộ nhớ trên thiết bị và thử lại.':
      'Check device storage and try again.',
  'Thống kê đọc sách': 'Reading statistics',
  'Mỗi cuốn sách là một hành trình.': 'Every book is a journey.',
  'Chưa có dữ liệu thống kê': 'No reading statistics yet',
  'Thêm sách để bắt đầu hành trình đọc của bạn.':
      'Add a book to start your reading journey.',
  'Trạng thái đọc': 'Reading status',
  'Tiến độ đọc': 'Reading progress',
  'Chưa có thông tin tổng số trang': 'Total pages not entered',
  'Bổ sung tổng số trang trong Chỉnh sửa để cập nhật tiến độ.':
      'Enter total pages in Edit to update progress.',
  'Bổ sung tổng số trang trong Chỉnh sửa sách trước khi cập nhật tiến độ theo trang.':
      'Enter total pages in Edit book before tracking pages read.',
  'Bạn hiện đã đọc đến trang': 'You have read up to page',
  'Hiện tại': 'Current',
  'hoàn thành': 'complete',
  'trang': 'pages',
  'Lưu tiến độ': 'Save progress',
  'THỂ LOẠI': 'GENRE',
  'TỔNG SỐ TRANG': 'TOTAL PAGES',
  'Mô tả': 'Description',
  'Ghi chú cá nhân': 'Personal notes',
};

String tr(BuildContext context, String vietnamese) =>
    AppLanguageScope.of(context) == AppLanguage.english
        ? englishText[vietnamese] ?? vietnamese
        : vietnamese;

/// Translates static interface copy without changing the Flutter Text API used
/// by our shared components. Book titles and user-authored text use Text.
class LText extends StatelessWidget {
  const LText(this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) => Text(
    tr(context, data),
    style: style,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );
}
