# C06 · Sơ đồ hệ thống (System Diagram)

---

## 1. Bối cảnh ứng dụng theo Charter mục 1

> *“Khối thống kê số lần vượt ngưỡng trong mỗi giây để đánh giá mức rung của máy công nghiệp.”*

Chuỗi xử lý đầy đủ của một hệ giám sát rung — C06 nằm ở **đoạn giữa**, sau số hoá và trước
truyền thông:

```
 ┌──────────────┐   analog    ┌──────────┐  8 bit   ┌───────────┐
 │ Cảm biến rung│────────────▶│   ADC    │─────────▶│ Tiền xử lý│
 │ (gia tốc kế) │  mV, liên   │ 8 bit    │ mỗi chu  │ |x|, lọc  │
 └──────────────┘  tục        └──────────┘ kỳ 1 mẫu └─────┬─────┘
                                                          │ sample_in[7:0]
                        threshold[7:0]                    │  (biên độ rung đã lấy trị tuyệt đối)
                     (từ thanh ghi cấu hình)              │
                                 │                        │
                ╔════════════════▼════════════════════════▼════════════════╗
                ║                    ▓▓▓  C06  ▓▓▓                          ║
                ║   Bộ đếm số lần vượt ngưỡng trong cửa sổ 256 chu kỳ       ║
                ║                                                           ║
                ║   result_count[8:0] ─────▶  số lần vượt của cửa sổ TRƯỚC  ║
                ║   window_done       ─────▶  xung 1 chu kỳ: đã có số mới   ║
                ╚═══════════════════════╤═══════════════════════════════════╝
                                         │
                        ┌────────────────▼────────────────┐
                        │  Tầng quyết định / MCU / UART   │
                        │  • so result_count với mức báo  │
                        │  • ghi log, gửi lên SCADA       │
                        │  • bật còi nếu nhiều cửa sổ liên│
                        │    tiếp đều cao                 │
                        └─────────────────────────────────┘
```

## 2. Ranh giới khối — cái gì **thuộc** C06, cái gì **không**

| Chức năng | Thuộc C06? | Ghi chú |
|---|:-:|---|
| Lấy mẫu tín hiệu analog, chuyển đổi A/D | ❌ | Tầng ngoài. C06 nhận số 8 bit đã sẵn sàng |
| Lấy trị tuyệt đối / lọc nhiễu của tín hiệu rung | ❌ | Tầng ngoài. C06 so sánh thô giá trị nhận được |
| **So sánh mẫu với ngưỡng** | ✅ | `event_now = (sample_in > threshold)` |
| **Đếm vị trí trong cửa sổ 256 chu kỳ** | ✅ | `window_count` |
| **Tích luỹ số sự kiện trong cửa sổ** | ✅ | `event_count` |
| **Chốt kết quả cuối cửa sổ và phát xung báo** | ✅ | `result_count`, `window_done` |
| Lưu giữ `threshold` qua thời gian | ❌ | **Tầng ngoài phải giữ `threshold` ổn định**. C06 không chốt nó — xem `functional_spec.md` §8 |
| Quyết định “rung quá mức” / báo động | ❌ | C06 chỉ đưa ra **con số**, không đưa ra **phán quyết** |
| Chuỗi nhiều cửa sổ, xu hướng theo thời gian | ❌ | Tầng ngoài. C06 không nhớ cửa sổ trước nữa sau khi chốt |
| Định nghĩa “một giây” | ❌ | **Điểm cần chú ý — xem §3** |

## 3. ⚠️ Hợp đồng ẩn: “256 chu kỳ” ≠ “một giây”

Charter mục 1 nói *“mỗi giây”*, nhưng RTL đếm **256 chu kỳ clock**. Hai đại lượng này chỉ
trùng nhau nếu tầng ngoài chọn `f_clk` sao cho `256 / f_clk ≈ 1 s`, tức `f_clk ≈ 256 Hz`.

| Nếu tầng ngoài dùng | Thì một “cửa sổ” dài |
|---|---|
| `f_clk = 256 Hz` | 1,000 s — đúng ý Charter |
| `f_clk = 1 kHz` | 0,256 s |
| `f_clk = 10 MHz` (tần số hay dùng cho ô Tiny Tapeout) | **25,6 µs** — hoàn toàn không phải một giây |

C06 **không** có bộ chia tần bên trong (đếm được 27 flip-flop, đủ cho đúng ba thanh ghi đã
biết — xem `functional_spec.md` §9, S-1 và S-2; không còn ô nhớ nào cho prescaler). Vậy
**nghĩa vụ của tầng ngoài** là một trong hai: (a) cấp `clk` ở đúng tần số mong muốn, hoặc
(b) đặt một bộ chia tần ở ngoài và chỉ cho C06 chạy ở nhịp mẫu. Đây là một ràng buộc hệ
thống phải ghi vào tài liệu tích hợp — không phải lỗi của C06, nhưng là chỗ rất dễ hiểu lầm.

