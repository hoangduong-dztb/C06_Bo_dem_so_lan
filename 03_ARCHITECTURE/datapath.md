# C06 · Đường dữ liệu (Datapath)

---

## 1. Hai dòng chảy tách biệt

C06 có **hai** dòng dữ liệu chạy song song, gặp nhau đúng một lần mỗi 256 chu kỳ:

```
  Dòng A — DỮ LIỆU (phụ thuộc đầu vào, thay đổi mỗi chu kỳ)
  sample_in ══▶ so sánh ──▶ event_now ──▶ cộng dồn ══▶ event_count ══╗
                                                                      ║
  Dòng B — THỜI GIAN (hoàn toàn không phụ thuộc đầu vào)              ║
  window_count ══▶ +1 ══▶ window_count ──▶ ==255 ──▶ terminal ───────▶╫── chọn
                                                          │           ║
                                                          │           ▼
                                                          │    result_count ══▶ ra
                                                          └──────────▶ window_done ──▶ ra
```

Dòng B là một **bộ đếm tự do**: giá trị của nó ở chu kỳ `n` chỉ là `n mod 256`, hoàn toàn
tiên đoán được, không nhìn vào `sample_in` một lần nào. Dòng A là phần duy nhất mang thông
tin. `terminal` là tín hiệu **điều khiển** do dòng B sinh ra để đóng mở dòng A.

Việc tách sạch hai dòng như vậy là một lựa chọn kiến trúc tốt: nó khiến thời điểm chốt
**không thể** bị dữ liệu làm lệch, và khiến khối hoàn toàn xác định về mặt thời gian
(`window_done` luôn xuất hiện đúng mỗi 256 chu kỳ bất kể dữ liệu gì).

## 2. Bảng các đường dữ liệu

| Đường | Độ rộng | Từ | Đến | Bản chất |
|---|---:|---|---|---|
| `sample_in[7:0]` | 8 | cổng vào | bộ so sánh | Dữ liệu người dùng |
| `threshold[7:0]` | 8 | cổng vào | bộ so sánh | **Cấu hình** — phải ổn định cả cửa sổ (`functional_spec.md` §8) |
| `event_now` | 1 | bộ so sánh | bộ tăng 9 bit | Dữ liệu đã nén còn 1 bit — **toàn bộ thông tin của một mẫu bị rút xuống 1 bit ở đây** |
| `event_count[8:0]` | 9 | thanh ghi | bộ tăng (vòng hồi tiếp) + cổng ra | Tích luỹ. Bit [8] chứng minh được luôn = 0 (INV-7) |
| `completed_count[8:0]` | 9 | bộ tăng | thanh ghi sự kiện **và** thanh ghi chốt | **Dây tổ hợp dùng chung hai đích** — chỗ tiết kiệm phần cứng chính của đề |
| `window_count[7:0]` | 8 | thanh ghi | bộ tăng 8 bit (vòng hồi tiếp) + mạch `==255` + cổng ra | Vị trí trong cửa sổ |
| `terminal` | 1 | mạch `==255` | chân chọn của mux trước cả 27 FF, và D của `window_done` | **Điều khiển**, không phải dữ liệu |
| `result_count[8:0]` | 9 | thanh ghi chốt | cổng ra | Kết quả cửa sổ trước |
| `window_done` | 1 | thanh ghi 1 bit | cổng ra | Xung báo hợp lệ |
| `rst_n` | 1 | cổng vào | **cửa tổ hợp trên đường D của cả 27 FF** | Reset đồng bộ — đi như dữ liệu, không vào chân reset |

## 3. Đồ thị phụ thuộc trong một chu kỳ

Mức = số tầng logic tính từ thời điểm tín hiệu sẵn sàng (đầu chu kỳ).

```
  mức 0   sample_in[7:0]        threshold[7:0]      window_count[7:0](Q)   event_count[8:0](Q)
             │                       │                    │      │                │
             └───────────┬───────────┘                    │      │                │
                         ▼                                │      │                │
  mức 1..8   ┌───────────────────────┐          ┌─────────▼──┐ ┌─▼────────────┐   │
             │ SO SÁNH 8 BIT         │          │ AND8       │ │ +1 (8 bit)   │   │
             │ chuỗi mượn 8 tầng     │          │ ==255      │ │ chuỗi carry  │   │
             └───────────┬───────────┘          └─────┬──────┘ └──────┬───────┘   │
                         ▼                            ▼               │           │
  mức 9              event_now  ──────────────▶ terminal              │           │
                         │                        │ │ │               │           │
                         ▼                        │ │ │               │           │
  mức 10..13  ┌────────────────────────┐          │ │ │               │           │
              │ TĂNG 9 BIT             │◀─────────┼─┼─┼───────────────┼───────────┘
              │ completed_count        │          │ │ │               │
              └───────────┬────────────┘          │ │ │               │
                          ▼                       │ │ │               │
  mức 14      ┌──────────────────────────────┐    │ │ │               │
              │ MUX theo terminal (27 bit)   │◀───┘─┘─┘               │
              └───┬─────────┬─────────┬──────┘                        │
                  ▼         ▼         ▼                               ▼
  mức 15      result_count event_count window_done              window_count
               (D của FF)   (D của FF)  (D của FF)                (D của FF)
```

