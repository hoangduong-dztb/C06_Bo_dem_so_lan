# C06 · Phần điều khiển (Control)

---

## 1. C06 **có** phần điều khiển — và nó chỉ gồm đúng một tín hiệu

C06 là mạch tuần tự, nên câu hỏi “điều khiển nằm ở đâu” có câu trả lời thật, không phải
“không áp dụng”. Nhưng phần điều khiển ở đây **nhỏ tới mức bất thường**: toàn bộ logic
quyết định của khối nằm trong **một dây 1 bit** tên `terminal`, sinh ra ở dòng 17 của RTL:

```systemverilog
terminal = (window_count == 8'd255);
```

Không có FSM viết tay, không có `enable`, không có `start`, không có bắt tay. Bù lại, phần
điều khiển đó điều khiển **rất nhiều**: `terminal` là chân chọn của một multiplexer rộng
27 bit đặt trước đầu vào `D` của **toàn bộ** flip-flop trong thiết kế.

## 2. Bảng tín hiệu điều khiển và tác dụng

| Tín hiệu | Nguồn | Là loại gì | Điều khiển cái gì | Dòng RTL |
|---|---|---|---|---|
| `rst_n` | cổng vào | Điều khiển **ngoài**, ưu tiên cao nhất | Ép cả 27 FF về 0. Đồng bộ — được lấy mẫu như một tín hiệu dữ liệu | 22 |
| `terminal` | nội bộ, từ `window_count` | Điều khiển **trong**, sinh bởi dòng thời gian | Chọn giữa “cộng dồn tiếp” và “chốt & xoá” cho cả 3 thanh ghi dữ liệu; đồng thời là `D` của `window_done` | 17, 30 |
| `event_now` | nội bộ, từ `sample_in` & `threshold` | **Dữ liệu**, không phải điều khiển | Là số hạng `+0/+1` của bộ tăng. Nó **không** chọn nhánh nào | 16, 18 |
| `window_done` | thanh ghi | Điều khiển **cho tầng ngoài** | Báo “`result_count` vừa được cập nhật”. C06 không tự dùng tín hiệu này | 26, 28, 34 |

Phân biệt `terminal` với `event_now` là điểm dễ nhầm nhất: cả hai đều là dây 1 bit sinh từ
một phép so sánh. Nhưng `terminal` đi vào **chân chọn** của mux (nó quyết định *mạch làm
gì*), còn `event_now` đi vào **đường dữ liệu** của bộ cộng (nó quyết định *giá trị là bao
nhiêu*). Trên STA, khác biệt này hiện ra rõ: `terminal` tới đích qua 1 cell `o21ai_0`
(`_171_`), còn `event_now` phải kéo theo cả chuỗi so sánh 2,45 ns.

## 3. Bảng ưu tiên — chỉ có hai mức

| Ưu tiên | Điều kiện | Hành động | Rủi ro nếu viết sai |
|:-:|---|---|---|
| 1 | `rst_n == 0` | Cả 4 thanh ghi ← 0 | Nếu đặt `terminal` lên trước `rst_n`, reset sẽ không xoá được `result_count` khi reset rơi trúng chu kỳ kết thúc |
| 2 | `rst_n == 1 && terminal == 1` | Chốt `completed_count` vào `result_count`; xoá hai bộ đếm; `window_done ← 1` | Đây là chu kỳ duy nhất có hành vi đặc biệt |
| 3 | `rst_n == 1 && terminal == 0` | Hai bộ đếm tăng; `result_count` giữ; `window_done ← 0` | — |

So với D01 (Charter D01 mục 10 cảnh báo về ưu tiên nạp/xoá/đếm không rõ ràng), C06 **không
có rủi ro ưu tiên**: chỉ có hai nhánh lồng nhau, viết bằng `if/else` tường minh trong một
khối `always_ff` duy nhất, nên mô phỏng và tổng hợp không thể hiểu khác nhau.

## 4. Quan hệ điều khiển ↔ datapath

