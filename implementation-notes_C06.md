# C06 — Bộ đếm số lần vượt ngưỡng trong cửa sổ 256 chu kỳ · Ghi chú thực hiện

---

## 1. Bài toán này thực chất là gì

Bỏ hết vỏ ứng dụng đi, C06 là bài toán **nén dữ liệu có mất mát theo lô**: mỗi 256 chu kỳ
nó nhận 256 × 8 = 2048 bit và trả ra **9 bit**. Tỷ số nén 227:1. Cái quyết định chất lượng
khối không phải phép cộng — mà là **chọn đúng thông tin nào được giữ lại**.

Thông tin giữ lại ở đây là: *“có bao nhiêu mẫu trong lô vượt ngưỡng”*. Không giữ: mẫu nào,
lúc nào, vượt bao nhiêu, kéo dài bao lâu. Với bài toán giám sát rung máy công nghiệp
(Charter mục 1), lựa chọn đó hợp lý — người vận hành cần biết *máy rung mạnh bao nhiêu lần
trong giây vừa rồi*, không cần dạng sóng.

Vì tỷ số nén lớn, **mọi lỗi một đơn vị đều không thể phát hiện từ bên ngoài**. Nếu khối
đếm thiếu một lần trong 256, kết quả vẫn trông hợp lý. Đây là lý do đề này khó hơn vẻ
ngoài: nó không có cơ chế tự phát hiện sai, nên tính đúng phải được **chứng minh bằng cấu
trúc**, không phải bằng cảm giác “chạy thấy ổn”.

Hai ràng buộc làm bài toán có hình hài cụ thể:

- **Cửa sổ nhảy, không trượt** (Charter mục 3 loại cửa sổ trượt khỏi phạm vi). Khác biệt về
  chi phí là khổng lồ: cửa sổ trượt cần nhớ 256 mẫu (~2048 FF), cửa sổ nhảy chỉ cần nhớ
  **một con số** (9 FF).
- **Không có chu kỳ chết.** Cửa sổ `w+1` bắt đầu ngay ở chu kỳ sau khi cửa sổ `w` kết thúc.
  Ràng buộc này chính là nguồn gốc của mọi cái bẫy trong đề.

## 2. Bản chất kỹ thuật — cơ chế hoạt động

Khối gồm **hai dòng chảy độc lập gặp nhau đúng một lần mỗi 256 chu kỳ**:

- **Dòng thời gian** (`window_count`, 8 FF) đếm tự do 0→255→0. Nó **không nhìn dữ liệu một
  lần nào**. Giá trị của nó ở chu kỳ `n` luôn đúng bằng `n mod 256`.
- **Dòng dữ liệu** (`event_count`, 9 FF) tích luỹ số sự kiện.

Dòng thời gian sinh ra một tín hiệu điều khiển duy nhất — `terminal` — để đóng mở dòng dữ
liệu. Quan hệ là **một chiều tuyệt đối**: dữ liệu không bao giờ ảnh hưởng ngược lên thời
điểm chốt. Đây là tính chất kiến trúc đáng giá nhất của C06, vì nó cho ba bảo đảm miễn phí:
thời điểm `window_done` tiên đoán được tuyệt đối; không thể deadlock; và nếu một bit của
`window_count` bị lật thì máy vẫn tự phục hồi trong ≤ 256 chu kỳ (chỉ lệch pha cửa sổ, không
có trạng thái chết — xem `fsm.md` §5).

**Cơ chế then chốt nằm ở đúng một chu kỳ: chu kỳ kết thúc cửa sổ.** Ở chu kỳ đó, ba việc
phải xảy ra **đồng thời**: chốt kết quả, xoá bộ đếm sự kiện, xoá bộ đếm vị trí. Việc chốt
phải lấy giá trị **cũ** của bộ đếm **cộng thêm sự kiện của chính chu kỳ đó**. Nếu chốt giá
trị cũ mà quên cộng, mất đúng 1 lần đếm — và chỉ mất khi mẫu cuối cửa sổ tình cờ là sự
kiện, tức 99 % ca kiểm thử vẫn PASS. Nếu xoá trước rồi mới chốt, mất toàn bộ cửa sổ.

