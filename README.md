# MyShelf

Ứng dụng quản lý sách cá nhân bằng Flutter. Đã có trang chủ, thư viện, thêm sách,
chi tiết sách, chỉnh sửa sách, cập nhật tiến độ, thống kê, cài đặt và chuyển
ngôn ngữ giao diện giữa Tiếng Việt/English.

## Nhóm 4

- Nguyễn Quốc Khải · 23010403
- Phù Ngọc Hào · 23010384

## Dữ liệu sách

- `lib/models/book.dart`: `Book`, bốn trạng thái đọc, dữ liệu bìa/ghi chú/yêu thích
  và kiểm tra số trang. `totalPages` có thể bỏ trống; khi đó chưa thể cập nhật
  `currentPage` khác 0.
- `lib/data/book_database.dart`: SQLite `myshelf.db`, schema phiên bản 2. Database
  mới bắt đầu trống, không tự chèn tám sách minh họa trong Figma.
- `lib/data/app_language_store.dart`: lưu mã ngôn ngữ trong bảng `app_settings`;
  cơ sở dữ liệu phiên bản 1 được nâng cấp mà không xóa sách cũ.
- `lib/l10n/app_text.dart`: dịch nhãn giao diện trên các màn hình. Tên sách, tác
  giả, mô tả và ghi chú của người dùng không bị thay đổi trong cơ sở dữ liệu.
- `lib/data/book_repository.dart`: đọc danh sách, tìm theo ID, thêm, cập nhật và
  xóa sách. Trang chủ, thư viện và thống kê đọc dữ liệu từ repository này.
- `lib/models/reading_statistics.dart`: tính số sách theo trạng thái và tỷ lệ
  tương ứng từ danh sách đang lưu.
- `lib/screens/book_detail_screen.dart`: mở từ thẻ sách ở trang chủ hoặc thư viện,
  tải dữ liệu theo ID, xem mô tả và ghi chú, đổi yêu thích, cập nhật tiến độ và
  xóa sách có xác nhận. Sau khi quay lại, danh sách được tải lại.
- `lib/screens/edit_book_screen.dart`: điền sẵn dữ liệu sách, sửa thông tin và
  lưu qua repository; có thể mở từ màn chi tiết hoặc bảng tiến độ khi thiếu tổng
  số trang. ID, bìa, yêu thích và thời điểm tạo được giữ nguyên.

Dữ liệu được lưu cục bộ trên điện thoại (Android/iOS). Để cài dependency và chạy
kiểm thử:

```bash
flutter pub get
flutter analyze --no-fatal-infos
flutter test
flutter run
```

Trong buổi demo, hãy tự thêm vài sách ở các trạng thái khác nhau để hiển thị
thống kê và kiểm tra dữ liệu còn sau khi khởi động lại ứng dụng.
