# C06 · Đặc tả chức năng (Functional Specification)

Đặc tả **hành vi đúng** của khối, độc lập với cách hiện thực. Mọi mệnh đề dưới đây có thể
kiểm bằng mô phỏng hoặc bằng assertion, không phụ thuộc vào việc RTL được viết thế nào.

---

## 0. ⚠️ CẢNH BÁO ĐỐI CHIẾU RTL ↔ CHARTER

Đọc phần này **trước** khi dùng hồ sơ để chấm bài. Bốn điểm dưới đây là chênh lệch **có
thật** giữa RTL trong `04_IMPLEMENTATION/rtl/c06_core.sv` và Charter C06. RTL **không bị
sửa** — chênh lệch được ghi nhận, không được che.

| # | Nội dung Charter | Thực tế trong RTL | Phán xử |
|---|---|---|---|
| **W-1** | Charter mục 4: `uo_out[7:0]` = số lần vượt của cửa sổ trước (**8 bit**), `uio_out[0]` = xung kết thúc cửa sổ. Ngân sách 16 bit vào + 9 bit ra. | Module có **27 bit ra**: `window_count[7:0]`, `event_count[8:0]`, `result_count[8:0]`, `window_done`. Tên cổng cũng không theo `ui_in/uio_in/uo_out`. | **REQ-C06-002 CHƯA THOẢ.** RTL là *core* trần, chưa có lớp vỏ Tiny Tapeout. `window_count` và `event_count` là cổng **quan sát nội bộ** (debug), Charter không yêu cầu đưa ra ngoài. |
| **W-2** | Charter mục 8: “tất cả đều vượt (**kết quả 255**)”. | Cửa sổ dài **256** chu kỳ nên giá trị lớn nhất là **256**; RTL dùng `result_count[8:0]` (9 bit) và testbench khẳng định `result_count == 256` (`c06_core_tb.sv` dòng 68). | **Yêu cầu “kết quả 255” CHƯA THOẢ theo đúng chữ.** Đây gần như chắc chắn là lỗi số học trong Charter (256 mẫu → tối đa 256 lần vượt), nhưng **cần thầy chốt**: hoặc sửa Charter thành 256, hoặc yêu cầu bão hoà 8 bit tại 255. Hai phương án cho kết quả khác nhau ở đúng một điểm. |
| **W-3** | Charter mục 10, “dấu hiệu làm đúng”: 8 + 8 + 8 ≈ **24–26 ô nhớ**. | Đo được **27 flip-flop** (`06_GDSII/synthesis/synth_stat.txt`). | **Vượt ngưỡng 1 ô.** Nguyên nhân đã bóc tách đầy đủ ở §7 dưới đây — không phải lỗi thiết kế, mà là hệ quả trực tiếp của W-2 (9 bit thay vì 8 bit) cộng 1 FF cho `window_done`. |
| **W-4** | — | `02_SPECIFICATION/interface.md` §2 (file sinh tự động) có dòng “**Không có reset** — không có trạng thái để đặt lại”. | **Sai so với RTL.** RTL *có* `rst_n`, tích cực mức thấp, **đồng bộ**. Dòng đó là lỗi của bộ sinh tự động; bảng cổng ngay phía trên nó lại ghi đúng. Không sửa file sinh tự động, ghi nhận tại đây. |

Ngoài bốn điểm trên, hành vi đếm của RTL **khớp** với Charter mục 1 và mục 10 (kể cả cái
bẫy “chốt và xoá cùng một chu kỳ” — xem §5 và INV-5).

---

## 1. Phát biểu bài toán

Khối quan sát một dòng mẫu 8 bit không dấu, mỗi chu kỳ clock một mẫu. Cứ **256 chu kỳ liên
tiếp** hợp thành một **cửa sổ**. Cuối mỗi cửa sổ, khối chốt lại **số mẫu trong cửa sổ đó có
giá trị lớn hơn ngưỡng**, phát một xung báo cửa sổ kết thúc, rồi bắt đầu cửa sổ mới ngay
chu kỳ kế tiếp — **không có chu kỳ chết**.

Cửa sổ ở đây là cửa sổ **nhảy** (tumbling), không phải cửa sổ trượt: Charter mục 3 xếp cửa
sổ trượt vào phần **ngoài phạm vi**.

## 2. Định nghĩa toán học

