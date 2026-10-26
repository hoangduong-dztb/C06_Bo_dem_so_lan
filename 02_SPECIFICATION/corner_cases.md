# C06 · Ca biên và ca kiểm thử (Corner Cases)

File này giải thích **vì sao** từng ca được chọn. Danh sách suông không có giá trị dạy học:
một ca chỉ đáng chạy khi nó **có khả năng làm lộ ra một lỗi cụ thể** mà các ca khác không
lộ ra được.

Nguồn đọc: `05_VERIFICATION/testbench/c06_core_tb.sv` (74 dòng),
`05_VERIFICATION/golden_model/reference_model.py`, `05_VERIFICATION/simulation.log`.

---

## 0. Trạng thái tổng quát

Mô phỏng RTL **PASS** (`simulation.log`: `C06 core verification PASS`, `$finish` tại
`7696` đơn vị thời gian). Nhưng “PASS” chỉ nói **những ca đã viết** đều đúng. §3 dưới đây
liệt kê những ca Charter yêu cầu mà testbench **chưa** có.

> ⚠️ **Phát hiện về hạ tầng kiểm chứng.** `05_VERIFICATION/golden_model/c06_reference.sv`
> tồn tại và đúng cú pháp, nhưng **testbench không khởi tạo nó**. Dòng 8 của
> `c06_core_tb.sv` chỉ có `c06_core dut(.*);` — không có `c06_reference`. Nghĩa là lớp L1
> trong `testplan.md` **không thực sự được đối chiếu tự động**; mọi khẳng định đều so với
> hằng số viết tay trong testbench. So sánh: testbench của C07 và D01 **có** khởi tạo mô
> hình chuẩn SystemVerilog song song. Đây là điểm yếu thật của C06 và là ca bổ sung ưu
> tiên số 1 (TC-B0).

## 1. Ca bắt buộc của Charter mục 8 — đối chiếu với testbench thật

Charter mục 8: *“Không mẫu nào vượt · tất cả đều vượt (kết quả 255) · xen kẽ · kiểm thời
điểm chốt kết quả”*.

| Ca Charter | Lý do kỹ thuật phải có ca này | Có trong testbench? | Bằng chứng |
|---|---|:-:|---|
| **Không mẫu nào vượt** | Kiểm nhánh `e[n] = 0` **liên tục 256 lần**. Bắt lỗi kiểu “bộ đếm tự tăng do `event_now` bị treo `1`” và lỗi “bộ đếm không được xoá giữa hai cửa sổ” — nếu quên xoá, cửa sổ thứ hai vẫn ra khác 0. | 🟡 **Một phần** | Cửa sổ 2 trong testbench có **1** sự kiện (dòng 55) rồi 255 mẫu bằng ngưỡng → `result_count == 1`. **Không có cửa sổ nào cho kết quả đúng bằng 0.** |
| **Tất cả đều vượt (kết quả 255)** | Chạm **cận trên** của dải kết quả. Bắt lỗi tràn thanh ghi: nếu `result_count` chỉ có 8 bit, 256 sẽ quấn về 0. | ✅ có, **nhưng số kỳ vọng là 256, không phải 255** | Dòng 67–69: 256 mẫu `101`, khẳng định `result_count == 9'd256`. Xem `functional_spec.md` W-2. |
| **Xen kẽ** | Kiểm bộ đếm sự kiện tăng đúng khi `event_now` **đổi trạng thái mỗi chu kỳ** — bắt lỗi giữ (latch) hoặc lỗi đếm cạnh thay vì đếm mức. | ❌ **KHÔNG CÓ** | Testbench chỉ có các đoạn hằng số. Mô hình Python có mẫu `i % 7 == 0` (dòng 35–37) nhưng đó là mô hình thuần số học, **không chạy qua RTL**. |
| **Kiểm thời điểm chốt kết quả** | Ca **quan trọng nhất của đề**. Xem §2. | ✅ có, khá kỹ | Dòng 45–59 |
| Bổ sung ≥ 2 ca tự xây dựng, có ca biên | — | ✅ có 2 ca (xem §2) | Dòng 40–43, 62–64 |