Điểm thứ hai, ít ai để ý: **cái đắt của C06 không phải bộ đếm, mà là bộ so sánh ngưỡng.**
Trên đường tới hạn thật, phép so sánh `sample_in > threshold` chiếm **2,45 ns trong 3,11 ns**
độ trễ logic — gấp năm lần phần cộng dồn. Lý do có tính nguyên lý: so sánh hai **biến** cần
carry lan nối tiếp qua 8 tầng (`abc` phải dùng 6 cell `maj3_1` nối tiếp, mỗi cái ~0,35 ns),
trong khi cộng với **hằng số** `+0/+1` biến carry thành hàm AND thuần, gom được thành cây
(`nor4_1` + `nand4_1`, chỉ 2 tầng). **Cộng với hằng số rẻ; so sánh hai biến đắt ngang cộng
hai biến.** Tên đề đánh lừa người đọc nhìn vào bộ đếm, trong khi nút thắt thật nằm ở phép
so sánh.

## 3. Đọc mã nguồn: RTL làm gì, từng dòng quan trọng

Toàn bộ thiết kế là **41 dòng**. Ba đoạn quan trọng nhất:

**(a) Ba dây tổ hợp — dòng 15–19:**

```systemverilog
always_comb begin
    event_now = (sample_in > threshold);
    terminal  = (window_count == 8'd255);
    completed_count = {1'b0, event_count} + {{8{1'b0}}, event_now};
end
```

`completed_count` là dây quan trọng nhất trong file. Nó được **mở rộng lên 9 bit trước khi
cộng** (`{1'b0, event_count}`), nên phép cộng không thể tràn. Và nó có **một nguồn, hai
đích** — chỗ tiết kiệm phần cứng chính của đề: một mạch cộng duy nhất phục vụ cả đường tích
luỹ lẫn đường chốt.

**(b) Chu kỳ kết thúc — dòng 30–34:**

```systemverilog
if (terminal) begin
    result_count <= completed_count;   // ① chốt (giá trị CŨ + sự kiện chu kỳ này)
    window_count <= 8'd0;              // ② xoá vị trí
    event_count  <= 9'd0;              // ③ xoá tích luỹ
    window_done  <= 1'b1;
end
```

Bốn phép gán **không chặn** (`<=`) nên mọi vế phải được tính từ giá trị **cũ**, rồi mới
đồng loạt cập nhật. Chính điều đó làm ① và ③ không đánh nhau dù cùng chạm `event_count`.
Nếu đổi sang `=`, kết quả sẽ là `0 + event_now` thay vì tổng cả cửa sổ. Đây đúng là cái bẫy
Charter mục 10 nêu tên.

**(c) Mẫu “gán mặc định” — dòng 28:**

```systemverilog
window_done <= 1'b0;                   // mặc định
if (terminal) begin … window_done <= 1'b1; end   // ghi đè
```

Hai phép gán tới cùng một tín hiệu trong cùng một khối `always_ff`: phép cuối thắng. Điều
này **không** sinh thêm phần cứng — trình tổng hợp rút gọn thành `window_done <= terminal`,
và netlist xác nhận: `_189_` nhận `D` thẳng từ mạng `terminal`. Mẫu code này đáng học vì nó
bảo đảm tín hiệu không bao giờ suy ra latch và không bao giờ dính `X`.

**Điều RTL *không* làm, cũng quan trọng ngang:** không chốt `threshold` (tầng ngoài phải
giữ ổn định); không có `sample_valid` (mỗi chu kỳ clock đều là một mẫu); không có bộ chia
tần (“256 chu kỳ” chỉ bằng “một giây” nếu `f_clk ≈ 256 Hz`).

## 4. Vì sao chọn kiến trúc này

Kiến trúc “hai bộ đếm + một thanh ghi chốt” được Charter mục 9 và mục 10 ấn định gián tiếp,
nhưng nó cũng là lựa chọn đúng nếu tự thiết kế lại:

