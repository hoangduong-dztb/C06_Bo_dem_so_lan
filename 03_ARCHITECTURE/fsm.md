# C06 · Máy trạng thái (FSM)

---

## 1. C06 có FSM không? — Có, nhưng ở dạng dễ bị bỏ sót

Trong `c06_core.sv` **không có** khối `case`, không có `typedef enum`, không có biến tên
`state`. Người đọc vội sẽ kết luận “không có FSM”. Kết luận đó **sai**.

Định nghĩa đúng: một FSM là bộ ba (tập trạng thái hữu hạn, hàm chuyển, hàm ra). Ở C06:

| Thành phần FSM | Hiện thân trong RTL | Bằng chứng |
|---|---|---|
| **Biến trạng thái** | `window_count[7:0]` | 8 FF, netlist `_172_`…`_179_` |
| **Tập trạng thái** | `{S0, S1, …, S255}` — đúng **256** trạng thái | Thanh ghi 8 bit, mọi mã đều hợp lệ |
| **Hàm chuyển** | `S_k → S_(k+1)` với k < 255; `S255 → S0` | dòng 30–36 |
| **Hàm ra** | `window_done`, và tín hiệu điều khiển `terminal` | dòng 17, 28, 34 |

Ba thanh ghi còn lại (`event_count`, `result_count`, `window_done`) **không** phải biến
trạng thái điều khiển — chúng là **thanh ghi datapath**, vì giá trị của chúng không ảnh
hưởng ngược lại hàm chuyển (xem `control.md` §4, quan hệ một chiều).

> Nói “FSM của C06 có 256 trạng thái” là đúng về hình thức nhưng chưa đủ sâu. Cách nói
> chính xác hơn: **C06 dùng một bộ đếm nhị phân làm FSM**, tức chọn **mã hoá trạng thái
> kiểu đếm** thay vì one-hot hay mã hoá tuỳ ý. Đây là lựa chọn kiến trúc, không phải sự
> vắng mặt của FSM.

## 2. Sơ đồ trạng thái

Không thể vẽ hết 256 nút, nên vẽ dạng nén — chỗ nào có hành vi đặc biệt thì vẽ rõ:

```
                    ┌─────────────── rst_n = 0 (đồng bộ, ưu tiên cao nhất) ──────────────┐
                    │                                                                     │
                    ▼                                                                     │
              ┌───────────┐  ┌───────────┐  ┌───────────┐          ┌─────────────┐        │
   ═══════▶   │    S0     │─▶│    S1     │─▶│    S2     │─▶ ... ─▶ │    S254     │ ───┐   │
   (sau reset)│ wc = 0    │  │ wc = 1    │  │ wc = 2    │          │ wc = 254    │    │   │
              └───────────┘  └───────────┘  └───────────┘          └─────────────┘    │   │
                    ▲                                                                  │   │
                    │                                              ┌─────────────┐     │   │
                    │                                              │    S255     │◀────┘   │
                    │                                              │ wc = 255    │         │
                    │                                              │ terminal=1  │         │
                    └──────────────────────────────────────────────┴─────────────┘         │
                                        vô điều kiện                      │                │
                                                                          └────────────────┘

   Nhãn trên MỌI cung:  điều kiện = "không có" (vô điều kiện, 1 chu kỳ mỗi bước)
   Đầu vào sample_in / threshold KHÔNG xuất hiện trên bất kỳ cung nào.
```

Đặc điểm đáng chú ý: **đồ thị trạng thái là một vòng tròn đơn, không có nhánh nào.** Không
có đầu vào nào của khối làm thay đổi đường đi. Đây là loại FSM đơn giản nhất có thể có, và
chính vì thế mà thời điểm chốt kết quả tuyệt đối tin cậy được.

## 3. Bảng chuyển trạng thái

Vì mọi cung đều vô điều kiện, bảng đầy đủ 256 hàng không mang thêm thông tin. Bảng dưới là
bảng đầy đủ **theo lớp tương đương**:

| Trạng thái hiện tại | Điều kiện | Trạng thái kế | `terminal` (ra tổ hợp) | `window_done` ở chu kỳ SAU |
|---|---|---|:-:|:-:|
| bất kỳ | `rst_n = 0` | `S0` | — | `0` |
| `S_k`, `0 ≤ k ≤ 254` | `rst_n = 1` | `S_(k+1)` | `0` | `0` |
| `S255` | `rst_n = 1` | `S0` | `1` | **`1`** |

Tác động kèm theo lên datapath (không phải trạng thái điều khiển, nhưng cùng cạnh clock):

| Trạng thái | `event_count` kế | `result_count` kế |
|---|---|---|
| `S_k`, k ≤ 254 | `event_count + event_now` | giữ nguyên |
| `S255` | `0` | `event_count + event_now` |

## 4. Mealy hay Moore — và bằng chứng

**`window_done` là đầu ra Moore, đã đăng ký (registered Moore).**

Chứng minh từ mã:

```systemverilog
// dòng 17
terminal = (window_count == 8'd255);   // chỉ phụ thuộc TRẠNG THÁI
// dòng 28 + 34
window_done <= 1'b0;
if (terminal) window_done <= 1'b1;     // D của FF = terminal, không có sample_in
```

`D` của flip-flop `window_done` là hàm **chỉ của `window_count`**, không có `sample_in`,
không có `threshold`. Bằng chứng trong netlist: `_189_` (`Q = window_done`) lấy `D` từ mạng
`terminal`, và `sample_in` không nằm trên đường đó — trong khi `sample_in[0]` **có** nằm
trên đường tới hạn dẫn vào `_198_` (`result_count[8]`).

