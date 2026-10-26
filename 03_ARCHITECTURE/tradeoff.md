# C06 · Phân tích đánh đổi (Trade-off)

Mọi con số trong file này lấy từ `06_GDSII/synthesis/synth_stat.txt`,
`06_GDSII/sta/timing_report_max.txt` và `06_GDSII/power/power_report.txt` của **chính lần
chạy này**. Cột nào chưa có số đo thì ghi ⬜, không ước lượng cho đẹp.

---

## 1. Số liệu nền của kiến trúc đang dùng

| Chỉ số | Giá trị đo | Nguồn |
|---|---:|---|
| Tổng cell | **113** | `synth_stat.txt` |
| Flip-flop | **27** (8 + 9 + 9 + 1) | `synth_stat.txt`, `netlist.v` `_172_`…`_198_` |
| Diện tích | **1012,2208 µm²** | `synth_stat.txt` |
| Data arrival | **4,11 ns** (trong đó 1,00 ns là `set_input_delay`) | `timing_report_max.txt` |
| Slack @ chu kỳ giả định 10 ns | **5,76 ns** (MET) | `timing_report_max.txt` |
| Công suất | **1,22e-04 W** · tuần tự **92,8 %** · tổ hợp **7,2 %** | `power_report.txt` |
| Charter ước lượng quy mô | ~220–300 cell | Charter metadata |

> 🔎 **Con số đáng chú ý nhất: 92,8 % công suất nằm ở nhóm Sequential.** 27 flip-flop trong
> tổng 113 cell (24 %) nhưng tiêu thụ 1,13e-04 trong tổng 1,22e-04 W. Với C06, **mỗi
> flip-flop cắt được là một khoản tiết kiệm công suất thật**, trong khi cắt cổng tổ hợp gần
> như không đổi được gì. Điều này lật ngược trực giác thông thường và phải là cơ sở cho mọi
> đánh đổi bên dưới. (So sánh nội bộ: C07 cùng nhóm Charter có 83 cell nhưng chỉ **1** FF,
> và ở đó công suất tuần tự chỉ chiếm 10,8 %.)

Ghi chú về Charter: thiết kế ra **113 cell** trong khi Charter ước lượng 220–300. Chênh
lệch này **không** phải dấu hiệu làm đúng hay làm sai; nó phản ánh rằng RTL dùng mô tả hành
vi (`+`, `>`, `==`) để Yosys/abc tự chọn cấu trúc, thay vì mô tả cấu trúc tường minh.

---

## 2. So sánh kiến trúc đã chọn với ba phương án thay thế

**Phương án 0 — hiện tại: hai bộ đếm song song + một thanh ghi chốt (9 bit).**

```
  sample ─▶[so sánh]─▶ e ─▶[+]──┬──▶ event_count (9 FF)
                                └──▶ result_count (9 FF)   ◀── chốt khi terminal
  window_count (8 FF) ─▶[==255]─▶ terminal
  window_done (1 FF)
```

**Phương án 1 — bỏ thanh ghi chốt, đưa thẳng `event_count` ra kèm `window_done`.**

```
  sample ─▶[so sánh]─▶ e ─▶[+]──▶ event_count (9 FF) ──▶ ra
                                  (tầng ngoài phải đọc đúng chu kỳ terminal)
```

**Phương án 2 — kết quả bão hoà 8 bit tại 255 (khớp đúng chữ của Charter mục 8).**

```
  completed_count[8] = 1  ⇒  result_count ← 8'd255   (thêm 1 cổng OR/mux 8 bit)
  event_count và result_count cùng còn 8 bit
```

**Phương án 3 — một bộ đếm duy nhất, dùng dịch/nối để tách hai trường.**
(Gộp `window_count` và `event_count` vào một thanh ghi 17 bit rồi tách bằng chỉ số bit —
kiểu tối ưu “thông minh” mà sinh viên hay đề xuất.)