| Quyết định | Lý do |
|---|---|
| Bộ đếm vị trí **tự do**, không có enable | Làm thời điểm chốt độc lập hoàn toàn với dữ liệu → tiên đoán được, không deadlock, tự phục hồi sau SEU |
| Bộ đếm **nhị phân** 8 bit làm biến trạng thái FSM | 256 trạng thái với 8 FF, **0 mã thừa**, không cần nhánh `default` chống treo. One-hot sẽ cần 256 FF |
| **Một** mạch cộng dùng chung hai đích | Tiết kiệm cả một bộ cộng 9 bit |
| Thanh ghi chốt **tách rời** bộ đếm sự kiện | Cho tầng ngoài **256 chu kỳ** để đọc thay vì 1 chu kỳ — không cần bắt tay, không cần FIFO |
| `terminal` so với **hằng số** 255, không so với thanh ghi | Mạch AND8 rẻ, và cửa sổ độ dài cố định đúng phạm vi Charter |

Cái giá: 9 FF cho thanh ghi chốt, tức **một phần ba** số flip-flop, trong một thiết kế mà
flip-flop chiếm **92,8 %** công suất. Đó là đánh đổi lớn nhất của đề và nó **đúng chỉ khi**
tầng ngoài không đọc được đúng nhịp — xem `tradeoff.md` §2, phương án P1.

## 5. Cách thực hiện — lộ trình 8 bước từ đặc tả tới GDSII

| Bước | Việc | Đầu ra | Trạng thái |
|:-:|---|---|:-:|
| 1 | Suy bảng hành vi và 9 invariant từ Charter mục 1 + 8 | `02_SPECIFICATION/functional_spec.md` | ✅ |
| 2 | Viết mô hình chuẩn **Python** trước, độc lập RTL | `reference_model.py` — PASS | ✅ |
| 3 | Viết RTL 41 dòng; chú ý gán không chặn ở chu kỳ chốt | `c06_core.sv` | ✅ |
| 4 | Viết testbench tự kiểm, tập trung vào biên cửa sổ (chu kỳ 1, 255, 256) | `c06_core_tb.sv` — **PASS** | ✅ |
| 5 | Tổng hợp sang sky130, đọc `synth_stat.txt`, **đối chiếu số FF với dự đoán** | 113 cell · 27 FF · 1012,2208 µm² | ✅ |
| 6 | Ràng buộc SDC (clock 10 ns, IO delay 1 ns — **giả định khởi điểm**), chạy STA | arrival 4,11 ns · slack 5,76 ns | ✅ |
| 7 | Ước lượng công suất, đọc tỷ lệ tuần tự / tổ hợp | 1,22e-04 W · seq 92,8 % | ✅ |
| 8 | P&R bằng LibreLane + PDK sky130A, rồi STA sau routing | — | ⬜ **CHƯA CHẠY** |

Bước 5 là bước dạy học quan trọng nhất: **dự đoán số flip-flop trước khi chạy Yosys**, rồi
so. Dự đoán 8 + 9 + 9 + 1 = 27, công cụ cho 27 — khớp tuyệt đối. Nếu lệch, hoặc bản thân
đọc RTL sai, hoặc có tín hiệu bị suy ra latch.

## 6. Số liệu thật đã đo được và cách đọc chúng

| Chỉ số | Giá trị | Công cụ |
|---|---:|---|
| Mô hình Python | PASS | CPython 3 |
| Mô phỏng RTL | **PASS** | Icarus Verilog 12.0 |
| Số cell | **113** | Yosys 0.33 |
| Flip-flop | **27** | Yosys 0.33 |
| Diện tích | **1012,2208 µm²** | Yosys 0.33 |
| Đường tới hạn | `sample_in[0]` → `_198_` (= `result_count[8]`), 13 cell | OpenSTA 3.1.0 |
| Data arrival | **4,11 ns** | OpenSTA 3.1.0 |
| Slack @ 10 ns | **5,76 ns** (MET) · WNS/TNS 0,00 | OpenSTA 3.1.0 |
| Công suất | **1,22e-04 W** · tuần tự 92,8 % · tổ hợp 7,2 % | OpenSTA 3.1.0 |

**Những số này CHỨNG MINH được:**
RTL tổng hợp được thành 113 standard cell sky130 thật; số ô nhớ đúng bằng 27 như đọc từ mã;
với ràng buộc giả định (10 ns, IO 1 ns, góc `tt_025C_1v80`, clock lý tưởng), đường dài nhất
tới hạn còn dư 5,76 ns; và testbench chạy hết không vi phạm assertion nào.

