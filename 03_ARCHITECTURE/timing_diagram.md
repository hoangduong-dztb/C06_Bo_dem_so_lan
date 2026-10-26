# C06 · Giản đồ thời gian (Timing Diagram)

---

## 0. Quy ước đọc giản đồ

C06 là mạch **tuần tự**, nên giản đồ dưới đây vẽ theo **chu kỳ clock**, không phải theo
đường lan truyền tổ hợp.

- **Cạnh `n`** = cạnh lên thứ `n` của `clk` sau khi `rst_n` nhả.
- Hàng có nhãn **“trước cạnh n”** = giá trị tổ hợp đang ổn định *ngay trước* cạnh đó — đây
  là giá trị mà flip-flop **thực sự lấy mẫu**.
- Hàng có nhãn **“sau cạnh n”** = giá trị `Q` của thanh ghi *sau* cạnh đó.
- `s[n]` = giá trị `sample_in` tại thời điểm cạnh `n`, đúng như testbench đặt trong
  `apply_cycle()` (gán `sample_in`, rồi `@(posedge clk)`).

> ⚠️ **Waveform này thu từ mô phỏng hành vi (zero-delay) của Icarus Verilog.** Mọi tín hiệu
> đổi giá trị **đúng tại** cạnh clock, không có `t_ckq`, không có độ trễ cổng, không có
> glitch. Nó chứng minh **thứ tự và số chu kỳ**, và **không** chứng minh bất cứ điều gì về
> độ trễ thật. Độ trễ thật nằm ở `06_GDSII/sta/timing_report_max.txt` (arrival 4,11 ns) và
> được bàn ở §4.

---

## 1. Giao dịch điển hình — một cửa sổ đầy đủ

Kịch bản lấy **đúng từ testbench** (`c06_core_tb.sv` dòng 36–59), `threshold = 100`, sự
kiện đặt tại cạnh **1**, **255** và **256** → kết quả cửa sổ phải bằng **3**.

```
 Cạnh số:        R1     R2  ║   1      2      3    ~~~   254    255    256  ║  257    258
 clk        ─────↑──────↑───╫───↑──────↑──────↑───~~~────↑──────↑──────↑────╫───↑──────↑───

 rst_n           0      0   ║   1      1      1   ~~~     1      1      1   ║   1      1
 s[n]            0      0   ║  101    100    100  ~~~    100    101    101  ║  101    100
 ──────────────────────────╫──────────────────────────────────────────────╫──────────────
 event_now                  ║
   (trước cạnh n)   0    0  ║   1      0      0   ~~~     0      1      1   ║   1      0
 window_count               ║
   (trước cạnh n)   X    0  ║   0      1      2   ~~~    253    254   ⟦255⟧ ║   0      1
 terminal                   ║
   (trước cạnh n)   X    0  ║   0      0      0   ~~~     0      0    ⟦ 1 ⟧ ║   0      0
 ──────────────────────────╫──────────────────────────────────────────────╫──────────────
 window_count               ║
   (sau cạnh n)     0    0  ║   1      2      3   ~~~    254    255     0   ║   1      2
 event_count                ║
   (sau cạnh n)     0    0  ║   1      1      1   ~~~     1      2      0   ║   1      1
 result_count               ║
   (sau cạnh n)     0    0  ║   0      0      0   ~~~     0      0   ⟦ 3 ⟧  ║   3      3
 window_done                ║                                        ┌───┐ ║
   (sau cạnh n)  ___0____0__║___0______0______0___~~~____0______0____│ 1 │_╫___0______0___
                            ║                                        └───┘ ║
                 └─ reset ─┘║└──────────── CỬA SỔ 1 (256 chu kỳ) ─────────┘║└─ CỬA SỔ 2 ─
```

**Đọc từng mốc:**

