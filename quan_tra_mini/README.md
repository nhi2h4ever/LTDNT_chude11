# Quán trà mini — Demo Chủ đề 11: Chia sẻ trạng thái giữa các widget

Thực đơn 3 món, huy hiệu giỏ hàng và thanh tổng tiền cùng dùng một giỏ hàng.
Hai tab có giao diện giống nhau, chỉ khác cách đưa giỏ hàng đến các widget:

| Tab | Cách | File |
|---|---|---|
| Cách 1 | Giỏ hàng trong `_ShopPageV1State`, truyền qua constructor và callback | `lib/pages/cach1_truyen_tham_so.dart` |
| Cách 2 | `CartModel` (ChangeNotifier) đưa xuống cây bằng `CartScope` (InheritedNotifier) | `lib/pages/cach2_chia_se_trang_thai.dart` |

Mỗi widget hiện **build #n**: số lần hàm `build()` của widget đó đã chạy.

## Chạy

```bash
export PATH="$HOME/development/flutter/bin:$PATH"
flutter run -d chrome
flutter test --platform chrome
```

`flutter analyze` lỗi khi đường dẫn có chữ "Đ", nên chép project sang thư mục tên không dấu rồi chạy.

## Kết quả (13/11/2026)

- Cách 1, bấm + một lần: cả 7 widget build lại.
- Cách 2, bấm + một lần: 5 widget build lại (3 thẻ món, huy hiệu, thanh tổng); trang và Thực đơn giữ `#1`.
- Cách 2, bấm Xóa giỏ: 5 widget build lại, mọi số lượng về 0.

Ảnh chụp trong `screenshots/`.