**Những số này KHÔNG chứng minh:**
(1) Không chứng minh tần số tối đa — chưa có ký sinh RC, chưa CTS nên `skew = 0`, và mới
**một** góc PVT. Góc `ss` sẽ chậm hơn đáng kể. (2) Không chứng minh diện tích cuối — 1012 µm²
là tổng diện tích cell, chưa kể hàng, chưa kể dây. (3) Không chứng minh thiết kế đúng —
chỉ chứng minh nó đúng **trên các ca đã viết**; `corner_cases.md` §5 liệt kê 8 ca còn
thiếu, trong đó ca “xen kẽ” và ca “kết quả 0” là **bắt buộc theo Charter mục 8**. (4) Con
số công suất dùng hoạt động **mặc định**, không phải VCD thật.

**Một chi tiết hay bị báo sai:** trong 4,11 ns arrival có **1,00 ns là `set_input_delay`**
— một giả định, không phải độ trễ của mạch. Phần do C06 gây ra chỉ **3,11 ns**.

## 7. Trả lời các câu hỏi kỹ thuật của Charter (mục 2)

**Câu 1 — Hai bộ đếm song song, mỗi bộ cần bao nhiêu bit?**

| Bộ đếm | Dải giá trị cần biểu diễn | Bit **cần** | Bit **RTL dùng** | Đo trong netlist |
|---|---|---:|---:|---:|
| Đếm vị trí cửa sổ | 0…255 (256 giá trị) | **8** | 8 | 8 (`_172_`…`_179_`) |
| Đếm sự kiện | 0…**255** (xem dưới) | **8** | **9** | 9 (`_180_`…`_188_`) |

Câu trả lời tinh tế nằm ở bộ đếm sự kiện. Trực giác nói “cửa sổ 256 mẫu → tối đa 256 →
cần 9 bit”. Nhưng đọc kỹ RTL: một cửa sổ chỉ có **255** cạnh đi vào nhánh không-kết-thúc
(`window_count` = 0…254); ở cạnh thứ 256 giá trị 256 **không bao giờ vào `event_count`**,
nó đi thẳng vào `result_count` qua dây tổ hợp `completed_count`. Vậy `event_count ≤ 255` và
**`event_count[8]` luôn bằng 0** (INV-7). 8 bit là đủ; RTL dùng 9 nên có **một flip-flop
chứng minh được là hằng số** — Yosys không gỡ được vì nó là cổng ra của module top.

**Câu 2 — Thời điểm chốt nằm ở đâu, vì sao chốt sai một chu kỳ là hỏng số liệu?**

Nằm ở đúng cạnh clock có `window_count == 255` (dòng 30). Ba kiểu sai một chu kỳ và hậu quả:

| Sai | Hậu quả | Ca phát hiện |
|---|---|---|
| Chốt `event_count` thay vì `event_count + event_now` | Mất **đúng 1** khi mẫu cuối là sự kiện | Sự kiện đặt tại chu kỳ 256 (testbench dòng 43) |
| Xoá trước, chốt sau (dùng `=`) | Mất **toàn bộ** cửa sổ | Cửa sổ có ≥ 2 sự kiện (testbench cửa sổ 1) |
| `terminal` đặt ở 254 hoặc 256 | Cửa sổ dài 255 hoặc 257; sự kiện rơi nhầm cửa sổ | Sự kiện ở **cả** 255 và 256 + kiểm cửa sổ kế (dòng 42–59) |

“Hỏng số liệu” ở đây rất cụ thể: vì khối nén 2048 bit xuống 9 bit, **không có cách nào phát
hiện lỗi từ giá trị đầu ra**. Một khối đếm thiếu 1 trong 256 vẫn cho kết quả trông hợp lý
mãi mãi.

**Câu 3 — Tổng ô nhớ dự đoán, báo cáo có khớp không?**

Dự đoán từ RTL: 8 + 9 + 9 + 1 = **27**. Đo được: `dfxtp_1 × 27`. **Khớp tuyệt đối.** Nhưng
**không khớp Charter mục 10** (“8+8+8 ≈ 24–26 ô nhớ”), vượt 1 ô. Hai nguyên nhân cộng lại:
`event_count` và `result_count` rộng 9 bit thay vì 8 (+2), còn `window_done` là một FF mà
ước lượng 8+8+8 của Charter bỏ quên (+1) — tổng 24 + 2 + 1 = 27.

## 8. Trả lời câu phân tích riêng (Charter mục 9)