| Mốc | Xảy ra gì | Vì sao quan trọng |
|---|---|---|
| **R1, R2** | `rst_n = 0` nên cả 27 FF nhận `D = 0`. Sau R1 mọi thanh ghi đã bằng 0; R2 chỉ là dư an toàn | Trước R1, `window_count` là `X` ở gate-level. Một cạnh với `rst_n = 0` là đủ (xem `fsm.md` §6) |
| **Cạnh 1** | `s[1] = 101 > 100` → `event_now = 1`. `terminal = 0` nên đi nhánh thường: `wc: 0→1`, `ec: 0→1` | Kiểm **mép đầu** cửa sổ: sự kiện ở chu kỳ đầu tiên phải được tính vào cửa sổ 1 |
| **Cạnh 2…254** | `s = 100`, **bằng đúng** ngưỡng → `event_now = 0`. `ec` đứng yên ở 1, `wc` tăng đều | Kiểm quy ước biên `>` chứ không `>=` |
| **Cạnh 255** | `s = 101` → `event_now = 1`. `wc` trước cạnh là **254**, chưa phải 255 → vẫn là nhánh thường: `ec: 1→2`, `wc: 254→255` | Kiểm **mép kề cuối**: sự kiện ở chu kỳ 255 phải rơi vào cửa sổ này, không phải cửa sổ sau |
| **Cạnh 256** ⟦⟧ | `wc` trước cạnh = **255** → `terminal = 1`. `completed_count = ec(2) + event_now(1) = 3`. Cùng một cạnh: `result_count ← 3`, `ec ← 0`, `wc ← 0`, `window_done ← 1` | **Chu kỳ quan trọng nhất của cả đề.** Xem §2 |
| **Cạnh 257** | `window_done ← 0` (xung rộng đúng 1 chu kỳ). `result_count` giữ **3**. Cửa sổ 2 đã chạy: `wc: 0→1`, và `s[257] = 101` nên `ec: 0→1` | Kiểm **không có chu kỳ chết**: cửa sổ mới bắt đầu ngay, không nghỉ một nhịp nào |

## 2. Phóng to cạnh 256 — chốt và xoá trong cùng một cạnh

Đây chính là chỗ Charter mục 10 cảnh báo (*“Chốt và xoá cùng một chu kỳ, làm mất một lần
đếm”*). Phóng to quanh cạnh 256:

```
                    trước cạnh 256          │ cạnh 256 │        sau cạnh 256
   ─────────────────────────────────────────┼──────────┼──────────────────────────
   window_count (Q)          255            │    ↑     │            0
   event_count  (Q)            2            │    ↑     │            0
   s[256]                    101            │    ↑     │           (mới)
   event_now  (tổ hợp)         1            │    ↑     │
   terminal   (tổ hợp)         1            │    ↑     │
   completed_count (tổ hợp)  2 + 1 = 3  ════╪══╗ ↑     │
                                            │  ║ ↑     │
   result_count (Q)            0            │  ╚═↑════▶│            3
   window_done  (Q)            0            │    ↑     │            1
   ─────────────────────────────────────────┴──────────┴──────────────────────────

   Cả ba việc xảy ra ĐỒNG THỜI tại một cạnh:
     ① result_count ← completed_count   (giá trị CŨ của event_count + sự kiện của chính
                                         chu kỳ này)
     ② event_count  ← 0
     ③ window_count ← 0
```

**Vì sao ① và ② không đánh nhau?** Vì cả hai là **gán không chặn** (`<=`): mọi vế phải được
tính bằng giá trị **cũ** của thanh ghi, rồi mới đồng loạt cập nhật. Trên phần cứng, điều
này tương ứng với việc `completed_count` là dây tổ hợp nối từ `Q` của `event_count`, và nó
đi vào chân `D` của `result_count` — `Q` cũ vẫn còn đó cho tới khi cạnh clock xảy ra.