Hệ quả thực tế của việc chọn Moore:

| Tính chất | Vì là Moore |
|---|---|
| `window_done` **không bao giờ có glitch do dữ liệu** | Nó là Q của FF, và D của nó không chạm dữ liệu |
| Có thể dùng `window_done` làm clock-enable hoặc strobe cho tầng ngoài | Xung sạch, rộng đúng 1 chu kỳ |
| Trả giá: `window_done` trễ 1 chu kỳ so với `terminal` | Nhưng **đúng ý muốn** — nó phải xuất hiện *cùng lúc* với `result_count` mới, mà `result_count` cũng là Q của FF |

Ngược lại, `result_count` phụ thuộc **cả trạng thái lẫn đầu vào** (`event_now` của chu kỳ
kết thúc). Nhưng `result_count` là dữ liệu, không phải đầu ra của FSM — gọi nó là “đầu ra
Mealy” sẽ làm rối khái niệm. Cách phát biểu đúng: *FSM điều khiển của C06 là Moore thuần;
datapath do nó điều khiển thì có phụ thuộc dữ liệu.*

## 5. Mã hoá trạng thái và trạng thái bất hợp lệ

| Câu hỏi | Trả lời cho C06 |
|---|---|
| Kiểu mã hoá | **Nhị phân liên tiếp (binary / counter encoding)** — `S_k` mã là `k` |
| Số bit | 8 (log₂ 256) |
| Số mã dùng | **256 / 256 = 100 %** |
| **Có trạng thái bất hợp lệ không?** | **KHÔNG có mã nào thừa.** Đây là trường hợp hiếm và rất đáng nêu: mọi tổ hợp bit của thanh ghi trạng thái đều là trạng thái hợp lệ |
| Nếu một bit bị lật (SEU, nhiễu, X) thì sao? | FSM **tự phục hồi**: từ mã bất kỳ `k`, nó vẫn đếm lên và chắc chắn gặp `S255` trong tối đa 256 chu kỳ. Hậu quả duy nhất là **pha cửa sổ bị dịch** và **một cửa sổ có độ dài sai** |
| Có cần nhánh `default` chống treo không? | **Không.** Không có mã chết, nên không có khả năng FSM kẹt vĩnh viễn |

So sánh để thấy rõ giá trị của lựa chọn này:

| Mã hoá | Số FF cho 256 trạng thái | Mã thừa | Cần `default`? | Logic kế tiếp |
|---|---:|---|:-:|---|
| **Nhị phân đếm (C06 dùng)** | **8** | 0 | Không | Bộ tăng 8 bit — rất rẻ |
| Nhị phân tuỳ ý | 8 | 0 | Không | Bảng chuyển 256 hàng — rất đắt |
| One-hot | 256 | 2²⁵⁶−256 | **Bắt buộc** | Dịch vòng 1 bit — rẻ nhưng 256 FF |
| Gray | 8 | 0 | Không | Phức tạp hơn `+1`, chỉ có lợi khi trạng thái phải đi qua miền clock khác |

## 6. Khử `X` lúc cấp nguồn — vấn đề chỉ hiện ra ở gate-level

Netlist dùng `sky130_fd_sc_hd__dfxtp_1`, flip-flop **không có chân reset** (chỉ `CLK/D/Q`).
Lúc cấp nguồn, cả 27 FF là `X`, nên `window_count = X` và `terminal = X`.

Câu hỏi đúng cần đặt: *một cạnh clock với `rst_n = 0` có đủ xoá hết `X` không?* Câu trả lời
là **có**, và lập luận phải dựa vào cấu trúc chứ không dựa vào cảm giác: khi `rst_n = 0`,
RTL gán **hằng số** cho cả bốn thanh ghi (dòng 23–26), nên trình tổng hợp đặt `rst_n` làm
cổng chặn trên đường `D` của **mọi** FF. `D` khi đó là hằng `0`, hoàn toàn độc lập với giá
trị `X` đang nằm trong FF. Sau một cạnh lên, `Q = 0` cho cả 27 FF.

Điều kiện để lập luận trên còn đúng: **mọi** thanh ghi phải được gán trong nhánh reset.
Nếu ai đó thêm một thanh ghi mới mà quên gán nó trong nhánh `if (!rst_n)`, thanh ghi đó sẽ
giữ `X` vĩnh viễn ở gate-level trong khi mô phỏng RTL vẫn PASS. Ca kiểm tra tương ứng đã
được ghi ở `corner_cases.md` §7 (**chưa chạy**).

## 7. Khi nào C06 sẽ cần một FSM viết tay thật sự

FSM dạng bộ đếm đủ dùng vì bài toán C06 **không có nhánh**. Ba mở rộng sau sẽ buộc phải
viết FSM tường minh:

| Mở rộng | FSM cần có | Trong phạm vi? |
|---|---|---|
| Bắt tay đọc kết quả (`result_ack`) | Thêm trạng thái `WAIT_ACK`, và `S255 → WAIT_ACK → S0` có điều kiện | Không bị Charter cấm, nhưng làm đổi giao diện |
| Cửa sổ độ dài cấu hình được | Cần `IDLE / LOAD_LEN / RUN` | ❌ Charter mục 3: **ngoài phạm vi** |
| Cửa sổ trượt | Cần điều khiển bộ đệm vòng → FSM nhiều nhánh | ❌ Charter mục 3: **ngoài phạm vi** |
| Nạp `threshold` hai nhịp để vừa 24 chân Tiny Tapeout | Cần `LOAD_LOW / LOAD_HIGH / RUN` | 🟡 Điểm mở — Charter mục 4 yêu cầu hỏi giảng viên |

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