> *“Thiết kế có hai bộ đếm và một thanh ghi chốt. Bóc tách xem mỗi phần chiếm bao nhiêu
> flip-flop, tổng cộng có khớp với 8+8+8 không.”*

Bóc tách bằng **tên instance thật trong `06_GDSII/synthesis/netlist.v`**, không phải ước lượng:

| Phần | Instance netlist | FF | Charter dự kiến | Chênh |
|---|---|---:|---:|---:|
| Bộ đếm vị trí cửa sổ (`window_count[7:0]`) | `_172_` … `_179_` | **8** | 8 | 0 |
| Bộ đếm sự kiện (`event_count[8:0]`) | `_180_` … `_188_` | **9** | 8 | **+1** |
| FF báo kết thúc (`window_done`) | `_189_` | **1** | 0 (bị bỏ quên) | **+1** |
| Thanh ghi chốt (`result_count[8:0]`) | `_190_` … `_198_` | **9** | 8 | **+1** |
| **TỔNG** | `dfxtp_1 × 27` | **27** | 24 | **+3** |

**Kết luận: KHÔNG khớp 8+8+8 = 24. Thực đo 27.** Ba ô chênh lệch được giải thích hết, không
còn ô nào không rõ nguồn gốc:

1. **+1 ở `result_count`** — *chính đáng*. Cửa sổ 256 mẫu nên kết quả tối đa là **256**, cần
   9 bit. Charter mục 8 ghi “kết quả 255” là nhầm lẫn số học: 256 mẫu cho 257 giá trị khả dĩ.
2. **+1 ở `window_done`** — *chính đáng*. Ước lượng 8+8+8 của Charter chỉ đếm ba thanh ghi
   dữ liệu, quên mất xung báo. Đăng ký `window_done` là quyết định đúng: nó làm xung sạch,
   không glitch, dùng được làm strobe cho tầng ngoài.
3. **+1 ở `event_count`** — **KHÔNG chính đáng, và đây là phát hiện đáng giá nhất của bài.**
   `event_count[8]` chứng minh được là luôn bằng 0 (INV-7). Nó tồn tại **chỉ vì**
   `event_count` được đưa ra cổng top làm tín hiệu quan sát; nếu nó là tín hiệu nội bộ,
   Yosys sẽ tự gỡ và số FF còn **26** — **lọt đúng vào dải 24–26 của Charter**.

Cách kiểm chứng phát biểu 3 mà không cần sửa RTL của thầy: thêm assertion
`assert(event_count[8] == 1'b0)` vào testbench (ca **TC-B5** trong `corner_cases.md` §5).
Nếu assertion này chạy hết mọi ca mà không vi phạm, INV-7 được xác nhận bằng mô phỏng.

**Bài học tổng quát:** *mọi tín hiệu gỡ lỗi đưa ra cổng top đều là một cam kết phần cứng*.
Trình tổng hợp không được phép tối ưu cổng ra của module top, kể cả khi chứng minh được nó
là hằng số.

## 9. Những chỗ sinh viên hay sai và cách phát hiện

