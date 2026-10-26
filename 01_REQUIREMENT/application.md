# C06 · Bối cảnh ứng dụng



| | |
|---|---|
| Mã đề | **C06** |
| Tên đề | Bộ đếm số lần vượt ngưỡng trong cửa sổ 256 chu kỳ |
| Nhóm đề | C · Ngưỡng, cảnh báo và giám sát |
| Độ khó | Trung bình |
| Loại mạch | **Tuần tự** |
| Quy mô ước lượng (Charter) | ~220–300 cell · 1×1 tile |
| Nguồn gốc | Project Charter — C06, mục 1 |

---

## 1. Mục tiêu và bối cảnh ứng dụng

Trích nguyên văn Charter mục 1:

> Phân tích khối số “Bộ đếm số lần vượt ngưỡng trong cửa sổ 256 chu kỳ” ở mức khối. Bối cảnh ứng dụng: Khối thống kê số lần vượt ngưỡng trong mỗi giây để đánh giá mức rung của máy công nghiệp.

## 2. Vị trí khối C06 trong hệ thống

```
   ┌──────────────┐      ┌──────────────────────────────┐      ┌──────────────┐
   │  Nguồn tín   │─────▶│      ►►► KHỐI C06 ◄◄◄        │─────▶│  Tầng tiêu   │
   │  hiệu / dữ   │      │  Bộ đếm số lần vượt ngưỡng tr │      │  thụ kết quả │
   │  liệu vào    │      │  Loại mạch: Tuần tự          │      │              │
   └──────────────┘      └──────────────────────────────┘      └──────────────┘
```

> Sơ đồ chi tiết có chú thích: `03_ARCHITECTURE/system_diagram.md`.

## 3. Phân loại analog / digital / mixed

| Khối | Phân loại | Ghi chú |
|---|---|---|
| Cảm biến / nguồn tín hiệu vật lý (nếu có) | Analog | Đại lượng liên tục |
| Chuyển đổi ADC/DAC (nếu có) | Mixed-signal | Ranh giới analog–số |
| **C06 — Bộ đếm số lần vượt ngưỡng trong cửa sổ 256 chu kỳ** | **Digital, tuần tự** | Có ô nhớ, hoạt động theo cạnh clock |
| Tầng xử lý phía sau | Digital | Tiêu thụ kết quả của C06 |

Bằng chứng cho dòng phân loại của C06: tổng hợp thật cho **27 flip-flop**
(`06_GDSII/synthesis/synth_stat.txt`).

---

**Truy vết:** yêu cầu sinh từ tài liệu này được đánh số `REQ-C06-0xx` trong
`01_REQUIREMENT/requirements.md`, và truy vết đến bằng chứng trong `07_TRACEABILITY/RTM.csv`.

*Phiên bản: v1.0 · Ngày: 2026-09-24*