Nếu viết bằng gán chặn `=` thì mô phỏng sẽ cho `result_count = 0 + 1 = 1` thay vì 3 (mất 2
lần đếm), còn tổng hợp có thể cho kết quả khác — đúng kiểu lỗi “mô phỏng khác tổng hợp” mà
Charter D01 mục 10 cũng cảnh báo.

**Vì sao `completed_count` phải là `ec + event_now` chứ không phải `ec`?** Vì mẫu `s[256]`
là mẫu **thứ 256**, vẫn thuộc cửa sổ này. Nếu chốt thẳng `event_count`, giản đồ trên sẽ cho
`result_count = 2` thay vì 3 — mất **đúng một** lần đếm, và mất nó **chỉ khi** mẫu cuối
cửa sổ là sự kiện. Đó là loại lỗi chạy 99 % ca vẫn đúng.

## 3. Chu kỳ lặp lại dài hạn

```
  cạnh:   1 ... 256 │ 257 ... 512 │ 513 ... 768 │ ...
          └ cửa sổ 1┘ └ cửa sổ 2 ┘ └ cửa sổ 3 ┘

  window_done:      ▁▁▁▁█▁▁▁▁▁▁▁▁▁█▁▁▁▁▁▁▁▁▁▁█▁▁▁
                        ↑           ↑          ↑
                     cạnh 256    cạnh 512   cạnh 768
                     chu kỳ lặp = ĐÚNG 256, không phụ thuộc dữ liệu

  result_count:  0    │     R[1]    │    R[2]    │   R[3]
                      └─ giữ nguyên suốt 256 chu kỳ ─┘
```

Hệ quả cho tầng ngoài: **có 256 chu kỳ để đọc mỗi kết quả**, và nhịp `window_done` đều
tuyệt đối. Không cần FIFO, không cần bắt tay.

## 4. Giản đồ này chứng minh gì và **không** chứng minh gì

| Câu hỏi | Giản đồ hành vi trả lời được? | Muốn trả lời phải dùng gì |
|---|:-:|---|
| Cửa sổ có đúng 256 chu kỳ không? | ✅ | — |
| Sự kiện ở chu kỳ 256 có được tính không? | ✅ | — |
| `window_done` có rộng đúng 1 chu kỳ không? | ✅ | — |
| Có mất chu kỳ nào giữa hai cửa sổ không? | ✅ | — |
| `result_count` ổn định được bao lâu? | ✅ (256 chu kỳ) | — |
| **Dữ liệu có kịp tới trước cạnh clock không?** | ❌ | STA: arrival **4,11 ns** vs required **9,87 ns** → slack **5,76 ns** |
| **Chu kỳ clock nhỏ nhất dùng được là bao nhiêu?** | ❌ | STA sau routing, ở nhiều góc PVT. Số hiện có là **sau tổng hợp**, clock lý tưởng, chưa có ký sinh RC |
| Có glitch trên `event_now` không? | ❌ | Mô phỏng gate-level có SDF |
| `X` lúc cấp nguồn có bị xoá sạch không? | ❌ | Mô phỏng gate-level trên `netlist.v` |

**Nối hai thế giới với nhau.** Trong giản đồ hành vi, cạnh 256 là một điểm không có bề dày.
Trong thực tế, khoảng thời gian giữa cạnh 255 và cạnh 256 phải đủ dài để tín hiệu đi hết
đường `sample_in[0] → so sánh 8 bit → event_now → bộ tăng 9 bit → mux terminal →
result_count[8]`, tức **13 cell**, **4,11 ns** theo `timing_report_max.txt` (trong đó
1,00 ns là `set_input_delay` giả định, phần do mạch gây ra là 3,11 ns). Với chu kỳ giả định
10 ns và `library setup time` 0,13 ns, thời gian yêu cầu là 9,87 ns → còn dư **5,76 ns**.

Bốn giả định phải nêu kèm con số đó đã ghi ở `02_SPECIFICATION/timing.md` §3.

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