| # | Sai lầm | Hậu quả | Phát hiện bằng bằng chứng nào |
|---|---|---|---|
| 1 | Dùng gán chặn `=` trong `always_ff` ở chu kỳ chốt | `result_count` chỉ bằng 0 hoặc 1, mất cả cửa sổ | Chạy cửa sổ có ≥ 2 sự kiện; testbench dòng 47 khẳng định `result_count == 3` → FAIL ngay |
| 2 | Chốt `event_count` thay vì `completed_count` | Mất đúng 1 khi mẫu cuối là sự kiện — **99 % ca vẫn PASS** | Phải có ca đặt sự kiện **đúng tại chu kỳ 256** (dòng 43). Không có ca này thì lỗi lọt |
| 3 | Đặt `terminal` tại `== 8'd256` | Bộ so sánh 8 bit **không bao giờ** đúng → `window_done` không bao giờ lên | Waveform: `window_done` phẳng 0 mãi. Hoặc netlist: mạch AND8 bị Yosys rút thành hằng `0` |
| 4 | Dùng `>=` thay `>` khi so ngưỡng | Đếm dư mọi mẫu bằng đúng ngưỡng | Testbench dòng 62–64: 255 mẫu bằng 100 với `threshold = 100` phải cho `result_count == 1` |
| 5 | Khai `result_count` chỉ 8 bit | Kết quả 256 quấn về 0 — *tệ nhất có thể*: “rung dữ dội” báo thành “không rung” | Ca 256 mẫu đều vượt (dòng 67–69) → FAIL |
| 6 | Quên xoá `event_count` ở chu kỳ chốt | Kết quả cộng dồn vô hạn qua các cửa sổ | Kiểm cửa sổ **thứ hai**, không chỉ cửa sổ đầu (dòng 56–59) |
| 7 | Quên gán một thanh ghi trong nhánh `if (!rst_n)` | Mô phỏng RTL vẫn PASS, nhưng gate-level giữ `X` vĩnh viễn | Mô phỏng netlist với mọi FF khởi tạo `X` (`corner_cases.md` §7, **chưa chạy**) |
| 8 | Tin rằng “256 chu kỳ = 1 giây” | Cửa sổ sai hàng nghìn lần nếu `f_clk` không phải ~256 Hz | Đọc RTL: không có bộ chia tần nào; 27 FF đã dùng hết cho ba thanh ghi đã biết |
| 9 | Đổi `threshold` giữa cửa sổ | Kết quả là tổng của các so sánh với ngưỡng khác nhau — vô nghĩa | Đọc RTL: `threshold` không được chốt ở đâu cả. Chưa có assertion nào bắt lỗi này |
| 10 | Báo “C06 chạy được ở 100 MHz” vì SDC ghi 10 ns | Phát biểu vượt mức | 10 ns là **giả định khởi điểm** (`timing.md` §3). Chưa CTS, chưa routing, một góc PVT |
| 11 | Báo độ trễ là 4,11 ns | Sai 32 % | 1,00 ns trong đó là `set_input_delay`; phần của mạch là 3,11 ns |

## 10. Câu hỏi mentor nên đặt khi bảo vệ

| # | Câu hỏi | Đáp án mong đợi |
|---|---|---|
| 1 | Cửa sổ dài 256 chu kỳ, vậy kết quả lớn nhất là 255 hay 256? | **256**. Testbench dòng 68 khẳng định `result_count == 256`. Charter mục 8 ghi 255 là nhầm số học; cần chốt lại với thầy |
| 2 | Chỉ ra dòng nào bảo đảm mẫu của chu kỳ 256 được tính vào cửa sổ đó | Dòng 31: `result_count <= completed_count`, mà `completed_count = event_count + event_now` (dòng 18). Nếu chốt thẳng `event_count` là mất 1 |
| 3 | Chốt và xoá `event_count` cùng một cạnh — vì sao không mất số liệu? | Gán **không chặn** `<=`: mọi vế phải tính từ giá trị cũ. Phần cứng: `completed_count` là dây tổ hợp từ `Q`, đi vào `D`; `Q` cũ còn nguyên tới lúc cạnh xảy ra |
| 4 | Bộ đếm sự kiện cần mấy bit? Vì sao RTL dùng 9? | Cần **8** — INV-7 chứng minh `event_count ≤ 255`. RTL dùng 9 nên có 1 FF hằng số 0, không gỡ được vì là cổng ra top |
| 5 | Tổng FF là 27 nhưng Charter nói 24–26. Bóc tách và phán xử | 8 + 9 + 1 + 9. +1 chính đáng (kết quả tới 256), +1 chính đáng (`window_done` bị Charter bỏ quên), +1 **không** chính đáng (`event_count[8]`) |
| 6 | Đường tới hạn đi qua đâu? Phần nào tốn nhất? | `sample_in[0]` → **bộ so sánh** (6 `maj3_1`, 2,45 ns) → `event_now` → **bộ tăng** (`nor4`+`nand4`+`xor2`, 0,46 ns) → mux → `result_count[8]`. So sánh tốn gấp 5 lần cộng |
| 7 | Vì sao so sánh đắt hơn cộng, dù cùng là chuỗi carry? | Cộng với **hằng số** `+0/+1` biến carry thành AND thuần → gom được thành cây (2 tầng). So sánh hai **biến** buộc carry nối tiếp 8 tầng `maj3` |
| 8 | C06 có FSM không? Mealy hay Moore? | **Có** — `window_count` là biến trạng thái, 256 trạng thái, mã hoá nhị phân đếm, 0 mã thừa. `window_done` là đầu ra **Moore đã đăng ký**: `D` của nó chỉ phụ thuộc trạng thái, không chạm `sample_in` |
| 9 | Nếu một bit của `window_count` bị lật do nhiễu thì sao? | Máy **tự phục hồi** trong ≤ 256 chu kỳ. Không có mã bất hợp lệ nên không thể treo. Hậu quả: lệch pha cửa sổ và một cửa sổ có độ dài sai |
| 10 | Charter mục 8 yêu cầu ca “xen kẽ”. Nó nằm ở đâu trong testbench? | **Không có.** Mô hình Python có mẫu `i % 7` nhưng không chạy qua RTL. Đây là ca bắt buộc còn thiếu (TC-B2) |
| 11 | Slack 5,76 ns có nghĩa là chạy được ở bao nhiêu MHz? | **Không kết luận được.** Chưa CTS (skew = 0), chưa routing (không ký sinh RC), một góc PVT. Cần STA sau routing ở nhiều góc |
| 12 | Nếu bỏ thanh ghi chốt thì được và mất gì? | Được: −9 FF trong 27, mà FF chiếm **92,8 %** công suất. Mất: cửa sổ đọc của tầng ngoài từ 256 chu kỳ xuống **1** chu kỳ |