**Độ sâu logic của từng đầu ra (số tầng tính từ đầu chu kỳ):**

| Đầu ra (đầu vào D của thanh ghi) | Nguồn sâu nhất | Độ sâu |
|---|---|---|
| `window_count` | `window_count(Q)` qua bộ tăng 8 bit + mux | **nông** — chỉ 1 chuỗi carry, và chuỗi đó bắt đầu từ Q của FF (không có 1 ns input delay) |
| `window_done` | `window_count(Q)` qua AND8 | **rất nông** — 1 cây AND |
| `event_count` | `sample_in` qua **so sánh + tăng + mux** | **sâu** |
| `result_count[8]` | như trên, nhưng tới **bit cao nhất** của bộ tăng | **sâu nhất** ⬅ **đường tới hạn thật** |

## 4. Dự đoán đường tới hạn **trước khi** xem STA

Lập luận từ RTL: điểm bắt đầu phải là `sample_in` (không phải `window_count`), vì chỉ
`sample_in` mới phải đi qua **hai** mạch số học nối tiếp:

```
 sample_in ──▶ [so sánh 8 bit] ──▶ event_now ──▶ [tăng 9 bit] ──▶ [mux terminal] ──▶ FF
```

còn `window_count` chỉ đi qua **một** mạch (`+1`) rồi vào mux. Trong hai đích của bộ tăng
(`event_count` và `result_count`), bit **cao nhất** là bit cuối chuỗi carry nên sâu nhất.
Vậy dự đoán: **`sample_in[i] → result_count[8]` hoặc `→ event_count[8]`**.

## 5. Đối chiếu với STA thật

`06_GDSII/sta/timing_report_max.txt`:

| Đại lượng | Giá trị đo | Dự đoán ở §4 |
|---|---|---|
| Startpoint | `sample_in[0]` | ✅ đúng — và đúng cả **bit 0**, vì LSB phải đi qua toàn bộ chuỗi mượn |
| Endpoint | `_198_` = **`result_count[8]`** | ✅ đúng |
| Data arrival | 4,11 ns | — |
| Slack | 5,76 ns (MET) | — |
| Số cell trên đường | 13 | — |

Đường **thứ hai** trong báo cáo là `sample_in[0] → _197_` (`result_count[7]`) — cũng thuộc
cùng họ đường, xác nhận rằng cả cụm bit cao của thanh ghi chốt đều sát nhau. Dự đoán trùng
với STA, nhưng có **ba chi tiết chỉ STA mới nói được**, và đây mới là phần đáng học:

**(a) 1,00 ns trong 4,11 ns không phải là logic.** Dòng đầu tiên của báo cáo ghi
`1.00 1.00 v input external delay` — đó là `set_input_delay 1.0` trong `design.sdc`, một
**giả định** về việc tín hiệu tới muộn 1 ns sau cạnh clock. Độ trễ do **mạch của C06** gây
ra chỉ là **4,11 − 1,00 = 3,11 ns**. Báo “C06 mất 4,11 ns” mà không nói câu này là báo sai.

**(b) Bộ so sánh đắt hơn bộ cộng, dù cả hai cùng là chuỗi carry.**

| Đoạn | Cell | Thời gian | Tỷ lệ của 3,11 ns |
|---|---|---:|---:|
| Đệm đầu vào `_118_` | 1 × `lpflow_isobufsrc_1` | 0,11 ns | 3,5 % |
| **So sánh 8 bit** `_119_`…`_128_` | 6 × `maj3_1` + 1 × `o2111ai_1` | **2,45 ns** | **78,8 %** |
| **Tăng 9 bit** `_138_`…`_150_` | `nor4_1` + `nand4_1` + `xor2_1` | 0,46 ns | 14,8 % |
| Mux `terminal` `_171_` | `o21ai_0` | 0,09 ns | 2,9 % |

