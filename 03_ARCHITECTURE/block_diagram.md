# C06 · Sơ đồ khối bên trong (Block Diagram)

Sơ đồ dưới đây vẽ theo **đúng 41 dòng** của `04_IMPLEMENTATION/rtl/c06_core.sv`, không phải
theo hình dung. Mỗi khối con đều chỉ được tới dòng RTL sinh ra nó.

---

## 1. Sơ đồ ASCII

```
                    ┌─── PHẦN TỔ HỢP (always_comb, dòng 15–19) ───────────────┐
                    │                                                          │
  sample_in[7:0] ══▶│  ┌────────────────────┐                                  │
                    │  │  SO SÁNH 8 BIT     │                                  │
  threshold[7:0] ══▶│  │  sample_in > thresh │──── event_now ───┐              │
                    │  │  (dòng 16)          │      (1 bit)     │              │
                    │  └────────────────────┘                   │              │
                    │       ▲ 6 cell maj3_1 trên đường tới hạn  │              │
                    │                                            ▼              │
                    │                               ┌──────────────────────┐   │
                    │   event_count[8:0] ══════════▶│  CỘNG 9 BIT + 1      │   │
                    │        (từ thanh ghi)         │  completed_count =   │   │
                    │                               │  event_count+event_now│  │
                    │                               │  (dòng 18)            │  │
                    │                               └──────────┬───────────┘   │
                    │                                          ║ 9 bit          │
                    │  ┌────────────────────┐                  ║               │
                    │  │  PHÁT HIỆN CUỐI    │                  ║               │
  window_count[7:0]─┼─▶│  window_count==255 │── terminal ──┐   ║               │
       (từ thanh ghi)│  │  (dòng 17) = AND8  │    (1 bit)  │   ║               │
                    │  └────────────────────┘              │   ║               │
                    └──────────────────────────────────────┼───╫───────────────┘
                                                            │   ║
       rst_n ───────────────────────────────┐               │   ║
                                            │               │   ║
  ┌─── PHẦN TUẦN TỰ (always_ff, dòng 21–40) ▼───────────────▼───╫──────────────┐
  │                                                              ║              │
  │   ┌──────────────────────────────────────────────┐           ║              │
  │   │ BỘ ĐẾM VỊ TRÍ CỬA SỔ   ·  8 FF               │           ║              │
  │   │ terminal ? 0 : window_count+1   (dòng 32,36) │═══════════╪══▶ window_count[7:0]
  │   │ netlist: _172_ … _179_                        │           ║              │
  │   └──────────────────────────────────────────────┘           ║              │
  │                                                               ║              │
  │   ┌──────────────────────────────────────────────┐           ║              │
  │   │ BỘ ĐẾM SỰ KIỆN         ·  9 FF               │◀══════════╣              │
  │   │ terminal ? 0 : completed_count  (dòng 33,37) │═══════════╪══▶ event_count[8:0]
  │   │ netlist: _180_ … _188_                        │           ║              │
  │   │ ⚠ bit [8] chứng minh được luôn = 0 (INV-7)   │           ║              │
  │   └──────────────────────────────────────────────┘           ║              │
  │                                                               ║              │
  │   ┌──────────────────────────────────────────────┐           ║              │
  │   │ THANH GHI CHỐT KẾT QUẢ ·  9 FF               │◀══════════╝              │
  │   │ terminal ? completed_count : giữ  (dòng 31)  │══════════════▶ result_count[8:0]
  │   │ netlist: _190_ … _198_                        │                          │
  │   │ ⚠ _198_ = result_count[8] = ENDPOINT tới hạn │                          │
  │   └──────────────────────────────────────────────┘                          │
  │                                                                              │
  │   ┌──────────────────────────────────────────────┐                          │
  │   │ FF BÁO KẾT THÚC        ·  1 FF               │──────────────▶ window_done│
  │   │ nhận thẳng `terminal`  (dòng 28,34)          │                          │
  │   │ netlist: _189_                                │                          │
  │   └──────────────────────────────────────────────┘                          │
  │                                                                              │
  │   Tổng ô nhớ:  8 + 9 + 9 + 1 = 27   ✓ khớp synth_stat.txt (dfxtp_1 × 27)    │
  └──────────────────────────────────────────────────────────────────────────────┘
```

Điểm đáng chú ý khi đọc sơ đồ: **`completed_count` chỉ có một nguồn nhưng có hai đích** —
nó đi vào bộ đếm sự kiện (ở chu kỳ thường) **và** vào thanh ghi chốt (ở chu kỳ kết thúc).
Chính việc tái sử dụng một mạch cộng duy nhất cho hai đích là lý do đề này rẻ: không có bộ
cộng thứ hai.

## 2. Ánh xạ cấu trúc RTL → phần cứng sinh ra