## 2. Ca “kiểm thời điểm chốt” — vì sao nó là trái tim của đề

Charter mục 10 nêu đúng chỗ tắc: *“Chốt và xoá cùng một chu kỳ, làm mất một lần đếm.”*
Bẫy này có **ba biến thể** và ba biến thể đó cần **ba ca khác nhau** để phân biệt:

| Biến thể lỗi | Triệu chứng | Ca phát hiện được | Có trong testbench? |
|---|---|---|:-:|
| **B1** — dùng gán chặn `=`: xoá `event_count` trước rồi mới chốt | `result_count` luôn bằng `e[256]` (0 hoặc 1), mất toàn bộ cửa sổ | Bất kỳ cửa sổ nào có ≥ 2 sự kiện | ✅ — cửa sổ 1 có 3 sự kiện |
| **B2** — chốt `event_count` thay vì `event_count + e` | Mất đúng **1** khi mẫu cuối cửa sổ là sự kiện | Cửa sổ có sự kiện **đúng tại chu kỳ 256** | ✅ — dòng 43, sự kiện tại chu kỳ 256 |
| **B3** — nhầm biên cửa sổ: `terminal` đặt tại `254` hoặc `256` | Cửa sổ dài 255 hoặc 257 chu kỳ; sự kiện tại chu kỳ 255 rơi nhầm cửa sổ | Sự kiện đặt **đúng tại chu kỳ 255 và 256** rồi kiểm cả hai cửa sổ | ✅ — dòng 42–43 đặt sự kiện ở cả 255 và 256, dòng 55–59 kiểm cửa sổ kế tiếp |

Đây là lý do testbench chọn cấu hình lạ mắt “sự kiện tại chu kỳ **1, 255, 256**” chứ không
chọn ba chu kỳ bất kỳ: chu kỳ 1 kiểm mép **đầu** cửa sổ, 255 và 256 kiểm mép **cuối**, và
tổng bằng 3 là con số không thể ra được nếu bất kỳ biến thể B1–B3 nào xảy ra.

Bốn khẳng định ngay sau đó (dòng 45–52) kiểm **cả bốn thanh ghi cùng lúc** tại đúng chu kỳ
chuyển cửa sổ — `window_done == 1`, `result_count == 3`, `window_count == 0`,
`event_count == 0`. Kiểm cả bốn là cần thiết: một thiết kế có thể chốt đúng nhưng quên xoá,
và lỗi đó chỉ lộ ra ở cửa sổ **sau**.

## 3. Ca tự xây dựng — đã có trong testbench

| ID | Ca | Vì sao chọn | Loại |
|---|---|---|---|
| TC-T1 | `sample_in == threshold` suốt 255 chu kỳ (dòng 62–64) | Chốt quy ước biên `>` chứ không `>=`. Đây là **ca biên** đúng nghĩa: lệch 1 đơn vị so với ngưỡng theo cả hai chiều đều được thử qua các ca khác (`101` vượt, `100` không vượt). | **Biên giá trị** |
| TC-T2 | Cửa sổ 3: cả 256 mẫu đều vượt (dòng 67–69) | Chạm cận trên dải kết quả, buộc `result_count` phải rộng 9 bit. Nếu ai đó “tối ưu” xuống 8 bit, ca này FAIL ngay. | **Biên dải giá trị** |
| TC-T3 | Kiểm cửa sổ 2 khởi động đúng (dòng 55–59) | Sau khi chốt, `window_count` phải bằng **1** (không phải 0, không phải 2) và `event_count` phải bằng **1** ở chu kỳ đầu tiên của cửa sổ mới. Bắt lỗi “mất một chu kỳ khi chuyển cửa sổ” — tức cửa sổ dài 257. | **Biên thời điểm** |

## 4. Phân loại ca theo tiêu chí kỹ thuật riêng của C06

Đề này có **hai trục độc lập**. Một bộ ca tốt phải phủ cả hai, chứ không chỉ phủ một trục
nhiều lần.

**Trục A — vị trí sự kiện trong cửa sổ (kiểm logic điều khiển / biên cửa sổ):**