Hệ quả thứ hai: vì không có tín hiệu `sample_valid`, mỗi chu kỳ clock **đều** được coi là
một mẫu mới. Nếu ADC chậm hơn clock, cùng một giá trị sẽ bị đếm nhiều lần.

## 4. Phân loại khối

| Tiêu chí | Kết luận | Bằng chứng |
|---|---|---|
| Analog / Digital / Mixed | **Digital thuần** | Toàn bộ netlist là standard cell `sky130_fd_sc_hd`; không có cell analog, không có macro (`power_report.txt`: nhóm Macro = 0 W) |
| Tổ hợp / Tuần tự | **Tuần tự** | 27 `dfxtp_1` trong `synth_stat.txt`; công suất nhóm Sequential chiếm **92,8 %** |
| Đồng bộ / Bất đồng bộ | **Đồng bộ một miền clock** | Chỉ một `create_clock` trong `design.sdc`; reset là đồng bộ |
| Có FSM? | Có, dạng **bộ đếm 256 trạng thái** | Xem `fsm.md` |

## 5. Sơ đồ vòng đời RTL → GDSII, trạng thái thật

Trạng thái lấy đúng từ `06_GDSII/physical_report.md` §1 và BRIEF C06.

```
  ┌────────────────┐
  │ 01 Yêu cầu     │ ✅  từ Charter C06
  └───────┬────────┘
  ┌───────▼────────┐
  │ 02 Đặc tả      │ ✅  interface · timing · functional_spec · corner_cases
  └───────┬────────┘
  ┌───────▼────────┐
  │ 03 Kiến trúc   │ ✅  block · datapath · control · fsm · timing_diagram · tradeoff
  └───────┬────────┘
  ┌───────▼────────┐
  │ 04 RTL         │ ✅  c06_core.sv (41 dòng) + design.sdc
  └───────┬────────┘
  ┌───────▼────────┐
  │ Mô hình Python │ ✅ PASS   CPython 3 · python_reference_run.log
  └───────┬────────┘
  ┌───────▼────────┐
  │ 05 Mô phỏng RTL│ ✅ PASS   Icarus Verilog 12.0 · simulation.log
  └───────┬────────┘
  ┌───────▼────────┐
  │ Tổng hợp logic │ ✅ PASS   Yosys 0.33 → 113 cell · 27 FF · 1012,2208 µm²
  └───────┬────────┘
  ┌───────▼────────┐
  │ STA sau tổng hợp│ ✅ PASS  OpenSTA 3.1.0 · arrival 4,11 ns · slack 5,76 ns
  └───────┬────────┘
  ┌───────▼────────┐
  │ Công suất (ướclg)│ ✅      1,22e-04 W (tổ hợp 7,2 % · tuần tự 92,8 %)
  └───────┬────────┘
  ┌───────▼────────┐
  │ Mô phỏng gate  │ ⬜ CHƯA CHẠY   cần netlist + thư viện .v (test_matrix: L4-GATE)
  └───────┬────────┘
  ┌───────▼────────┐
  │ Floorplan      │ ⬜ CHƯA CHẠY   cần PDK sky130A + LibreLane
  └───────┬────────┘
  ┌───────▼────────┐
  │ Placement      │ ⬜ CHƯA CHẠY
  └───────┬────────┘
  ┌───────▼────────┐
  │ CTS            │ ⬜ CHƯA CHẠY   ← chừng nào chưa chạy, clock vẫn là "ideal",
  └───────┬────────┘                  skew = 0, và mọi số slack đều lạc quan
  ┌───────▼────────┐
  │ Routing        │ ⬜ CHƯA CHẠY   ← chừng nào chưa chạy, chưa có ký sinh RC
  └───────┬────────┘
  ┌───────▼────────┐
  │ STA sau routing│ ⬜ CHƯA CHẠY   ← đây mới là số timing đáng tin
  └───────┬────────┘
  ┌───────▼────────┐
  │ DRC / LVS      │ ⬜ CHƯA CHẠY   Magic/KLayout · Netgen
  └───────┬────────┘
  ┌───────▼────────┐
  │ GDSII          │ ⬜ CHƯA CHẠY
  └───────┬────────┘
  ┌───────▼────────┐
  │ Sign-off       │ ⬛ NGOÀI PHẠM VI  Charter mục 3
  └───────┬────────┘
  ┌───────▼────────┐
  │ Tape-out · chế │ ⬛ NGOÀI PHẠM VI  Charter mục 3
  │ tạo · đo sau CT│
  └────────────────┘
```

**Đọc sơ đồ này thế nào cho đúng:** 8 bước đầu ✅ cho phép nói *“RTL đúng chức năng trên
tập ca đã viết, tổng hợp được, và ở góc `tt_025C_1v80` với chu kỳ giả định 10 ns thì còn
5,76 ns dư”*. Không cho phép nói bất cứ điều gì về tần số tối đa thật, về diện tích sau
P&R, hay về việc mạch chạy được trên silicon.

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