| Dòng RTL | Cấu trúc SystemVerilog | Phần cứng sinh ra | Bằng chứng trong netlist |
|---|---|---|---|
| 16 | `event_now = (sample_in > threshold)` | Bộ so sánh 8 bit không dấu = phép trừ có mượn, chuỗi carry 8 tầng | 6 × `maj3_1` (`_119_`…`_124_`) trên đường tới hạn — `maj3` chính là hàm carry `maj(a,b,cin)` |
| 17 | `terminal = (window_count == 8'd255)` | AND 8 đầu vào | `nand4_1` + `nor4_1` + `o2111ai_1` xuất hiện trên đường tới hạn, đúng kiểu cây AND8 bị `abc` chia lại |
| 18 | `completed_count = {1'b0,event_count} + {…,event_now}` | Bộ **tăng có điều kiện** 9 bit (increment by 0 or 1), không phải bộ cộng đầy đủ | Chuỗi `xnor2_1` (7 cái) sinh bit tổng + `nand4`/`nor4`/`nor3` làm cây AND của carry |
| 21 | `always_ff @(posedge clk)` | 27 flip-flop kích cạnh lên | `dfxtp_1 × 27` |
| 22 | `if (!rst_n)` (không có `posedge rst_n`) | Reset **đồng bộ**: `rst_n` đi vào cửa tổ hợp trên đường `D`, **không** vào chân reset của FF | `dfxtp_1` chỉ có 3 chân `CLK/D/Q` — thư viện có `dfrtp_1` với chân `RESET_B` nhưng Yosys **không** chọn nó |
| 30 | `if (terminal)` | Một multiplexer 2→1 **trên đầu vào D của cả 27 FF** | `o21ai_0 × 10` và `a21oi_1 × 3` — dạng mux gộp vào cổng phức |
| 28 + 34 | Gán `window_done <= 0` rồi có thể ghi đè `<= 1` | Không sinh ra logic ưu tiên nào cả: trình tổng hợp rút gọn thành `window_done <= terminal` | `_189_` nhận `D` trực tiếp từ mạng `terminal` |
| 31 vs 37 | Cùng biểu thức `completed_count` dùng ở hai nhánh | **Một** mạch cộng được chia sẻ, không nhân đôi | Tổng cell chỉ 113 — nếu có hai bộ cộng 9 bit thì phải nhiều hơn đáng kể |

> 🔎 **Bài học về dòng 28 và 34.** Viết `window_done <= 1'b0;` rồi sau đó viết đè
> `window_done <= 1'b1;` trong cùng một khối `always_ff` là hợp lệ và **không** sinh thêm
> phần cứng — quy tắc “phép gán không chặn cuối cùng thắng”. Đây là mẫu code (“default
> assignment”) rất tốt vì nó bảo đảm `window_done` **không bao giờ** suy ra latch và không
> bao giờ dính `X`. Sinh viên hay tưởng nó tạo ra hai flip-flop hoặc một mạch ưu tiên.

## 3. Khối con nào nằm trên đường tới hạn

Đối chiếu trực tiếp với `06_GDSII/sta/timing_report_max.txt` (13 cell,
`sample_in[0] → _198_`, arrival 4,11 ns, slack 5,76 ns):

| Thứ tự | Instance | Cell | Thuộc khối con nào | Delay tích luỹ |
|---:|---|---|---|---:|
| — | `sample_in[0]` | cổng vào | — | 1,00 ns *(là `set_input_delay` giả định, không phải logic)* |
| 1 | `_118_` | `lpflow_isobufsrc_1` | đệm đầu vào | 1,11 ns |
| 2–7 | `_119_`…`_124_` | `maj3_1` × 6 | **BỘ SO SÁNH 8 BIT** — chuỗi carry | 3,23 ns |
| 8 | `_128_` | `o2111ai_1` | kết thúc so sánh → `event_now` | 3,56 ns |
| 9 | `_138_` | `nor4_1` | **BỘ TĂNG 9 BIT** — cây carry tới bit cao | 3,70 ns |
| 10 | `_146_` | `nand4_1` | như trên | 3,85 ns |
| 11 | `_150_` | `xor2_1` | bit tổng thứ 8 của bộ tăng | 4,02 ns |
| 12 | `_171_` | `o21ai_0` | **MUX theo `terminal`** trước đầu vào D | 4,11 ns |
| 13 | `_198_` | `dfxtp_1` | `result_count[8]` — điểm kết thúc | setup 0,13 ns |

**Kết luận về cấu trúc:** đường tới hạn xuyên qua **hai chuỗi carry nối tiếp nhau**:

```
 sample_in ─▶ [carry 8 tầng của bộ SO SÁNH] ─▶ event_now ─▶ [carry của bộ TĂNG 9 bit] ─▶ result_count[8]
             ≈ 2,12 ns (6 maj3 + o2111ai)              ≈ 0,88 ns (nor4+nand4+xor2)
```

Phần so sánh tốn **gấp hơn hai lần** phần cộng, dù cả hai đều là “chuỗi carry 8–9 bit”. Lý
do: `abc` đã gộp được cây carry của bộ tăng thành `nor4`+`nand4` (mỗi cell gom 4 bit một
lần), trong khi chuỗi so sánh vẫn phải đi qua 6 cell `maj3_1` nối tiếp. Chi tiết và lời
giải thích ở `datapath.md` §5.

Ba khối con **không** nằm trên đường tới hạn: bộ đếm vị trí cửa sổ (`window_count`, đường
reg→reg ngắn), mạch phát hiện `terminal` (nó là đầu vào **chọn** của mux, tới sớm hơn dữ
liệu), và FF `window_done` (chỉ cách `terminal` đúng 0 cell).

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