Đặt `s[n]` là giá trị `sample_in` được lấy mẫu tại cạnh lên thứ `n` sau khi `rst_n` nhả
(`n = 1, 2, 3, …`), `T` là `threshold`.

**Hàm sự kiện (tổ hợp, không có ô nhớ):**

```
e[n] = 1  khi  s[n] >  T
e[n] = 0  khi  s[n] <= T
```

> **Quy ước biên được chốt:** dùng `>` chứ **không** phải `>=`. Mẫu **bằng đúng** ngưỡng
> **không** tính là vượt. Bằng chứng ba lớp trùng khớp: RTL `event_now = (sample_in > threshold)`;
> mô hình Python `sum(1 for x in samples if x > threshold)`; testbench khẳng định
> `result_count == 1` sau một cửa sổ có 255 mẫu bằng đúng 100 với `threshold = 100`
> (`c06_core_tb.sv` dòng 62–64).

**Kết quả cửa sổ thứ `w` (w = 1, 2, …):**

```
R[w] = Σ e[n]   với  n chạy từ 256·(w-1)+1  đến  256·w
```

Giá trị `R[w]` nằm trong `[0, 256]` — **257 giá trị khác nhau**, nên cần tối thiểu **9 bit**.
Đây là gốc rễ của W-2.

## 3. Đặc tả từng tín hiệu ra

| Tín hiệu | Định nghĩa chính xác | Loại |
|---|---|---|
| `window_count[7:0]` | Sau cạnh lên thứ `n`: `window_count = n mod 256`. Là **chỉ số vị trí** trong cửa sổ đang chạy, không phải dữ liệu người dùng. | Quan sát nội bộ |
| `event_count[8:0]` | Sau cạnh lên thứ `n`: số sự kiện đã tích luỹ **trong cửa sổ đang chạy**, tức `Σ e[k]` với `k` chạy từ đầu cửa sổ hiện tại tới `n`. Bị xoá về 0 tại cạnh kết thúc cửa sổ. | Quan sát nội bộ |
| `result_count[8:0]` | Giữ `R[w]` của **cửa sổ vừa hoàn tất**. Chỉ đổi giá trị tại cạnh kết thúc cửa sổ. Trước cửa sổ đầu tiên hoàn tất, giá trị là `0`. | **Đầu ra chính** (Charter: `uo_out`) |
| `window_done` | Bằng `1` **đúng một chu kỳ**, là chu kỳ ngay sau cạnh lên thứ `256·w`. Bằng `0` ở mọi chu kỳ khác. | **Xung báo hợp lệ** (Charter: `uio_out[0]`) |

**Hợp đồng đọc kết quả:** `result_count` hợp lệ **ngay trong chu kỳ `window_done = 1`** và
giữ nguyên cho tới xung `window_done` kế tiếp. Tầng ngoài có **256 chu kỳ** để đọc, nên
không cần bắt tay (handshake) — xem `03_ARCHITECTURE/control.md` §4.

## 4. Trạng thái sau reset

`rst_n` tích cực mức thấp, **đồng bộ** (được lấy mẫu tại cạnh lên của `clk`, không có nhánh
`posedge rst_n` trong `always_ff`).

| Tín hiệu | Giá trị sau cạnh lên đầu tiên có `rst_n = 0` |
|---|---:|
| `window_count` | `0` |
| `event_count` | `0` |
| `result_count` | `0` |
| `window_done` | `0` |

**Nghĩa vụ của tầng ngoài:** giữ `rst_n = 0` trong **ít nhất một cạnh lên đầy đủ** của
`clk`. Một cạnh là đủ vì mọi flip-flop đều nhận hằng số `0` trên đường `D` khi `rst_n = 0`
(xem `03_ARCHITECTURE/fsm.md` §5 về khử X lúc cấp nguồn).

## 5. Bảng chuyển trạng thái (mức hành vi)

Gọi `terminal = (window_count == 255)`.

| `rst_n` | `terminal` | `window_count` kế | `event_count` kế | `result_count` kế | `window_done` kế |
|:-:|:-:|---|---|---|:-:|
| 0 | × | `0` | `0` | `0` | `0` |
| 1 | 0 | `window_count + 1` | `event_count + e` | giữ nguyên | `0` |
| 1 | 1 | `0` | `0` | **`event_count + e`** | `1` |

