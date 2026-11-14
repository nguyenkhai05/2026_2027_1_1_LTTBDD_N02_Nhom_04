# MyShelf

Ứng dụng quản lý sách cá nhân bằng Flutter. Đã có trang chủ, thư viện, thêm sách,
chi tiết sách, cập nhật tiến độ, thống kê và cài đặt. Chỉnh sửa sách và đổi
ngôn ngữ cho toàn bộ ứng dụng là các phần tiếp theo.

## Dữ liệu sách

- `lib/models/book.dart`: `Book`, bốn trạng thái đọc, dữ liệu bìa/ghi chú/yêu thích
  và kiểm tra số trang. `totalPages` có thể bỏ trống; khi đó chưa thể cập nhật
  `currentPage` khác 0.
- `lib/data/book_database.dart`: SQLite `myshelf.db`, schema phiên bản 1. Database
  mới bắt đầu trống, không tự chèn tám sách minh họa trong Figma.
- `lib/data/book_repository.dart`: đọc danh sách, tìm theo ID, thêm, cập nhật và
  xóa sách. Trang chủ, thư viện và thống kê đọc dữ liệu từ repository này.
- `lib/models/reading_statistics.dart`: tính số sách theo trạng thái và tỷ lệ
  tương ứng từ danh sách đang lưu.
- `lib/screens/book_detail_screen.dart`: mở từ thẻ sách ở trang chủ hoặc thư viện,
  tải dữ liệu theo ID, xem mô tả và ghi chú, đổi yêu thích, cập nhật tiến độ và
  xóa sách có xác nhận. Sau khi quay lại, danh sách được tải lại.

Dữ liệu được lưu cục bộ trên điện thoại (Android/iOS). Để cài dependency và chạy
kiểm thử:

```bash
flutter pub get
flutter analyze --no-fatal-infos
flutter test
flutter run
```

`flutter pub get` cũng cập nhật `pubspec.lock` sau khi thêm `sqflite` và `path`.