Vì sao **cùng là chuỗi carry 8–9 bit** mà bộ so sánh tốn 2,45 ns còn bộ tăng chỉ tốn
0,46 ns? Vì bài toán khác nhau về mặt tin học:

- Bộ **so sánh** `a > b` cần carry lan từ bit 0 lên bit 7 với **cả hai** toán hạng biến
  thiên. `abc` phải dùng `maj3_1` (hàm đa số = hàm carry thật), mỗi cell trễ ~0,35 ns, nối
  **nối tiếp** 6 cái → không nén được.
- Bộ **tăng** `x + 1` (hoặc `+0`) có một toán hạng là **hằng số**. Carry vào bit `k` đơn
  giản là `event_now AND x[0] AND x[1] AND … AND x[k-1]` — một **hàm AND thuần**, mà AND
  thì gom được thành cây: `nor4_1` gom 4 bit trong một cell, `nand4_1` gom tiếp. Độ sâu
  giảm từ 8 tầng xuống 2 tầng.

> 🔑 Đây là phát biểu tổng quát đáng nhớ: **cộng với hằng số rẻ hơn hẳn cộng hai biến, và
> so sánh hai biến đắt ngang cộng hai biến.** Trong C06, cái đắt không phải “bộ đếm” như
> tên đề gợi ý, mà là **bộ so sánh ngưỡng**.

**(c) Đường reg→reg hoàn toàn không xuất hiện trong top paths.** Cả hai đường đầu bảng đều
là in→reg xuất phát từ `sample_in[0]`. Điều đó **không** có nghĩa đường reg→reg an toàn —
nó chỉ có nghĩa là với `set_input_delay = 1.0 ns`, đường in→reg đang nặng hơn. Nếu tầng
ngoài đưa `sample_in` tới sớm hơn (input delay nhỏ hơn), thứ hạng có thể đảo. **Không được
kết luận “đường reg→reg của C06 nhanh” từ báo cáo này.**

## 6. Vì sao `event_count` phải rộng 9 bit, và vì sao đó là lãng phí

`event_count` chứa số sự kiện tích luỹ **trong cửa sổ đang chạy**. Theo INV-7, giá trị lớn
nhất nó có thể đạt là **255** (vì chỉ có 255 cạnh không-kết-thúc trong một cửa sổ). Vậy
8 bit là đủ. Giá trị **256** chỉ tồn tại trên **dây tổ hợp** `completed_count` trong đúng
một chu kỳ, rồi đi thẳng vào `result_count`.

Nhưng RTL khai `event_count` là `logic [8:0]` và đưa nó ra **cổng ra**. Hệ quả:

| | Nếu `event_count` là 9 bit và là cổng ra (hiện tại) | Nếu là 8 bit, hoặc là tín hiệu nội bộ |
|---|---|---|
| Số FF | **27** | **26** |
| Yosys có tự bỏ `event_count[8]` được không? | **Không** — nó là cổng ra của module top, trình tổng hợp buộc phải giữ | Có — với tín hiệu nội bộ hằng số, Yosys tự gỡ |
| Đối chiếu Charter mục 10 (24–26 ô nhớ) | ❌ vượt | ✅ nằm trong dải |

Đây là một flip-flop **chứng minh được là luôn bằng 0** nhưng vẫn tốn diện tích, tốn công
suất clock, và tốn một ô trong ngân sách. Nó tồn tại **chỉ vì** cổng quan sát
`event_count` được đưa ra ngoài — một quyết định gỡ lỗi, không phải quyết định chức năng.

## 7. Cơ hội pipeline — chỉ để thảo luận

Đường tới hạn 3,11 ns logic còn dư 5,76 ns slack ở chu kỳ giả định 10 ns, nên **hiện chưa
có nhu cầu pipeline**. Nếu về sau cần ép chu kỳ xuống ~2 ns, chỗ cắt hợp lý duy nhất là
ngay sau `event_now`:

```
 sample_in ─▶[so sánh 8 bit]─▶ REG ─▶[tăng 9 bit]─▶[mux]─▶ FF
             ~2,45 ns              ~0,55 ns
```

Chi phí: **+1 FF**, và **+1 chu kỳ độ trễ** — nghĩa là biên cửa sổ bị lệch một nhịp so với
`window_count`, phải dịch `terminal` tương ứng. Đây chính là loại sửa dễ gây lỗi “mất một
lần đếm” mà Charter mục 10 cảnh báo. Phương án này **không được áp dụng** trong phạm vi
đề (Charter mục 3: tự tối ưu kiến trúc nằm ngoài phạm vi) — xem `tradeoff.md`.

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