| Tiêu chí | **P0 (đang dùng)** | P1 — bỏ chốt | P2 — bão hoà 8 bit | P3 — gộp một thanh ghi |
|---|---|---|---|---|
| Flip-flop | **27** (đo) | **18** (27 − 9) | **25** (27 − 2) | 17 + 9 = **26**, nhưng xem ghi chú |
| Ảnh hưởng công suất | nền 1,22e-04 W | **giảm mạnh** — bỏ 33 % số FF, mà FF chiếm 92,8 % công suất | giảm nhẹ (2/27 FF ≈ 7 % số FF) | ≈ như P0 |
| Diện tích | 1012,2208 µm² (đo) | ⬜ chưa chạy — dự đoán giảm đáng kể | ⬜ chưa chạy — dự đoán giảm nhẹ rồi tăng lại do mạch bão hoà | ⬜ chưa chạy |
| Độ trễ đường tới hạn | 4,11 ns (đo) | ≈ như P0 (bỏ mux chốt, có thể nhanh hơn ~0,09 ns — độ trễ của `_171_`) | **tăng** — thêm một tầng chọn bão hoà sau bộ tăng | **tăng** — phép cộng 17 bit thay cho 8 và 9 bit riêng |
| Cửa sổ đọc kết quả của tầng ngoài | **256 chu kỳ** | **1 chu kỳ** | 256 chu kỳ | 256 chu kỳ |
| Phân biệt được “255 lần” với “256 lần”? | ✅ | ✅ | ❌ **mất thông tin** | ✅ |
| Khớp Charter mục 8 (“kết quả 255”) | ❌ (cho 256) | ❌ | ✅ | ❌ |
| Khớp Charter mục 4 (`uo_out` 8 bit) | ❌ | ❌ | ✅ | ❌ |
| Khớp Charter mục 10 (24–26 FF) | ❌ (27) | ✅ | ✅ | 🟡 |
| Độ phức tạp hiểu & bảo trì | Thấp — mỗi thanh ghi một nhiệm vụ | Thấp | Trung bình | **Cao** — trộn hai miền nghĩa vào một thanh ghi |
| Khi nào nên dùng | Khi tầng ngoài là phần mềm/MCU đọc không đúng nhịp | Khi tầng ngoài là phần cứng đọc đúng nhịp `window_done`, và cần tiết kiệm công suất | Khi ngân sách chân **bắt buộc** `uo_out` 8 bit và ứng dụng chấp nhận bão hoà | **Không nên dùng** — xem dưới |

**Vì sao P3 bị loại dù trông có vẻ tiết kiệm:** hai bộ đếm hiện tại đếm hai thứ **khác
nhau về bản chất** — một đếm *thời gian* (vô điều kiện), một đếm *sự kiện* (có điều kiện).
Gộp chúng vào một thanh ghi 17 bit buộc phải cộng một hằng số phức tạp (`+1` cho trường
thấp và `+e` cho trường cao) và phải chặn carry tràn giữa hai trường. Kết quả: nhiều logic
tổ hợp hơn, chuỗi carry dài hơn (17 bit thay vì 9), gần như không tiết kiệm được FF, và mất
hoàn toàn tính một chiều điều khiển → datapath mô tả ở `control.md` §4. Đây là ví dụ điển
hình của “tối ưu sớm làm hỏng kiến trúc”.

**Đánh đổi thật của P1 (đáng bàn nhất):** P1 bỏ được **9 FF trên 27**, tức **một phần ba**
số flip-flop, trong một thiết kế mà flip-flop chiếm **92,8 %** công suất. Đây là phương án
duy nhất có khả năng giảm công suất **đáng kể**. Cái giá phải trả là hợp đồng giao diện:
tầng ngoài phải chốt `event_count` **đúng trong chu kỳ có `window_done = 1`**, cửa sổ đọc
thu từ 256 chu kỳ xuống **1** chu kỳ. Với một MCU đọc qua bus, điều đó không chấp nhận
được; với một khối phần cứng bên cạnh thì lại hoàn toàn bình thường. **Không có phương án
nào thắng tuyệt đối — nó phụ thuộc tầng ngoài là gì**, mà điều đó Charter chưa chốt.

---

## 3. Một đánh đổi nhỏ nhưng miễn phí: `event_count` 9 bit → 8 bit

Đây không phải đổi kiến trúc, chỉ là sửa độ rộng một tín hiệu, nên đáng tách riêng.

Theo **INV-7** (`functional_spec.md` §7), `event_count[8]` **chứng minh được là luôn bằng 0**:
trong một cửa sổ chỉ có 255 cạnh không-kết-thúc nên `event_count ≤ 255`; giá trị 256 chỉ
tồn tại trên dây tổ hợp `completed_count` và đi thẳng vào `result_count`.

| Nếu sửa | Kết quả |
|---|---|
| Khai `event_count` là `logic [7:0]` (và giữ `completed_count` 9 bit) | **26 FF** thay vì 27 → **lọt vào dải 24–26 của Charter mục 10** |
| Hoặc: giữ 9 bit nhưng **không đưa `event_count` ra cổng ra** | Yosys tự gỡ bit hằng số → cũng còn 26 FF |
| Chức năng | **Không đổi một chút nào** — `result_count` vẫn đếm được tới 256 |
| Rủi ro | Phải cẩn thận giữ phép cộng ở 9 bit; nếu cắt cả `completed_count` xuống 8 bit thì kết quả 256 sẽ quấn về 0 và ca TC-T2 của testbench sẽ FAIL ngay |

