# MyShelf

Ứng dụng quản lý sách cá nhân bằng Flutter. Giao diện hiện có trang chủ; các màn
hình thư viện, chi tiết, thêm/sửa sách, thống kê và cài đặt đang được phát triển.

## Dữ liệu sách

- `lib/models/book.dart`: `Book`, bốn trạng thái đọc, dữ liệu bìa/ghi chú/yêu thích
  và kiểm tra số trang. `totalPages` có thể bỏ trống; khi đó chưa thể cập nhật
  `currentPage` khác 0.
- `lib/data/book_database.dart`: SQLite `myshelf.db`, schema phiên bản 1. Database
  mới bắt đầu trống, không tự chèn tám sách minh họa trong Figma.
- `lib/data/book_repository.dart`: đọc danh sách, tìm theo ID, thêm, cập nhật và
  xóa sách. Các màn hình sau sẽ gọi repository này thay cho dữ liệu viết cố định.

Dữ liệu được lưu cục bộ trên điện thoại (Android/iOS). Để cài dependency và chạy
kiểm thử:

```bash
flutter pub get
flutter test
flutter run
```

`flutter pub get` cũng cập nhật `pubspec.lock` sau khi thêm `sqflite` và `path`.