```
 chu kỳ:  1        2 ... 127 ... 254   255   256  │  1  (cửa sổ mới)
           ▲                             ▲     ▲  │  ▲
        mép đầu                       kề cuối cuối│ tái khởi động
          ✅ có          ⬜ giữa cửa sổ  ✅ có  ✅ có│  ✅ có
```

**Trục B — giá trị so với ngưỡng (kiểm bộ so sánh tổ hợp):**

| Quan hệ | Giá trị testbench dùng (`threshold = 100`) | Có? |
|---|---|:-:|
| `sample < threshold` | — | ❌ **không dùng giá trị nào nhỏ hơn 100** |
| `sample == threshold` | `100` | ✅ |
| `sample == threshold + 1` | `101` | ✅ |
| `sample = 255` (cực đại) | — | ❌ |
| `sample = 0` (cực tiểu) | `0` trong lúc reset | 🟡 chỉ trong reset |
| `threshold = 0` / `threshold = 255` | luôn là `100` | ❌ **ngưỡng không bao giờ đổi** |

Nhận xét: testbench phủ trục A rất tốt (đó là phần khó của đề) nhưng **phủ trục B rất
mỏng** — bộ so sánh 8 bit chỉ được thử ở hai giá trị `100` và `101`, cách nhau 1. Bộ so
sánh chính là nơi chứa **6 trong 13 cell của đường tới hạn** (6 cell `maj3_1`, xem
`06_GDSII/physical_report.md` §3), nên nó xứng đáng được kiểm kỹ hơn.

## 5. Ca cần bổ sung — đề xuất, **chưa chạy**

| ID | Ca | Phát hiện được lỗi gì | Ưu tiên |
|---|---|---|:-:|
| **TC-B0** | Khởi tạo `c06_reference` song song với `dut` và so từng chu kỳ trên `result_count` + `window_done` | Bù lỗ hổng ở §0: hiện không có đối chiếu tự động với mô hình độc lập | **Cao** |
| **TC-B1** | Một cửa sổ đủ 256 mẫu **đều không vượt** → `result_count == 0` | Ca Charter còn thiếu. Bắt lỗi bộ đếm sự kiện không được xoá, và lỗi `event_now` treo `1` | **Cao** |
| **TC-B2** | Xen kẽ `101, 100, 101, 100, …` suốt 256 chu kỳ → `result_count == 128` | Ca Charter còn thiếu. Bắt lỗi đếm cạnh thay vì đếm mức, và lỗi glitch trên `event_now` bị chốt nhầm | **Cao** |
| **TC-B3** | `threshold = 255`, mọi mẫu `= 255` → `result_count == 0` (INV-8) | Bắt lỗi dùng `>=` thay vì `>`; bắt lỗi tràn trong phép so sánh 8 bit | Trung bình |
| **TC-B4** | `threshold = 0`, mẫu xen kẽ `0` và `1` → `result_count == 128` | Biên dưới của ngưỡng. Bắt lỗi so sánh có dấu (nếu ai đó khai `signed`) | Trung bình |
| **TC-B5** | Khẳng định trực tiếp **INV-7**: `assert(event_count[8] == 1'b0)` mỗi chu kỳ | Biến một phát hiện cấu trúc thành bằng chứng chạy được. Nếu ca này FAIL thì phân tích ở `functional_spec.md` §7 sai | Trung bình |
| **TC-B6** | Chạy **ba cửa sổ liên tiếp** với kết quả khác nhau (ví dụ 0 → 256 → 5) và kiểm `result_count` giữ nguyên suốt 256 chu kỳ giữa hai xung | Kiểm INV-5 (`result_count` không đổi ngoài chu kỳ chốt). Bắt lỗi “thanh ghi chốt bị nối thẳng vào bộ đếm” | Trung bình |
| **TC-B7** | Nhả reset **giữa** một cửa sổ đang chạy (reset lần hai) | Bắt lỗi reset không xoá hết 4 thanh ghi. Hiện testbench chỉ reset đúng một lần lúc bắt đầu | Thấp |

Ước lượng công sức: TC-B1, TC-B2, TC-B4, TC-B6 chỉ là các vòng `for` giống hệt cấu trúc đã
có ở dòng 41 và 67 — thêm khoảng 25 dòng testbench. TC-B0 tốn khoảng 6 dòng.