> 🔑 **Điểm mấu chốt của cả đề.** Ở hàng cuối, `event_count` bị xoá về `0` **và** `result_count`
> nhận `event_count + e` — **trong cùng một cạnh clock**. Việc này đúng **chỉ vì** cả hai
> vế phải đều được tính từ giá trị **cũ** của `event_count` (ngữ nghĩa gán không chặn
> `<=`). Nếu lập trình viên dùng `=` (gán chặn) và viết `event_count = 0;` trước dòng
> `result_count = event_count + e;` thì kết quả mất toàn bộ số đếm. Đây chính là rủi ro
> Charter mục 10 nêu tên: *“Chốt và xoá cùng một chu kỳ, làm mất một lần đếm.”*

Lưu ý thứ hai, tinh tế hơn: mẫu của **chính chu kỳ kết thúc** (`n = 256·w`) **phải được
tính vào** `R[w]`. RTL làm đúng nhờ dùng `completed_count = event_count + event_now` thay
vì dùng thẳng `event_count`. Nếu viết `result_count <= event_count` thì mất đúng **một**
lần đếm — testbench phát hiện được nhờ ca “sự kiện tại chu kỳ 256” (xem `corner_cases.md`).

## 6. Độ trễ từ đầu vào tới đầu ra

| Quan hệ | Độ trễ |
|---|---|
| `sample_in` tại cạnh `n` → ảnh hưởng `event_count` | **1 chu kỳ** |
| Mẫu cuối cùng của cửa sổ (`n = 256·w`) → `result_count` hợp lệ | **1 chu kỳ** — không có chu kỳ chờ thêm |
| Cửa sổ `w` kết thúc → cửa sổ `w+1` bắt đầu | **0 chu kỳ** — `window_count` đã bằng `1` ngay ở cạnh kế tiếp |
| `threshold` đổi giá trị → ảnh hưởng kết quả | **Tức thì cho mẫu của chu kỳ đó** — xem §8 |

Thông lượng: **1 mẫu / chu kỳ, liên tục, không bao giờ nghỉ**. Không có tín hiệu
`ready`/`valid` phía vào, nên tầng ngoài **không được phép** giả định khối có thể bị chặn lại.

## 7. Tính chất bất biến (Invariants)

Dùng trực tiếp làm assertion SystemVerilog. Cột cuối ghi bằng chứng đã có trong hồ sơ.

| ID | Phát biểu | Bằng chứng hiện có |
|---|---|---|
| **INV-1** | `0 <= window_count <= 255` ở mọi chu kỳ. | Thanh ghi rộng đúng 8 bit — đúng theo cấu trúc. |
| **INV-2** | Sau reset, `window_count` tăng đúng 1 mỗi chu kỳ và quấn vòng tại 255 → 0. Không có tín hiệu nào dừng được nó. | RTL: nhánh `else` không có điều kiện enable nào. |
| **INV-3** | `event_count <= window_count` ở mọi chu kỳ. | Suy ra từ §5: mỗi chu kỳ `event_count` tăng nhiều nhất 1, `window_count` tăng đúng 1, cả hai cùng xoá. |
| **INV-4** | `window_done` bằng `1` đúng 1 trong mỗi 256 chu kỳ liên tiếp (sau cửa sổ đầu). | Testbench dòng 45–46 kiểm tại đúng chu kỳ 256. |
| **INV-5** | `result_count` **chỉ** đổi giá trị ở chu kỳ có `window_done = 1`. | RTL: phép gán `result_count <=` chỉ xuất hiện trong nhánh `terminal` và nhánh reset. |
| **INV-6** | `0 <= result_count <= 256`. | §2. Testbench dòng 68 chạm cận trên 256. |
| **INV-7** | **`event_count[8]` luôn bằng `0`.** | Chứng minh: trong một cửa sổ có đúng **255** cạnh không-kết-thúc (`window_count` = 0…254), mỗi cạnh cộng nhiều nhất 1, nên `event_count <= 255`; tại cạnh kết thúc nó bị xoá về 0. Giá trị 256 **chỉ** xuất hiện trên `completed_count` (dây tổ hợp) và đi thẳng vào `result_count`. |
| **INV-8** | Nếu `threshold = 255` thì `result_count = 0` mãi mãi, vì `sample_in > 255` là bất khả với 8 bit. | Suy ra từ §2. **Chưa có ca kiểm thử** — xem `corner_cases.md` TC-B3. |
| **INV-9** | Kết quả không phụ thuộc thứ tự mẫu, chỉ phụ thuộc tập mẫu trong cửa sổ (phép cộng giao hoán). | Mô hình Python dùng `sum(...)` trên list — đúng theo cấu trúc. |