Lý do RTL hiện tại có 9 FF cho `event_count`: nó là **cổng ra** của module top, nên trình
tổng hợp buộc phải giữ, kể cả khi chứng minh được nó là hằng số. Đây là bài học tổng quát:
**mọi tín hiệu gỡ lỗi đưa ra cổng top đều là một cam kết phần cứng.** Đề nghị này
**chưa được áp dụng** — RTL giữ nguyên bản gốc, cần thầy duyệt.

---

## 4. Đánh đổi ở mức giao diện (không phải mức kiến trúc)

Charter mục 4 ghi ngân sách 25 bit trên 24 chân. Thiết kế hiện tại còn xa hơn thế: **27
bit ra**. Ba hướng xử lý và cái giá của từng hướng:

| Hướng | Cái được | Cái mất | Chi phí ô nhớ |
|---|---|---|---|
| **H1 — bỏ cổng quan sát** `window_count`, `event_count` khỏi top | Còn `result_count[8:0]` + `window_done` = 10 bit ra; Yosys tự gỡ `event_count[8]` → **26 FF** | Mất khả năng quan sát nội bộ khi gỡ lỗi trên silicon | **−1 FF** |
| **H2 — nạp `threshold` hai nhịp** (Charter mục 4 gợi ý) | Giải phóng 8 chân vào | Thêm thanh ghi giữ `threshold` + FSM nạp | **+8 FF + FSM** |
| **H3 — bão hoà `result_count` xuống 8 bit** (= P2 ở §2) | Khớp đúng `uo_out[7:0]` của Charter | Không phân biệt được 255 với 256 lần vượt | **−2 FF** |

**H1 là hướng rẻ nhất và duy nhất không mất thông tin.** Nhưng Charter mục 4 ghi rõ phải
**hỏi giảng viên trước khi chọn**, nên hồ sơ này dừng ở mức nêu ba phương án kèm số, không
tự quyết. Xem `02_SPECIFICATION/interface.md` §3.

---

## 5. Những đánh đổi **KHÔNG được phép** trong đề này

| Việc bị cấm | Nguồn cấm | Vì sao |
|---|---|---|
| Đổi sang **cửa sổ trượt** | Charter mục 3 — ngoài phạm vi | Cần bộ đệm 256 mẫu ≈ 2048 FF, vượt xa ô 1×1 tile |
| **Cửa sổ độ dài thay đổi** | Charter mục 3 — ngoài phạm vi | Đổi `==255` thành so sánh với thanh ghi cấu hình sẽ làm đường tới hạn dài thêm và cần FSM nạp |
| Thêm **thống kê khác** (trung bình, min/max, phương sai) | Charter mục 3 — ngoài phạm vi | Cần bộ chia hoặc bộ nhân |
| **Sửa netlist bằng tay** để giảm cell | Charter mục 3 (áp cho mọi đề) | Netlist là sản phẩm của công cụ; sửa tay làm mất truy vết RTL ↔ netlist |
| **Tự làm physical design** | Charter mục 3 | Ngoài phạm vi học phần |
| Tuyên bố **sign-off / tape-out / chạy được ở X MHz** | Charter mục 3 + quy tắc hồ sơ | Chưa chạy P&R, chưa có ký sinh RC, mới một góc PVT (`tt_025C_1v80`) |
| **Sửa RTL của thầy** để lọt ngưỡng 24–26 FF | Quy tắc hồ sơ | Đã nêu đề nghị ở §3, nhưng phải được duyệt trước khi áp dụng |
| Đổi quy ước biên từ `>` sang `>=` để “cho tròn số” | `functional_spec.md` §2 | Ba lớp (RTL, Python, testbench) đang nhất quán dùng `>`; đổi một chỗ sẽ làm lệch cả ba |

---

## 6. Kết luận đánh đổi

Kiến trúc hiện tại chọn **rõ ràng và an toàn** thay vì **nhỏ gọn**:

1. Mỗi thanh ghi một nhiệm vụ duy nhất (vị trí cửa sổ · tích luỹ · chốt · báo) → đọc mã
   một lần là hiểu, và cái bẫy “chốt & xoá” của Charter mục 10 được xử lý đúng ngay từ đầu.
2. Cái giá phải trả: **27 flip-flop**, vượt 1 ô so với “dấu hiệu làm đúng” của Charter, và
   trong đó **một FF chứng minh được là hằng số 0**.
3. Trong bốn hướng cải thiện, chỉ có **hai hướng thực sự đáng cân nhắc**: §3 (sửa độ rộng
   `event_count`, gần như miễn phí, −1 FF) và P1 ở §2 (bỏ thanh ghi chốt, −9 FF và giảm
   công suất đáng kể, nhưng đổi hợp đồng giao diện).
4. Mọi hướng còn lại hoặc bị Charter cấm, hoặc đánh đổi thông tin lấy diện tích — không
   đáng với một thiết kế mới chỉ 113 cell và còn **5,76 ns slack**.

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