## 11. Giới hạn: đã chứng minh được gì, chưa chứng minh được gì

**Đã chứng minh (có bằng chứng do chính lần chạy này sinh ra):**

1. Mô hình chuẩn Python độc lập chạy PASS (`python_reference_run.log`).
2. Mô phỏng RTL chạy hết testbench, không assertion nào vi phạm (`simulation.log`).
3. RTL tổng hợp được thành 113 standard cell sky130, trong đó **27** ô nhớ, diện tích
   **1012,2208 µm²** (`synth_stat.txt`).
4. Bóc tách 27 FF về đúng từng thanh ghi, khớp tên instance trong netlist (§8).
5. Đường tới hạn xác định được: `sample_in[0] → result_count[8]`, 13 cell, arrival 4,11 ns,
   slack 5,76 ns với ràng buộc giả định (`timing_report_max.txt`).
6. Tỷ lệ công suất tuần tự / tổ hợp = 92,8 % / 7,2 % (`power_report.txt`).

**Chưa chứng minh:**

1. **Chưa phủ hết Charter mục 8.** Thiếu ca “xen kẽ” và thiếu cửa sổ cho kết quả 0 — cả hai
   là ca **bắt buộc**. 8 ca bổ sung đã đề xuất ở `corner_cases.md` §5, chưa chạy.
2. **Lớp L1 chưa thực sự hoạt động.** `c06_reference.sv` tồn tại nhưng testbench không khởi
   tạo nó; không có đối chiếu tự động với mô hình độc lập.
3. **Chưa chạy gate-level.** Chưa chứng minh `X` lúc cấp nguồn bị xoá sạch, chưa có
   X-propagation check.
4. **Chưa chạy P&R.** Mọi số timing là **sau tổng hợp**, clock lý tưởng (skew = 0), không
   ký sinh RC, một góc PVT `tt_025C_1v80`. Độ trễ thật sau routing sẽ **lớn hơn** 4,11 ns.
5. **Không có phát biểu nào về tần số tối đa.**
6. **Chưa chứng minh khối phù hợp ứng dụng.** “256 chu kỳ” chỉ bằng “một giây” nếu tầng
   ngoài chọn `f_clk` phù hợp; và không có `sample_valid` nên mẫu giữ nguyên sẽ bị đếm lại.
7. **Chưa chạy DRC/LVS, chưa sinh GDSII.** Không có phát biểu nào về sign-off, tape-out,
   chế tạo hay đo sau chế tạo — Charter mục 3 xếp những việc đó ngoài phạm vi.

**Bốn điểm CHƯA THOẢ so với Charter** đã ghi đầy đủ ở đầu `02_SPECIFICATION/functional_spec.md`
(W-1 … W-4). RTL **không bị sửa** — mọi đề nghị sửa (đặc biệt đề nghị thu `event_count`
xuống 8 bit ở `tradeoff.md` §3) đều cần thầy duyệt trước.

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