## 6. Ca **KHÔNG** áp dụng cho đề này

| Ca | Vì sao không áp dụng |
|---|---|
| Cửa sổ trượt (mẫu mới đẩy mẫu cũ ra) | Charter mục 3 xếp vào **ngoài phạm vi**. Muốn làm phải có bộ đệm 256 mẫu — khoảng 2048 flip-flop, vượt xa ô 1×1 tile |
| Cửa sổ độ dài thay đổi | Charter mục 3, **ngoài phạm vi**. RTL hằng số hoá 255 ở dòng 17 |
| Thống kê khác (trung bình, phương sai, min/max) | Charter mục 3, **ngoài phạm vi**. Cần bộ chia hoặc bộ nhân |
| Ca bắt tay / backpressure (`ready`/`valid`) | Giao diện **không có** tín hiệu bắt tay nào. Khối chạy tự do 1 mẫu/chu kỳ |
| Ca vùng glitch trên đầu ra | Mọi đầu ra đều là **Q của flip-flop**, không có đường tổ hợp nào từ cổng vào ra thẳng cổng ra. Glitch nội bộ có tồn tại (trên `event_now`, `completed_count`) nhưng bị flip-flop lọc, miễn là thoả setup/hold |
| Ca recovery / removal của reset bất đồng bộ | Reset ở đây là **đồng bộ** — nó đi vào qua đường `D` như một tín hiệu dữ liệu bình thường, nên chỉ chịu ràng buộc setup/hold thông thường |
| Ca metastability trên `sample_in` | Là nghĩa vụ của **tầng ngoài** (xem `interface.md` §4). Khối giả định đầu vào đã đồng bộ với `clk` |
| Ca clock-domain crossing | Thiết kế chỉ có **một** clock domain (`clk`), xác nhận bằng SDC chỉ có một `create_clock` |

## 7. Ca cần bổ sung khi chuyển sang gate-level và post-layout

Những ca dưới đây **không thể** chạy trên RTL hành vi, vì mô phỏng RTL là zero-delay.

| Ca | Vì sao chỉ xuất hiện ở gate-level | Cần gì để chạy |
|---|---|---|
| **X-propagation lúc cấp nguồn** | Netlist dùng `sky130_fd_sc_hd__dfxtp_1` — flip-flop **không có chân reset**. Lúc cấp nguồn cả 27 FF đều là `X`. Phải chứng minh rằng **một** cạnh clock với `rst_n = 0` là đủ để xoá hết `X`, kể cả `X` trên `window_count` (vốn điều khiển `terminal`) | Mô phỏng netlist `06_GDSII/synthesis/netlist.v` + thư viện `sky130_fd_sc_hd.v`, khởi tạo mọi FF bằng `X` |
| **Vi phạm setup trên đường tới hạn** | RTL zero-delay luôn PASS. Đường thật `sample_in[0] → result_count[8]` dài **4,11 ns** (trong đó 1,00 ns là `set_input_delay` giả định) | Mô phỏng có back-annotate SDF, hoặc thu hẹp chu kỳ clock trong SDC tới khi slack âm |
| **Vi phạm hold trên `window_count`** | Đường reg→reg ngắn nhất là `window_count[0] → window_count[0]` (bit LSB chỉ đảo). Hold là rủi ro thật với đường ngắn cộng clock skew | `timing_report_min.txt` + SDF sau CTS |
| **Glitch trên `event_now` gây ăn thêm công suất** | Bộ so sánh 8 bit có nhiều đường hội tụ lại → glitch thật. Mô phỏng RTL không sinh glitch nên không thấy | VCD từ mô phỏng gate-level có độ trễ, rồi đưa lại vào OpenSTA để tính công suất động thật |
| **Công suất thật thay vì ước lượng** | Con số 1,22e-04 W hiện tại dùng hoạt động **mặc định**, không phải hoạt động thật của tải công việc | VCD của một ca thật (ví dụ TC-B2 xen kẽ — đây là ca có hoạt động cao nhất) |

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