```
          ┌──────────────── DÒNG THỜI GIAN (điều khiển) ────────────────┐
          │  window_count ──▶ [ ==255 ] ──▶ terminal                     │
          │       ▲                            │                         │
          │       └──────── +1 / ←0 ───────────┘                         │
          └────────────────────────────────────┼─────────────────────────┘
                                                │ chân chọn
          ┌────────────────────────────────────▼─────────────────────────┐
          │           DÒNG DỮ LIỆU (datapath)   MUX 27 bit               │
          │  event_count ─▶[+event_now]─▶ completed_count ─┬─▶ event_count│
          │                                                └─▶ result_count│
          └───────────────────────────────────────────────────────────────┘

  Quan hệ MỘT CHIỀU:  điều khiển ──▶ datapath.
  Datapath KHÔNG BAO GIỜ ảnh hưởng ngược lại điều khiển.
```

Tính một chiều này là tính chất kiến trúc đáng giá nhất của C06 và nên được nêu khi bảo vệ:

1. **Thời điểm chốt hoàn toàn tiên đoán được.** `window_done` xuất hiện đúng mỗi 256 chu
   kỳ, bất kể dữ liệu là gì. Tầng ngoài có thể đếm nhịp thay vì phải chờ tín hiệu.
2. **Không có khả năng treo (deadlock).** Không có vòng lặp nào mà dữ liệu chặn điều khiển.
3. **Tự phục hồi sau nhiễu.** Nếu một bit của `window_count` bị lật (SEU, glitch), bộ đếm
   vẫn tiếp tục tăng và vẫn gặp 255 trong vòng tối đa 256 chu kỳ — chỉ **pha** cửa sổ bị
   lệch, không có trạng thái chết. Xem `fsm.md` §4.
4. Ngược lại: **không thể tạm dừng khối.** Không có `enable`. Muốn dừng phải gate clock ở
   tầng ngoài, và làm vậy sẽ kéo theo rủi ro glitch trên clock.

## 5. Nghĩa vụ hợp đồng của tầng ngoài

| Nghĩa vụ | Vì sao | Hậu quả nếu vi phạm |
|---|---|---|
| Giữ `rst_n = 0` qua ít nhất một cạnh lên đầy đủ | Netlist dùng `dfxtp_1` không có chân reset; `X` lúc cấp nguồn chỉ bị xoá bởi cạnh clock | Toàn bộ máy chạy với giá trị `X`/ngẫu nhiên; `terminal` sai → cửa sổ sai |
| Giữ `threshold` **không đổi trong suốt một cửa sổ**; chỉ đổi ở chu kỳ `window_done = 1` | RTL không chốt `threshold` | Kết quả là tổng của các phép so sánh với ngưỡng khác nhau — vô nghĩa về mặt thống kê |
| Cấp một mẫu mới mỗi chu kỳ, hoặc chấp nhận mẫu cũ bị đếm lại | Không có `sample_valid` | Một sự kiện rung kéo dài bị đếm thành nhiều sự kiện |
| Đọc `result_count` trong vòng 256 chu kỳ sau `window_done` | Sau đó nó bị ghi đè | Mất một điểm dữ liệu |
| Chọn `f_clk` sao cho 256 chu kỳ đúng bằng khoảng thời gian thống kê mong muốn | C06 không có bộ chia tần | “Mỗi giây” của Charter không còn đúng — xem `system_diagram.md` §3 |
| Bảo đảm `sample_in`, `threshold` đồng bộ với `clk`, không có `X`/`Z` | C06 không có bộ đồng bộ | Metastability lan vào `event_count`, hỏng cả cửa sổ |

## 6. Cái mà phần điều khiển này **không** làm

| Cơ chế | Có? | Nếu cần thì phải thêm gì |
|---|:-:|---|
| Bắt tay `valid`/`ready` phía vào | ❌ | 1 cổng vào + logic gate `window_count` và `event_count` |
| Bắt tay phía ra (giữ kết quả tới khi được đọc) | ❌ | 1 cổng vào `result_ack` + 1 FF trạng thái “chờ đọc” |
| Tạm dừng / `enable` toàn khối | ❌ | 1 cổng vào + gate cả 27 đường D |
| Cửa sổ độ dài cấu hình được | ❌ | 1 cổng vào 8 bit + đổi `==255` thành `==window_len`. **Charter mục 3: ngoài phạm vi** |
| Bão hoà kết quả tại 255 | ❌ | 1 cổng OR trên đường chốt. Sẽ làm `result_count` vừa 8 bit — xem `functional_spec.md` W-2 |
| Cờ báo tràn (đã có cửa sổ nào đạt 256) | ❌ | 1 FF. Hiện `result_count[8]` **chính là** cờ đó, chỉ là chưa được gọi tên như vậy |

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