> INV-7 là phát hiện đáng chú ý nhất về cấu trúc: hồ sơ trả tiền cho một flip-flop mà giá
> trị của nó **không bao giờ khác 0**. Xem §7 của `implementation-notes_C06.md`.

## 8. Điều kiện biên và hành vi KHÔNG xác định

| Tình huống | Hành vi | Trạng thái đặc tả |
|---|---|---|
| `sample_in == threshold` | **Không** tính là vượt (`>` chứ không `>=`). | ✅ Đã chốt, đã có ca kiểm thử |
| `threshold = 0` | Mọi mẫu `>= 1` đều tính; mẫu `0` không tính. | ✅ Xác định. ⬜ Chưa có ca kiểm thử |
| `threshold = 255` | `result_count` luôn `0` (INV-8). | ✅ Xác định. ⬜ Chưa có ca kiểm thử |
| **`threshold` thay đổi giữa cửa sổ** | Mỗi mẫu được so với giá trị `threshold` **tại đúng chu kỳ của mẫu đó**. Kết quả cửa sổ trở thành tổng của các phép so sánh với ngưỡng khác nhau — **về mặt thống kê là vô nghĩa**. | ⚠️ **Xác định về mặt logic nhưng vô nghĩa về mặt ứng dụng.** RTL không chốt `threshold`, không có cơ chế nào ngăn việc này. **Nghĩa vụ của tầng ngoài:** chỉ đổi `threshold` trong chu kỳ có `window_done = 1`. Đây là một hợp đồng **chưa được ghi ở đâu khác trong hồ sơ ngoài file này**. |
| `sample_in` hoặc `threshold` chứa `X`/`Z` | `event_now` thành `X` → lan vào `event_count`, hỏng cả cửa sổ. | ⚠️ Không xác định. Nghĩa vụ tầng ngoài (đã ghi ở `interface.md` §4). |
| Cạnh clock đầu tiên khi `rst_n` chưa từng xuống 0 | Ở mô phỏng hành vi: tất cả thanh ghi là `X`, `terminal` là `X` → toàn bộ máy vào `X`. | ⚠️ Không xác định. Bắt buộc phải có chuỗi reset. |
| Ngừng cấp `sample_in` (giữ nguyên giá trị cũ) | Khối **vẫn đếm** — nó không phân biệt được “mẫu mới” với “mẫu cũ giữ nguyên”. | ⚠️ **Rủi ro ứng dụng.** Không có tín hiệu `sample_valid`. Nếu tốc độ cảm biến chậm hơn `clk`, một sự kiện rung sẽ bị đếm nhiều lần. Xem `03_ARCHITECTURE/tradeoff.md` §4. |

## 9. Ràng buộc cấu trúc bắt buộc

Tên đề (“Bộ đếm số lần vượt ngưỡng trong cửa sổ 256 chu kỳ”) **không** chỉ định kiến trúc
cụ thể như “ripple-carry” hay “Booth”, nên RTL **không** bị bắt buộc phải mô tả tường minh
một cấu trúc nào. Tuy vậy, Charter mục 9 và mục 10 áp bốn ràng buộc cấu trúc đọc được:

| ID | Ràng buộc | Đo được | Trạng thái |
|---|---|---|:-:|
| S-1 | Phải có **hai** bộ đếm chạy song song (đếm vị trí cửa sổ, đếm sự kiện). | `window_count` 8 FF + `event_count` 9 FF, cả hai cập nhật mỗi chu kỳ. | ✅ |
| S-2 | Phải có **một thanh ghi chốt** kết quả tách rời bộ đếm sự kiện. | `result_count` 9 FF, `_190_`…`_198_` trong netlist. | ✅ |
| S-3 | Cửa sổ dài đúng 256 chu kỳ, kiểu nhảy, không có chu kỳ chết. | §6. | ✅ |
| S-4 | Tổng ô nhớ ≈ 24–26. | **27**. | ❌ CHƯA THOẢ — xem W-3 |

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
