# 📚 TÀI LIỆU MÔ TẢ DATABASE
## Hệ thống Quản lý Đăng ký Môn học và Thu Học phí

---

## 1.  TỔNG QUAN

### 1.1. Thông tin chung
| Thuộc tính | Giá trị |
|------------|---------|
| Tên Database | `ql_dangky_hocphi` |
| Hệ quản trị CSDL | PostgreSQL |
| Phiên bản | 12+ |
| Số lượng bảng | 22 bảng |
| Mã hóa | UTF-8 |

### 1.2. Danh sách các bảng theo nhóm chức năng

| STT | Nhóm | Bảng | Mô tả |
|-----|------|------|-------|
| 1 | Địa danh | `tinh` | Danh sách tỉnh/thành phố |
| 2 | Địa danh | `huyen` | Danh sách huyện/quận |
| 3 | Đối tượng | `doi_tuong` | Danh mục đối tượng ưu tiên |
| 4 | Đối tượng | `doi_tuong_sinh_vien` | Liên kết SV với đối tượng |
| 5 | Tổ chức | `khoa` | Danh sách khoa |
| 6 | Tổ chức | `nganh_hoc` | Danh sách ngành học |
| 7 | Nhân sự | `sinh_vien` | Thông tin sinh viên |
| 8 | Môn học | `mon_hoc` | Danh sách môn học |
| 9 | Đào tạo | `chuong_trinh_hoc` | Chương trình đào tạo |
| 10 | Thời gian | `nam_hoc` | Danh sách năm học |
| 11 | Thời gian | `hoc_ky` | Danh sách học kỳ |
| 12 | Đào tạo | `mon_hoc_mo` | Môn học mở trong học kỳ |
| 13 | Đăng ký | `phieu_dang_ky` | Phiếu đăng ký học phần |
| 14 | Đăng ký | `chi_tiet_dang_ky` | Chi tiết môn đăng ký |
| 15 | Học phí | `phieu_thu_hoc_phi` | Phiếu thu học phí |
| 16 | Cấu hình | `don_gia_tin_chi` | Đơn giá tín chỉ |
| 17 | Tài khoản | `vai_tro` | Vai trò người dùng |
| 18 | Tài khoản | `quyen` | Danh sách quyền |
| 19 | Tài khoản | `phan_quyen` | Phân quyền cho vai trò |
| 20 | Tài khoản | `tai_khoan` | Tài khoản đăng nhập |
| 21 | Tài khoản | `lich_su_dang_nhap` | Lịch sử đăng nhập |
| 22 | Thông báo | `thong_bao` | Thông báo chung |
| 23 | Thông báo | `thong_bao_ca_nhan` | Thông báo cá nhân |
| 24 | Hệ thống | `log_hoat_dong` | Log hoạt động |

---

## 2. MÔ TẢ CHI TIẾT CÁC BẢNG

---

### 2.1. BẢNG `tinh` - Tỉnh/Thành phố

**Mô tả:** Lưu trữ danh sách các tỉnh/thành phố (QĐ1)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `ma_tinh` | VARCHAR(10) | NO | - | **PK** - Mã tỉnh |
| `ten_tinh` | VARCHAR(100) | NO | - | Tên tỉnh/thành phố |
| `trang_thai` | BOOLEAN | YES | TRUE | Trạng thái hoạt động |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |

**Khóa chính:** `ma_tinh`

**Ràng buộc:** Không có

**Ví dụ dữ liệu:**
```sql
| ma_tinh | ten_tinh           | trang_thai |
|---------|--------------------|------------|
| HCM     | TP.  Hồ Chí Minh    | true       |
| HN      | Hà Nội             | true       |
| DL      | Đắk Lắk            | true       |
```

---

### 2.2. BẢNG `huyen` - Huyện/Quận

**Mô tả:** Lưu trữ danh sách huyện/quận, đánh dấu vùng sâu/vùng xa (QĐ1)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `ma_huyen` | VARCHAR(10) | NO | - | **PK** - Mã huyện |
| `ten_huyen` | VARCHAR(100) | NO | - | Tên huyện/quận |
| `ma_tinh` | VARCHAR(10) | NO | - | **FK** → `tinh.ma_tinh` |
| `la_vung_sau_vung_xa` | BOOLEAN | YES | FALSE | Đánh dấu vùng sâu/xa (QĐ1) |
| `trang_thai` | BOOLEAN | YES | TRUE | Trạng thái |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |

**Khóa chính:** `ma_huyen`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_huyen_tinh` | `ma_tinh` | `tinh(ma_tinh)` | Huyện thuộc tỉnh |

**Ví dụ dữ liệu:**
```sql
| ma_huyen | ten_huyen          | ma_tinh | la_vung_sau_vung_xa |
|----------|--------------------|---------|--------------------|
| Q1       | Quận 1             | HCM     | false              |
| KRONG    | Huyện Krông Bông   | DL      | true               |
```

---

### 2.3. BẢNG `doi_tuong` - Đối tượng ưu tiên

**Mô tả:** Danh mục các đối tượng ưu tiên với tỷ lệ giảm học phí (QĐ1)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `ma_doi_tuong` | VARCHAR(10) | NO | - | **PK** - Mã đối tượng |
| `ten_doi_tuong` | VARCHAR(100) | NO | - | Tên đối tượng |
| `ti_le_giam_hoc_phi` | DECIMAL(5,2) | NO | - | Tỷ lệ giảm HP (0-100%) |
| `do_uu_tien` | INTEGER | NO | - | Độ ưu tiên (nhỏ = cao) |
| `mo_ta` | VARCHAR(300) | YES | - | Mô tả |
| `trang_thai` | BOOLEAN | YES | TRUE | Trạng thái |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |

**Khóa chính:** `ma_doi_tuong`

**Ràng buộc:**
- `ti_le_giam_hoc_phi` phải >= 0 và <= 100

**Ví dụ dữ liệu:**
```sql
| ma_doi_tuong | ten_doi_tuong    | ti_le_giam_hoc_phi | do_uu_tien |
|--------------|------------------|-------------------|------------|
| DT01         | Con liệt sĩ      | 100. 00            | 1          |
| DT02         | Con thương binh  | 80.00             | 2          |
| DT03         | Vùng sâu vùng xa | 50.00             | 3          |
```

---

### 2.4. BẢNG `doi_tuong_sinh_vien` - Đối tượng của Sinh viên

**Mô tả:** Liên kết sinh viên với các đối tượng ưu tiên (QĐ1:  một SV có thể thuộc nhiều đối tượng)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `id` | SERIAL | NO | Auto | **PK** - ID tự tăng |
| `ma_sv` | VARCHAR(15) | NO | - | **FK** → `sinh_vien.ma_sv` |
| `ma_doi_tuong` | VARCHAR(10) | NO | - | **FK** → `doi_tuong.ma_doi_tuong` |
| `file_minh_chung` | VARCHAR(255) | YES | - | File đính kèm minh chứng |
| `ghi_chu` | VARCHAR(200) | YES | - | Ghi chú |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |

**Khóa chính:** `id`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_dtsv_sv` | `ma_sv` | `sinh_vien(ma_sv)` | Sinh viên |
| `fk_dtsv_dt` | `ma_doi_tuong` | `doi_tuong(ma_doi_tuong)` | Đối tượng |

**Ràng buộc UNIQUE:** `(ma_sv, ma_doi_tuong)` - Mỗi SV chỉ gán 1 lần cho mỗi đối tượng

---

### 2.5. BẢNG `khoa` - Khoa

**Mô tả:** Danh sách các khoa trong trường (QĐ1)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `ma_khoa` | VARCHAR(10) | NO | - | **PK** - Mã khoa |
| `ten_khoa` | VARCHAR(100) | NO | - | Tên khoa |
| `ten_viet_tat` | VARCHAR(20) | YES | - | Tên viết tắt |
| `sdt` | VARCHAR(15) | YES | - | Số điện thoại |
| `email` | VARCHAR(100) | YES | - | Email |
| `dia_chi` | VARCHAR(200) | YES | - | Địa chỉ |
| `truong_khoa` | VARCHAR(100) | YES | - | Tên trưởng khoa |
| `trang_thai` | BOOLEAN | YES | TRUE | Trạng thái |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |

**Khóa chính:** `ma_khoa`

---

### 2.6. BẢNG `nganh_hoc` - Ngành học

**Mô tả:** Danh sách ngành học thuộc các khoa (QĐ1:  mỗi khoa có nhiều ngành)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `ma_nganh` | VARCHAR(10) | NO | - | **PK** - Mã ngành |
| `ten_nganh` | VARCHAR(100) | NO | - | Tên ngành |
| `ma_khoa` | VARCHAR(10) | NO | - | **FK** → `khoa.ma_khoa` |
| `so_tin_chi_toi_thieu` | INTEGER | YES | 120 | Số tín chỉ tối thiểu |
| `thoi_gian_dao_tao` | DECIMAL(3,1) | YES | 4 | Thời gian đào tạo (năm) |
| `mo_ta` | VARCHAR(500) | YES | - | Mô tả |
| `trang_thai` | BOOLEAN | YES | TRUE | Trạng thái |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |

**Khóa chính:** `ma_nganh`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_nganh_khoa` | `ma_khoa` | `khoa(ma_khoa)` | Ngành thuộc khoa |

---

### 2.7. BẢNG `sinh_vien` - Sinh viên

**Mô tả:** Thông tin sinh viên (BM1, QĐ1)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `ma_sv` | VARCHAR(15) | NO | - | **PK** - Mã sinh viên |
| `ho_ten` | VARCHAR(100) | NO | - | Họ tên (BM1) |
| `ngay_sinh` | DATE | NO | - | Ngày sinh (BM1) |
| `gioi_tinh` | VARCHAR(5) | NO | - | Giới tính:  'Nam'/'Nữ' (BM1) |
| `cccd` | VARCHAR(20) | YES | - | Số CCCD (UNIQUE) |
| `ma_huyen` | VARCHAR(10) | NO | - | **FK** → `huyen.ma_huyen` (Quê quán - BM1) |
| `ma_nganh` | VARCHAR(10) | NO | - | **FK** → `nganh_hoc.ma_nganh` (Ngành học - BM1) |
| `dia_chi_lien_he` | VARCHAR(200) | YES | - | Địa chỉ liên hệ |
| `sdt` | VARCHAR(15) | YES | - | Số điện thoại |
| `email` | VARCHAR(100) | YES | - | Email |
| `anh_dai_dien` | VARCHAR(255) | YES | - | Đường dẫn ảnh |
| `ho_ten_cha` | VARCHAR(100) | YES | - | Họ tên cha |
| `sdt_cha` | VARCHAR(15) | YES | - | SĐT cha |
| `ho_ten_me` | VARCHAR(100) | YES | - | Họ tên mẹ |
| `sdt_me` | VARCHAR(15) | YES | - | SĐT mẹ |
| `ngay_nhap_hoc` | DATE | YES | CURRENT_DATE | Ngày nhập học |
| `trang_thai` | VARCHAR(30) | YES | 'Đang học' | Trạng thái |
| `ghi_chu` | VARCHAR(300) | YES | - | Ghi chú |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |
| `ngay_cap_nhat` | TIMESTAMP | YES | - | Ngày cập nhật |

**Khóa chính:** `ma_sv`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_sv_huyen` | `ma_huyen` | `huyen(ma_huyen)` | Quê quán (QĐ1) |
| `fk_sv_nganh` | `ma_nganh` | `nganh_hoc(ma_nganh)` | Ngành học (QĐ1) |

**Ràng buộc:**
- `gioi_tinh` IN ('Nam', 'Nữ')
- `trang_thai` IN ('Đang học', 'Bảo lưu', 'Nghỉ học', 'Tốt nghiệp')
- `cccd` UNIQUE

---

### 2.8. BẢNG `mon_hoc` - Môn học

**Mô tả:** Danh sách môn học (BM2, QĐ2)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `ma_mon_hoc` | VARCHAR(15) | NO | - | **PK** - Mã môn học (BM2) |
| `ten_mon_hoc` | VARCHAR(150) | NO | - | Tên môn học (BM2) |
| `loai_mon` | VARCHAR(5) | NO | - | Loại môn:  'LT'/'TH' (BM2, QĐ2) |
| `so_tiet` | INTEGER | NO | - | Số tiết (BM2, QĐ2) |
| `so_tin_chi` | INTEGER | - | **Computed** | Số tín chỉ (QĐ2) |
| `mo_ta` | VARCHAR(500) | YES | - | Mô tả |
| `trang_thai` | BOOLEAN | YES | TRUE | Trạng thái |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |

**Khóa chính:** `ma_mon_hoc`

**Cột tính toán (Computed Column):**
```sql
so_tin_chi = CASE 
    WHEN loai_mon = 'LT' THEN so_tiet / 15   -- QĐ2: LT = số tiết/15
    WHEN loai_mon = 'TH' THEN so_tiet / 30   -- QĐ2: TH = số tiết/30
    ELSE 0 
END
```

**Ràng buộc:**
- `loai_mon` IN ('LT', 'TH')
- `so_tiet` > 0

---

### 2.9. BẢNG `chuong_trinh_hoc` - Chương trình học

**Mô tả:** Chương trình đào tạo theo ngành (BM3, QĐ3)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `id` | SERIAL | NO | Auto | **PK** - ID tự tăng |
| `ma_nganh` | VARCHAR(10) | NO | - | **FK** → `nganh_hoc.ma_nganh` (BM3) |
| `ma_mon_hoc` | VARCHAR(15) | NO | - | **FK** → `mon_hoc.ma_mon_hoc` (BM3) |
| `hoc_ky_du_kien` | INTEGER | NO | - | Học kỳ dự kiến (BM3) |
| `bat_buoc` | BOOLEAN | YES | TRUE | Môn bắt buộc |
| `ghi_chu` | VARCHAR(200) | YES | - | Ghi chú (BM3) |
| `trang_thai` | BOOLEAN | YES | TRUE | Trạng thái |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |

**Khóa chính:** `id`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_cth_nganh` | `ma_nganh` | `nganh_hoc(ma_nganh)` | Thuộc ngành |
| `fk_cth_mon` | `ma_mon_hoc` | `mon_hoc(ma_mon_hoc)` | Môn học |

**Ràng buộc:**
- UNIQUE `(ma_nganh, ma_mon_hoc)` - Mỗi môn chỉ xuất hiện 1 lần trong 1 ngành
- `hoc_ky_du_kien` >= 1 AND <= 10

---

### 2.10. BẢNG `nam_hoc` - Năm học

**Mô tả:** Danh sách năm học (BM4)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `ma_nam_hoc` | VARCHAR(15) | NO | - | **PK** - Mã năm học (VD: 2024-2025) |
| `ten_nam_hoc` | VARCHAR(50) | NO | - | Tên năm học (BM4) |
| `nam_bat_dau` | INTEGER | NO | - | Năm bắt đầu |
| `nam_ket_thuc` | INTEGER | NO | - | Năm kết thúc |
| `trang_thai` | BOOLEAN | YES | TRUE | Trạng thái |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |

**Khóa chính:** `ma_nam_hoc`

---

### 2.11. BẢNG `hoc_ky` - Học kỳ

**Mô tả:** Danh sách học kỳ (BM4, QĐ4, QĐ6)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `ma_hoc_ky` | VARCHAR(15) | NO | - | **PK** - Mã học kỳ |
| `ten_hoc_ky` | VARCHAR(50) | NO | - | Tên:  HK I, HK II, HK Hè (BM4) |
| `ma_nam_hoc` | VARCHAR(15) | NO | - | **FK** → `nam_hoc.ma_nam_hoc` |
| `loai_hoc_ky` | VARCHAR(20) | YES | 'Chính' | Loại:  'Chính'/'Hè' (QĐ4) |
| `thu_tu` | INTEGER | YES | 1 | Thứ tự trong năm (1, 2, 3) |
| `ngay_bat_dau` | DATE | YES | - | Ngày bắt đầu |
| `ngay_ket_thuc` | DATE | YES | - | Ngày kết thúc |
| `ngay_bat_dau_dang_ky` | TIMESTAMP | YES | - | Bắt đầu đăng ký |
| `ngay_ket_thuc_dang_ky` | TIMESTAMP | YES | - | Kết thúc đăng ký |
| `han_dong_hoc_phi` | DATE | YES | - | Hạn đóng HP (QĐ6) |
| `trang_thai` | VARCHAR(20) | YES | 'Sắp diễn ra' | Trạng thái |
| `ghi_chu` | VARCHAR(300) | YES | - | Ghi chú |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |

**Khóa chính:** `ma_hoc_ky`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_hk_namhoc` | `ma_nam_hoc` | `nam_hoc(ma_nam_hoc)` | Thuộc năm học |

**Ràng buộc:**
- `loai_hoc_ky` IN ('Chính', 'Hè')
- `trang_thai` IN ('Sắp diễn ra', 'Đang diễn ra', 'Đã kết thúc')

---

### 2.12. BẢNG `mon_hoc_mo` - Môn học mở trong học kỳ

**Mô tả:** Danh sách môn học mở đăng ký trong học kỳ (BM4, QĐ4, QĐ5)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `id` | SERIAL | NO | Auto | **PK** - ID tự tăng |
| `ma_hoc_ky` | VARCHAR(15) | NO | - | **FK** → `hoc_ky.ma_hoc_ky` (BM4) |
| `ma_mon_hoc` | VARCHAR(15) | NO | - | **FK** → `mon_hoc.ma_mon_hoc` (BM4) |
| `so_luong_toi_da` | INTEGER | YES | 100 | Số lượng SV tối đa |
| `so_luong_da_dang_ky` | INTEGER | YES | 0 | Số SV đã đăng ký |
| `ghi_chu` | VARCHAR(200) | YES | - | Ghi chú |
| `trang_thai` | BOOLEAN | YES | TRUE | Trạng thái |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |

**Khóa chính:** `id`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_mhm_hocky` | `ma_hoc_ky` | `hoc_ky(ma_hoc_ky)` | Học kỳ |
| `fk_mhm_mon` | `ma_mon_hoc` | `mon_hoc(ma_mon_hoc)` | Môn học |

**Ràng buộc:**
- UNIQUE `(ma_hoc_ky, ma_mon_hoc)` - Mỗi môn chỉ mở 1 lần trong 1 học kỳ

---

### 2.13. BẢNG `phieu_dang_ky` - Phiếu đăng ký học phần

**Mô tả:** Phiếu đăng ký học phần của sinh viên (BM5, QĐ5, QĐ7)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `so_phieu` | SERIAL | NO | Auto | **PK** - Số phiếu (BM5) |
| `ma_sv` | VARCHAR(15) | NO | - | **FK** → `sinh_vien.ma_sv` (BM5) |
| `ma_hoc_ky` | VARCHAR(15) | NO | - | **FK** → `hoc_ky.ma_hoc_ky` (BM5) |
| `ngay_lap` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày lập (BM5) |
| `tong_tin_chi` | INTEGER | YES | 0 | Tổng tín chỉ đăng ký |
| `tong_tien_dang_ky` | DECIMAL(15,0) | YES | 0 | Tổng tiền đăng ký (BM7) |
| `ti_le_giam` | DECIMAL(5,2) | YES | 0 | Tỷ lệ giảm HP (QĐ1) |
| `tien_mien_giam` | DECIMAL(15,0) | YES | 0 | Tiền được miễn giảm |
| `tong_tien_phai_dong` | DECIMAL(15,0) | YES | 0 | Tổng tiền phải đóng (BM7) |
| `trang_thai` | VARCHAR(30) | YES | 'Đã đăng ký' | Trạng thái |
| `ghi_chu` | VARCHAR(300) | YES | - | Ghi chú |
| `ngay_cap_nhat` | TIMESTAMP | YES | - | Ngày cập nhật |

**Khóa chính:** `so_phieu`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_pdk_sv` | `ma_sv` | `sinh_vien(ma_sv)` | Sinh viên |
| `fk_pdk_hk` | `ma_hoc_ky` | `hoc_ky(ma_hoc_ky)` | Học kỳ |

**Ràng buộc:**
- UNIQUE `(ma_sv, ma_hoc_ky)` - Mỗi SV chỉ có 1 phiếu đăng ký/học kỳ
- `trang_thai` IN ('Đã đăng ký', 'Đã hủy')

**Công thức tính toán:**
```
tong_tien_dang_ky = SUM(chi_tiet_dang_ky. thanh_tien)
tien_mien_giam = tong_tien_dang_ky * ti_le_giam / 100
tong_tien_phai_dong = tong_tien_dang_ky - tien_mien_giam  (QĐ7)
```

---

### 2.14. BẢNG `chi_tiet_dang_ky` - Chi tiết đăng ký

**Mô tả:** Chi tiết các môn học đăng ký trong phiếu (BM5, QĐ5)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `id` | SERIAL | NO | Auto | **PK** - ID tự tăng |
| `so_phieu` | INTEGER | NO | - | **FK** → `phieu_dang_ky.so_phieu` |
| `ma_mon_hoc` | VARCHAR(15) | NO | - | **FK** → `mon_hoc.ma_mon_hoc` (BM5) |
| `so_tin_chi` | INTEGER | NO | - | Số tín chỉ (BM5) |
| `loai_mon` | VARCHAR(5) | NO | - | Loại môn: 'LT'/'TH' |
| `don_gia` | DECIMAL(12,0) | NO | - | Đơn giá/tín chỉ (QĐ5) |
| `thanh_tien` | DECIMAL(15,0) | NO | - | Thành tiền = số TC × đơn giá |
| `trang_thai` | VARCHAR(30) | YES | 'Đã đăng ký' | Trạng thái |
| `ngay_dang_ky` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày đăng ký |
| `ngay_huy` | TIMESTAMP | YES | - | Ngày hủy |
| `ly_do_huy` | VARCHAR(200) | YES | - | Lý do hủy |

**Khóa chính:** `id`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_ctdk_phieu` | `so_phieu` | `phieu_dang_ky(so_phieu)` | Phiếu đăng ký |
| `fk_ctdk_mon` | `ma_mon_hoc` | `mon_hoc(ma_mon_hoc)` | Môn học |

**Ràng buộc:**
- UNIQUE `(so_phieu, ma_mon_hoc)` - Mỗi môn chỉ đăng ký 1 lần/phiếu
- `trang_thai` IN ('Đã đăng ký', 'Đã hủy')

**Đơn giá theo QĐ5:**
```
LT (Lý thuyết): 27,000 đ/tín chỉ
TH (Thực hành): 37,000 đ/tín chỉ
```

---

### 2.15. BẢNG `phieu_thu_hoc_phi` - Phiếu thu học phí

**Mô tả:** Phiếu thu học phí (BM6, QĐ6: SV có thể đóng nhiều lần)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `so_phieu_thu` | SERIAL | NO | Auto | **PK** - Số phiếu thu (BM6) |
| `so_phieu_dang_ky` | INTEGER | NO | - | **FK** → `phieu_dang_ky.so_phieu` |
| `ma_sv` | VARCHAR(15) | NO | - | **FK** → `sinh_vien.ma_sv` (BM6) |
| `ngay_lap` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày lập (BM6) |
| `so_tien_thu` | DECIMAL(15,0) | NO | - | Số tiền thu (BM6) |
| `hinh_thuc_thu` | VARCHAR(50) | YES | 'Tiền mặt' | Hình thức thanh toán |
| `ma_giao_dich` | VARCHAR(100) | YES | - | Mã giao dịch (nếu CK) |
| `nguoi_thu` | VARCHAR(100) | YES | - | Người thu |
| `ghi_chu` | VARCHAR(300) | YES | - | Ghi chú |
| `trang_thai` | VARCHAR(20) | YES | 'Thành công' | Trạng thái |

**Khóa chính:** `so_phieu_thu`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_pthp_pdk` | `so_phieu_dang_ky` | `phieu_dang_ky(so_phieu)` | Phiếu đăng ký |
| `fk_pthp_sv` | `ma_sv` | `sinh_vien(ma_sv)` | Sinh viên |

**Ràng buộc:**
- `so_tien_thu` > 0
- `hinh_thuc_thu` IN ('Tiền mặt', 'Chuyển khoản', 'Thẻ', 'Ví điện tử')
- `trang_thai` IN ('Thành công', 'Đã hủy')

**Lưu ý QĐ6:** Một phiếu đăng ký có thể có nhiều phiếu thu (đóng nhiều lần)

---

### 2.16. BẢNG `don_gia_tin_chi` - Đơn giá tín chỉ

**Mô tả:** Cấu hình đơn giá tín chỉ theo loại môn (QĐ5)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `id` | SERIAL | NO | Auto | **PK** - ID |
| `loai_mon` | VARCHAR(5) | NO | - | Loại môn: 'LT'/'TH' |
| `don_gia` | DECIMAL(12,0) | NO | - | Đơn giá/tín chỉ |
| `ma_hoc_ky` | VARCHAR(15) | YES | - | **FK** → `hoc_ky.ma_hoc_ky` |
| `ngay_ap_dung` | DATE | YES | CURRENT_DATE | Ngày áp dụng |
| `trang_thai` | BOOLEAN | YES | TRUE | Trạng thái |
| `ghi_chu` | VARCHAR(200) | YES | - | Ghi chú |

**Khóa chính:** `id`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_dgtc_hk` | `ma_hoc_ky` | `hoc_ky(ma_hoc_ky)` | Học kỳ (NULL = áp dụng chung) |

**Giá trị mặc định theo QĐ5:**
```sql
| loai_mon | don_gia |
|----------|---------|
| LT       | 27000   |
| TH       | 37000   |
```

---

### 2.17. BẢNG `vai_tro` - Vai trò

**Mô tả:** Danh sách vai trò người dùng (Admin, Sinh viên)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `ma_vai_tro` | SERIAL | NO | Auto | **PK** - Mã vai trò |
| `ten_vai_tro` | VARCHAR(50) | NO | - | Tên vai trò (UNIQUE) |
| `mo_ta` | VARCHAR(200) | YES | - | Mô tả |
| `trang_thai` | BOOLEAN | YES | TRUE | Trạng thái |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |

**Khóa chính:** `ma_vai_tro`

---

### 2.18. BẢNG `quyen` - Quyền

**Mô tả:** Danh sách các quyền trong hệ thống

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `ma_quyen` | SERIAL | NO | Auto | **PK** - Mã quyền |
| `ten_quyen` | VARCHAR(100) | NO | - | Tên quyền (UNIQUE) |
| `mo_ta` | VARCHAR(200) | YES | - | Mô tả |
| `nhom_quyen` | VARCHAR(50) | YES | - | Nhóm quyền |

**Khóa chính:** `ma_quyen`

---

### 2.19. BẢNG `phan_quyen` - Phân quyền

**Mô tả:** Gán quyền cho vai trò

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `ma_vai_tro` | INTEGER | NO | - | **PK, FK** → `vai_tro.ma_vai_tro` |
| `ma_quyen` | INTEGER | NO | - | **PK, FK** → `quyen.ma_quyen` |

**Khóa chính:** `(ma_vai_tro, ma_quyen)` - Composite PK

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_pq_vt` | `ma_vai_tro` | `vai_tro(ma_vai_tro)` | Vai trò |
| `fk_pq_q` | `ma_quyen` | `quyen(ma_quyen)` | Quyền |

---

### 2.20. BẢNG `tai_khoan` - Tài khoản

**Mô tả:** Tài khoản đăng nhập hệ thống

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `ma_tai_khoan` | SERIAL | NO | Auto | **PK** - Mã tài khoản |
| `ten_dang_nhap` | VARCHAR(50) | NO | - | Tên đăng nhập (UNIQUE) |
| `mat_khau` | VARCHAR(255) | NO | - | Mật khẩu (BCrypt hash) |
| `ma_vai_tro` | INTEGER | NO | - | **FK** → `vai_tro.ma_vai_tro` |
| `ma_sv` | VARCHAR(15) | YES | - | **FK** → `sinh_vien.ma_sv` (UNIQUE) |
| `ho_ten` | VARCHAR(100) | YES | - | Họ tên (nếu là Admin) |
| `email` | VARCHAR(100) | YES | - | Email |
| `sdt` | VARCHAR(15) | YES | - | Số điện thoại |
| `anh_dai_dien` | VARCHAR(255) | YES | - | Ảnh đại diện |
| `lan_dang_nhap_cuoi` | TIMESTAMP | YES | - | Lần đăng nhập cuối |
| `refresh_token` | VARCHAR(500) | YES | - | Refresh token (JWT) |
| `trang_thai` | BOOLEAN | YES | TRUE | Trạng thái |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |
| `ngay_cap_nhat` | TIMESTAMP | YES | - | Ngày cập nhật |

**Khóa chính:** `ma_tai_khoan`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_tk_vt` | `ma_vai_tro` | `vai_tro(ma_vai_tro)` | Vai trò |
| `fk_tk_sv` | `ma_sv` | `sinh_vien(ma_sv)` | Sinh viên (nếu là SV) |

**Ràng buộc:**
- `ten_dang_nhap` UNIQUE
- `ma_sv` UNIQUE (mỗi SV chỉ có 1 tài khoản)

---

### 2.21. BẢNG `lich_su_dang_nhap` - Lịch sử đăng nhập

**Mô tả:** Ghi log đăng nhập hệ thống

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `id` | BIGSERIAL | NO | Auto | **PK** - ID |
| `ma_tai_khoan` | INTEGER | NO | - | **FK** → `tai_khoan.ma_tai_khoan` |
| `thoi_gian` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Thời gian đăng nhập |
| `ip_address` | VARCHAR(50) | YES | - | Địa chỉ IP |
| `user_agent` | VARCHAR(500) | YES | - | User Agent |
| `thanh_cong` | BOOLEAN | YES | TRUE | Đăng nhập thành công |
| `ghi_chu` | VARCHAR(200) | YES | - | Ghi chú |

**Khóa chính:** `id`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_lsdn_tk` | `ma_tai_khoan` | `tai_khoan(ma_tai_khoan)` | Tài khoản |

---

### 2.22. BẢNG `thong_bao` - Thông báo chung

**Mô tả:** Thông báo gửi đến người dùng

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `ma_thong_bao` | SERIAL | NO | Auto | **PK** - Mã thông báo |
| `tieu_de` | VARCHAR(200) | NO | - | Tiêu đề |
| `noi_dung` | TEXT | NO | - | Nội dung |
| `loai_thong_bao` | VARCHAR(50) | YES | - | Loại thông báo |
| `doi_tuong` | VARCHAR(30) | YES | 'Tất cả' | Đối tượng nhận |
| `ghim_top` | BOOLEAN | YES | FALSE | Ghim lên đầu |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |
| `ngay_het_han` | TIMESTAMP | YES | - | Ngày hết hạn |
| `nguoi_tao` | INTEGER | YES | - | **FK** → `tai_khoan.ma_tai_khoan` |
| `trang_thai` | BOOLEAN | YES | TRUE | Trạng thái |

**Khóa chính:** `ma_thong_bao`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_tb_nguoitao` | `nguoi_tao` | `tai_khoan(ma_tai_khoan)` | Người tạo |

---

### 2.23. BẢNG `thong_bao_ca_nhan` - Thông báo cá nhân

**Mô tả:** Thông báo gửi đến từng người dùng

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `id` | BIGSERIAL | NO | Auto | **PK** - ID |
| `ma_tai_khoan` | INTEGER | NO | - | **FK** → `tai_khoan.ma_tai_khoan` |
| `tieu_de` | VARCHAR(200) | NO | - | Tiêu đề |
| `noi_dung` | TEXT | YES | - | Nội dung |
| `loai_thong_bao` | VARCHAR(50) | YES | - | Loại thông báo |
| `duong_dan` | VARCHAR(255) | YES | - | Link đến trang liên quan |
| `da_doc` | BOOLEAN | YES | FALSE | Đã đọc |
| `ngay_doc` | TIMESTAMP | YES | - | Ngày đọc |
| `ngay_tao` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Ngày tạo |

**Khóa chính:** `id`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_tbcn_tk` | `ma_tai_khoan` | `tai_khoan(ma_tai_khoan)` | Tài khoản nhận |

---

### 2.24. BẢNG `log_hoat_dong` - Log hoạt động

**Mô tả:** Ghi log các hoạt động trong hệ thống (Audit Trail)

**Cấu trúc:**

| Tên cột | Kiểu dữ liệu | Null | Mặc định | Mô tả |
|---------|--------------|------|----------|-------|
| `id` | BIGSERIAL | NO | Auto | **PK** - ID |
| `thoi_gian` | TIMESTAMP | YES | CURRENT_TIMESTAMP | Thời gian |
| `ma_tai_khoan` | INTEGER | YES | - | **FK** → `tai_khoan.ma_tai_khoan` |
| `hanh_dong` | VARCHAR(100) | NO | - | Hành động (CREATE, UPDATE, DELETE.. .) |
| `doi_tuong` | VARCHAR(50) | YES | - | Đối tượng (tên bảng) |
| `ma_doi_tuong` | VARCHAR(50) | YES | - | Mã đối tượng |
| `mo_ta` | VARCHAR(500) | YES | - | Mô tả |
| `du_lieu_cu` | TEXT | YES | - | Dữ liệu cũ (JSON) |
| `du_lieu_moi` | TEXT | YES | - | Dữ liệu mới (JSON) |
| `ip_address` | VARCHAR(50) | YES | - | Địa chỉ IP |

**Khóa chính:** `id`

**Khóa ngoại:**

| Tên FK | Cột | Tham chiếu | Mô tả |
|--------|-----|------------|-------|
| `fk_log_tk` | `ma_tai_khoan` | `tai_khoan(ma_tai_khoan)` | Người thực hiện |

---

## 3. SƠ ĐỒ QUAN HỆ (ERD)

### 3.1. Sơ đồ tổng quan

```
                                    ┌─────────────┐
                                    │    tinh     │
                                    └──────┬──────┘
                                           │ 1
                                           │
                                           │ n
                                    ┌──────┴──────┐
                                    │    huyen    │
                                    └──────┬──────┘
                                           │ 1
                                           │
            ┌─────────────┐                │              ┌─────────────┐
            │    khoa     │                │              │  doi_tuong  │
            └──────┬──────┘                │              └──────┬──────┘
                   │ 1                     │                     │ 1
                   │                       │                     │
                   │ n                     │                     │ n
            ┌──────┴──────┐                │       ┌─────────────┴─────────────┐
            │  nganh_hoc  │                │       │   doi_tuong_sinh_vien     │
            └──────┬──────┘                │       └─────────────┬─────────────┘
                   │ 1                     │                     │ n
                   │                       │                     │
                   │ n            n        │        1            │
            ┌──────┴──────────────┴────────┴────────┴────────────┘
            │                     sinh_vien                      │
            └────────────────────────┬───────────────────────────┘
                                     │ 1
                                     │
                   ┌─────────────────┼─────────────────┐
                   │                 │                 │
                   │ n               │ n               │ 1
            ┌──────┴──────┐   ┌──────┴──────┐   ┌──────┴──────┐
            │ phieu_dang_ky│   │phieu_thu_hp │   │  tai_khoan  │
            └──────┬──────┘   └─────────────┘   └─────────────┘
                   │ 1
                   │
                   │ n
            ┌──────┴──────┐
            │chi_tiet_dk  │
            └──────┬──────┘
                   │ n
                   │
                   │ 1
            ┌──────┴──────┐         ┌─────────────┐
            │  mon_hoc    │◄────────┤ mon_hoc_mo  │
            └─────────────┘         └──────┬──────┘
                                           │ n
                                           │
                                           │ 1
                                    ┌──────┴──────┐
                                    │   hoc_ky    │
                                    └──────┬──────┘
                                           │ n
                                           │
                                           │ 1
                                    ┌──────┴──────┐
                                    │   nam_hoc   │
                                    └─────────────┘
```

### 3.2. Chi tiết các mối quan hệ

| STT | Bảng cha | Bảng con | Quan hệ | Mô tả |
|-----|----------|----------|---------|-------|
| 1 | `tinh` | `huyen` | 1 - n | Mỗi tỉnh có nhiều huyện |
| 2 | `huyen` | `sinh_vien` | 1 - n | Mỗi huyện có nhiều SV (quê quán) |
| 3 | `khoa` | `nganh_hoc` | 1 - n | Mỗi khoa có nhiều ngành |
| 4 | `nganh_hoc` | `sinh_vien` | 1 - n | Mỗi ngành có nhiều SV |
| 5 | `nganh_hoc` | `chuong_trinh_hoc` | 1 - n | Mỗi ngành có nhiều môn trong CTĐT |
| 6 | `doi_tuong` | `doi_tuong_sinh_vien` | 1 - n | Mỗi đối tượng gán cho nhiều SV |
| 7 | `sinh_vien` | `doi_tuong_sinh_vien` | 1 - n | Mỗi SV có thể thuộc nhiều đối tượng |
| 8 | `sinh_vien` | `phieu_dang_ky` | 1 - n | Mỗi SV có nhiều phiếu ĐK (qua các HK) |
| 9 | `sinh_vien` | `phieu_thu_hoc_phi` | 1 - n | Mỗi SV có nhiều phiếu thu |
| 10 | `sinh_vien` | `tai_khoan` | 1 - 1 | Mỗi SV có 1 tài khoản |
| 11 | `nam_hoc` | `hoc_ky` | 1 - n | Mỗi năm học có nhiều học kỳ |
| 12 | `hoc_ky` | `mon_hoc_mo` | 1 - n | Mỗi HK mở nhiều môn |
| 13 | `hoc_ky` | `phieu_dang_ky` | 1 - n | Mỗi HK có nhiều phiếu ĐK |
| 14 | `mon_hoc` | `mon_hoc_mo` | 1 - n | Mỗi môn mở ở nhiều HK |
| 15 | `mon_hoc` | `chuong_trinh_hoc` | 1 - n | Mỗi môn thuộc nhiều CTĐT |
| 16 | `mon_hoc` | `chi_tiet_dang_ky` | 1 - n | Mỗi môn được ĐK nhiều lần |
| 17 | `phieu_dang_ky` | `chi_tiet_dang_ky` | 1 - n | Mỗi phiếu ĐK có nhiều chi tiết |
| 18 | `phieu_dang_ky` | `phieu_thu_hoc_phi` | 1 - n | Mỗi phiếu ĐK có nhiều phiếu thu (QĐ6) |
| 19 | `vai_tro` | `tai_khoan` | 1 - n | Mỗi vai trò gán cho nhiều TK |
| 20 | `vai_tro` | `phan_quyen` | 1 - n | Mỗi vai trò có nhiều quyền |
| 21 | `quyen` | `phan_quyen` | 1 - n | Mỗi quyền gán cho nhiều vai trò |
| 22 | `tai_khoan` | `lich_su_dang_nhap` | 1 - n | Mỗi TK có nhiều lịch sử ĐN |
| 23 | `tai_khoan` | `thong_bao_ca_nhan` | 1 - n | Mỗi TK nhận nhiều thông báo |
| 24 | `tai_khoan` | `log_hoat_dong` | 1 - n | Mỗi TK có nhiều log |

---
## 4. TỔNG HỢP KHÓA NGOẠI (Tiếp theo)

| STT | Bảng | Tên FK | Cột | Tham chiếu | ON DELETE | ON UPDATE |
|-----|------|--------|-----|------------|-----------|-----------|
| 1 | `huyen` | `fk_huyen_tinh` | `ma_tinh` | `tinh(ma_tinh)` | RESTRICT | CASCADE |
| 2 | `nganh_hoc` | `fk_nganh_khoa` | `ma_khoa` | `khoa(ma_khoa)` | RESTRICT | CASCADE |
| 3 | `sinh_vien` | `fk_sv_huyen` | `ma_huyen` | `huyen(ma_huyen)` | RESTRICT | CASCADE |
| 4 | `sinh_vien` | `fk_sv_nganh` | `ma_nganh` | `nganh_hoc(ma_nganh)` | RESTRICT | CASCADE |
| 5 | `doi_tuong_sinh_vien` | `fk_dtsv_sv` | `ma_sv` | `sinh_vien(ma_sv)` | CASCADE | CASCADE |
| 6 | `doi_tuong_sinh_vien` | `fk_dtsv_dt` | `ma_doi_tuong` | `doi_tuong(ma_doi_tuong)` | RESTRICT | CASCADE |
| 7 | `chuong_trinh_hoc` | `fk_cth_nganh` | `ma_nganh` | `nganh_hoc(ma_nganh)` | CASCADE | CASCADE |
| 8 | `chuong_trinh_hoc` | `fk_cth_mon` | `ma_mon_hoc` | `mon_hoc(ma_mon_hoc)` | CASCADE | CASCADE |
| 9 | `hoc_ky` | `fk_hk_namhoc` | `ma_nam_hoc` | `nam_hoc(ma_nam_hoc)` | RESTRICT | CASCADE |
| 10 | `mon_hoc_mo` | `fk_mhm_hocky` | `ma_hoc_ky` | `hoc_ky(ma_hoc_ky)` | CASCADE | CASCADE |
| 11 | `mon_hoc_mo` | `fk_mhm_mon` | `ma_mon_hoc` | `mon_hoc(ma_mon_hoc)` | CASCADE | CASCADE |
| 12 | `phieu_dang_ky` | `fk_pdk_sv` | `ma_sv` | `sinh_vien(ma_sv)` | RESTRICT | CASCADE |
| 13 | `phieu_dang_ky` | `fk_pdk_hk` | `ma_hoc_ky` | `hoc_ky(ma_hoc_ky)` | RESTRICT | CASCADE |
| 14 | `chi_tiet_dang_ky` | `fk_ctdk_phieu` | `so_phieu` | `phieu_dang_ky(so_phieu)` | CASCADE | CASCADE |
| 15 | `chi_tiet_dang_ky` | `fk_ctdk_mon` | `ma_mon_hoc` | `mon_hoc(ma_mon_hoc)` | RESTRICT | CASCADE |
| 16 | `phieu_thu_hoc_phi` | `fk_pthp_pdk` | `so_phieu_dang_ky` | `phieu_dang_ky(so_phieu)` | RESTRICT | CASCADE |
| 17 | `phieu_thu_hoc_phi` | `fk_pthp_sv` | `ma_sv` | `sinh_vien(ma_sv)` | RESTRICT | CASCADE |
| 18 | `don_gia_tin_chi` | `fk_dgtc_hk` | `ma_hoc_ky` | `hoc_ky(ma_hoc_ky)` | SET NULL | CASCADE |
| 19 | `phan_quyen` | `fk_pq_vt` | `ma_vai_tro` | `vai_tro(ma_vai_tro)` | CASCADE | CASCADE |
| 20 | `phan_quyen` | `fk_pq_q` | `ma_quyen` | `quyen(ma_quyen)` | CASCADE | CASCADE |
| 21 | `tai_khoan` | `fk_tk_vt` | `ma_vai_tro` | `vai_tro(ma_vai_tro)` | RESTRICT | CASCADE |
| 22 | `tai_khoan` | `fk_tk_sv` | `ma_sv` | `sinh_vien(ma_sv)` | SET NULL | CASCADE |
| 23 | `lich_su_dang_nhap` | `fk_lsdn_tk` | `ma_tai_khoan` | `tai_khoan(ma_tai_khoan)` | CASCADE | CASCADE |
| 24 | `thong_bao` | `fk_tb_nguoitao` | `nguoi_tao` | `tai_khoan(ma_tai_khoan)` | SET NULL | CASCADE |
| 25 | `thong_bao_ca_nhan` | `fk_tbcn_tk` | `ma_tai_khoan` | `tai_khoan(ma_tai_khoan)` | CASCADE | CASCADE |
| 26 | `log_hoat_dong` | `fk_log_tk` | `ma_tai_khoan` | `tai_khoan(ma_tai_khoan)` | SET NULL | CASCADE |

---

## 5. TỔNG HỢP RÀNG BUỘC (CONSTRAINTS)

### 5.1. Primary Keys (Khóa chính)

| STT | Bảng | Tên PK | Cột | Kiểu |
|-----|------|--------|-----|------|
| 1 | `tinh` | `tinh_pkey` | `ma_tinh` | VARCHAR(10) |
| 2 | `huyen` | `huyen_pkey` | `ma_huyen` | VARCHAR(10) |
| 3 | `doi_tuong` | `doi_tuong_pkey` | `ma_doi_tuong` | VARCHAR(10) |
| 4 | `doi_tuong_sinh_vien` | `doi_tuong_sinh_vien_pkey` | `id` | SERIAL |
| 5 | `khoa` | `khoa_pkey` | `ma_khoa` | VARCHAR(10) |
| 6 | `nganh_hoc` | `nganh_hoc_pkey` | `ma_nganh` | VARCHAR(10) |
| 7 | `sinh_vien` | `sinh_vien_pkey` | `ma_sv` | VARCHAR(15) |
| 8 | `mon_hoc` | `mon_hoc_pkey` | `ma_mon_hoc` | VARCHAR(15) |
| 9 | `chuong_trinh_hoc` | `chuong_trinh_hoc_pkey` | `id` | SERIAL |
| 10 | `nam_hoc` | `nam_hoc_pkey` | `ma_nam_hoc` | VARCHAR(15) |
| 11 | `hoc_ky` | `hoc_ky_pkey` | `ma_hoc_ky` | VARCHAR(15) |
| 12 | `mon_hoc_mo` | `mon_hoc_mo_pkey` | `id` | SERIAL |
| 13 | `phieu_dang_ky` | `phieu_dang_ky_pkey` | `so_phieu` | SERIAL |
| 14 | `chi_tiet_dang_ky` | `chi_tiet_dang_ky_pkey` | `id` | SERIAL |
| 15 | `phieu_thu_hoc_phi` | `phieu_thu_hoc_phi_pkey` | `so_phieu_thu` | SERIAL |
| 16 | `don_gia_tin_chi` | `don_gia_tin_chi_pkey` | `id` | SERIAL |
| 17 | `vai_tro` | `vai_tro_pkey` | `ma_vai_tro` | SERIAL |
| 18 | `quyen` | `quyen_pkey` | `ma_quyen` | SERIAL |
| 19 | `phan_quyen` | `phan_quyen_pkey` | `(ma_vai_tro, ma_quyen)` | Composite |
| 20 | `tai_khoan` | `tai_khoan_pkey` | `ma_tai_khoan` | SERIAL |
| 21 | `lich_su_dang_nhap` | `lich_su_dang_nhap_pkey` | `id` | BIGSERIAL |
| 22 | `thong_bao` | `thong_bao_pkey` | `ma_thong_bao` | SERIAL |
| 23 | `thong_bao_ca_nhan` | `thong_bao_ca_nhan_pkey` | `id` | BIGSERIAL |
| 24 | `log_hoat_dong` | `log_hoat_dong_pkey` | `id` | BIGSERIAL |

### 5.2. Unique Constraints (Ràng buộc duy nhất)

| STT | Bảng | Tên Constraint | Cột | Mô tả |
|-----|------|----------------|-----|-------|
| 1 | `sinh_vien` | `sinh_vien_cccd_key` | `cccd` | Mỗi CCCD là duy nhất |
| 2 | `doi_tuong_sinh_vien` | `uq_dtsv` | `(ma_sv, ma_doi_tuong)` | SV chỉ gán 1 lần/đối tượng |
| 3 | `chuong_trinh_hoc` | `uq_cth` | `(ma_nganh, ma_mon_hoc)` | Môn chỉ xuất hiện 1 lần/ngành |
| 4 | `mon_hoc_mo` | `uq_mhm` | `(ma_hoc_ky, ma_mon_hoc)` | Môn chỉ mở 1 lần/học kỳ |
| 5 | `phieu_dang_ky` | `uq_pdk` | `(ma_sv, ma_hoc_ky)` | SV chỉ có 1 phiếu ĐK/học kỳ |
| 6 | `chi_tiet_dang_ky` | `uq_ctdk` | `(so_phieu, ma_mon_hoc)` | Môn chỉ ĐK 1 lần/phiếu |
| 7 | `vai_tro` | `vai_tro_ten_vai_tro_key` | `ten_vai_tro` | Tên vai trò duy nhất |
| 8 | `quyen` | `quyen_ten_quyen_key` | `ten_quyen` | Tên quyền duy nhất |
| 9 | `tai_khoan` | `tai_khoan_ten_dang_nhap_key` | `ten_dang_nhap` | Tên đăng nhập duy nhất |
| 10 | `tai_khoan` | `tai_khoan_ma_sv_key` | `ma_sv` | Mỗi SV chỉ có 1 tài khoản |

### 5.3. Check Constraints (Ràng buộc kiểm tra)

| STT | Bảng | Cột | Điều kiện | Mô tả |
|-----|------|-----|-----------|-------|
| 1 | `doi_tuong` | `ti_le_giam_hoc_phi` | `>= 0 AND <= 100` | Tỷ lệ giảm 0-100% |
| 2 | `sinh_vien` | `gioi_tinh` | `IN ('Nam', 'Nữ')` | Giới tính hợp lệ |
| 3 | `sinh_vien` | `trang_thai` | `IN ('Đang học', 'Bảo lưu', 'Nghỉ học', 'Tốt nghiệp')` | Trạng thái SV |
| 4 | `mon_hoc` | `loai_mon` | `IN ('LT', 'TH')` | Loại môn:  Lý thuyết/Thực hành |
| 5 | `mon_hoc` | `so_tiet` | `> 0` | Số tiết phải > 0 |
| 6 | `chuong_trinh_hoc` | `hoc_ky_du_kien` | `>= 1 AND <= 10` | Học kỳ dự kiến 1-10 |
| 7 | `hoc_ky` | `loai_hoc_ky` | `IN ('Chính', 'Hè')` | Loại học kỳ |
| 8 | `hoc_ky` | `trang_thai` | `IN ('Sắp diễn ra', 'Đang diễn ra', 'Đã kết thúc')` | Trạng thái HK |
| 9 | `phieu_dang_ky` | `trang_thai` | `IN ('Đã đăng ký', 'Đã hủy')` | Trạng thái phiếu ĐK |
| 10 | `chi_tiet_dang_ky` | `trang_thai` | `IN ('Đã đăng ký', 'Đã hủy')` | Trạng thái chi tiết |
| 11 | `phieu_thu_hoc_phi` | `so_tien_thu` | `> 0` | Số tiền thu > 0 |
| 12 | `phieu_thu_hoc_phi` | `hinh_thuc_thu` | `IN ('Tiền mặt', 'Chuyển khoản', 'Thẻ', 'Ví điện tử')` | Hình thức thanh toán |
| 13 | `phieu_thu_hoc_phi` | `trang_thai` | `IN ('Thành công', 'Đã hủy')` | Trạng thái phiếu thu |
| 14 | `don_gia_tin_chi` | `loai_mon` | `IN ('LT', 'TH')` | Loại môn |
| 15 | `thong_bao` | `doi_tuong` | `IN ('Tất cả', 'Sinh viên', 'Admin')` | Đối tượng nhận TB |

---

## 6. INDEXES (CHỈ MỤC)

| STT | Tên Index | Bảng | Cột | Mục đích |
|-----|-----------|------|-----|----------|
| 1 | `idx_sv_ma_nganh` | `sinh_vien` | `ma_nganh` | Tìm SV theo ngành |
| 2 | `idx_sv_ma_huyen` | `sinh_vien` | `ma_huyen` | Tìm SV theo quê quán |
| 3 | `idx_sv_trang_thai` | `sinh_vien` | `trang_thai` | Lọc SV theo trạng thái |
| 4 | `idx_dtsv_ma_sv` | `doi_tuong_sinh_vien` | `ma_sv` | Tìm đối tượng của SV |
| 5 | `idx_cth_ma_nganh` | `chuong_trinh_hoc` | `ma_nganh` | Tìm CTĐT theo ngành |
| 6 | `idx_mhm_ma_hoc_ky` | `mon_hoc_mo` | `ma_hoc_ky` | Tìm môn mở theo HK |
| 7 | `idx_pdk_ma_sv` | `phieu_dang_ky` | `ma_sv` | Tìm phiếu ĐK theo SV |
| 8 | `idx_pdk_ma_hoc_ky` | `phieu_dang_ky` | `ma_hoc_ky` | Tìm phiếu ĐK theo HK |
| 9 | `idx_ctdk_so_phieu` | `chi_tiet_dang_ky` | `so_phieu` | Tìm chi tiết theo phiếu |
| 10 | `idx_pthp_so_phieu_dk` | `phieu_thu_hoc_phi` | `so_phieu_dang_ky` | Tìm phiếu thu theo phiếu ĐK |
| 11 | `idx_pthp_ma_sv` | `phieu_thu_hoc_phi` | `ma_sv` | Tìm phiếu thu theo SV |
| 12 | `idx_tk_ma_sv` | `tai_khoan` | `ma_sv` | Tìm TK theo SV |
| 13 | `idx_tbcn_ma_tk` | `thong_bao_ca_nhan` | `ma_tai_khoan` | Tìm TB theo TK |
| 14 | `idx_tbcn_da_doc` | `thong_bao_ca_nhan` | `da_doc` | Lọc TB chưa đọc |

---

## 7. VIEWS (KHUNG NHÌN)

### 7.1. Danh sách Views

| STT | Tên View | Mô tả | Biểu mẫu liên quan |
|-----|----------|-------|-------------------|
| 1 | `v_ho_so_sinh_vien` | Hồ sơ sinh viên đầy đủ | BM1 |
| 2 | `v_danh_sach_mon_hoc` | Danh sách môn học | BM2 |
| 3 | `v_chuong_trinh_hoc` | Chương trình học theo ngành | BM3 |
| 4 | `v_mon_hoc_mo` | Danh sách môn học mở | BM4 |
| 5 | `v_phieu_dang_ky` | Phiếu đăng ký học phần chi tiết | BM5 |
| 6 | `v_phieu_thu_hoc_phi` | Phiếu thu học phí | BM6 |
| 7 | `v_tinh_hinh_hoc_phi` | Tình hình đóng học phí | - |
| 8 | `v_bao_cao_sv_chua_dong_hoc_phi` | Báo cáo SV chưa đóng HP | BM7 |

### 7.2. Chi tiết Views

#### View 1: `v_ho_so_sinh_vien` (BM1)

```sql
CREATE OR REPLACE VIEW v_ho_so_sinh_vien AS
SELECT 
    sv.ma_sv,
    sv.ho_ten,
    sv.ngay_sinh,
    sv. gioi_tinh,
    h.ten_huyen || ', ' || t.ten_tinh AS que_quan,
    h.la_vung_sau_vung_xa,
    -- Lấy đối tượng ưu tiên cao nhất (QĐ1)
    (SELECT dt.ten_doi_tuong 
     FROM doi_tuong_sinh_vien dtsv 
     JOIN doi_tuong dt ON dtsv.ma_doi_tuong = dt.ma_doi_tuong
     WHERE dtsv.ma_sv = sv.ma_sv AND dt.trang_thai = TRUE
     ORDER BY dt. do_uu_tien
     LIMIT 1) AS doi_tuong,
    -- Tỷ lệ giảm học phí
    COALESCE((SELECT dt.ti_le_giam_hoc_phi 
     FROM doi_tuong_sinh_vien dtsv 
     JOIN doi_tuong dt ON dtsv.ma_doi_tuong = dt.ma_doi_tuong
     WHERE dtsv.ma_sv = sv.ma_sv AND dt.trang_thai = TRUE
     ORDER BY dt.do_uu_tien
     LIMIT 1), 0) AS ti_le_giam_hoc_phi,
    nh.ma_nganh,
    nh.ten_nganh AS nganh_hoc,
    k.ma_khoa,
    k. ten_khoa,
    sv.trang_thai
FROM sinh_vien sv
JOIN huyen h ON sv.ma_huyen = h.ma_huyen
JOIN tinh t ON h.ma_tinh = t.ma_tinh
JOIN nganh_hoc nh ON sv.ma_nganh = nh. ma_nganh
JOIN khoa k ON nh.ma_khoa = k.ma_khoa;
```

**Cột trả về:**

| Cột | Kiểu | Mô tả |
|-----|------|-------|
| `ma_sv` | VARCHAR(15) | Mã sinh viên |
| `ho_ten` | VARCHAR(100) | Họ tên |
| `ngay_sinh` | DATE | Ngày sinh |
| `gioi_tinh` | VARCHAR(5) | Giới tính |
| `que_quan` | TEXT | Quê quán (Huyện, Tỉnh) |
| `la_vung_sau_vung_xa` | BOOLEAN | Thuộc vùng sâu/xa |
| `doi_tuong` | VARCHAR(100) | Đối tượng ưu tiên |
| `ti_le_giam_hoc_phi` | DECIMAL(5,2) | Tỷ lệ giảm HP |
| `nganh_hoc` | VARCHAR(100) | Tên ngành học |
| `ten_khoa` | VARCHAR(100) | Tên khoa |
| `trang_thai` | VARCHAR(30) | Trạng thái SV |

---

#### View 2: `v_danh_sach_mon_hoc` (BM2)

```sql
CREATE OR REPLACE VIEW v_danh_sach_mon_hoc AS
SELECT 
    ma_mon_hoc,
    ten_mon_hoc,
    CASE loai_mon 
        WHEN 'LT' THEN 'Lý thuyết'
        WHEN 'TH' THEN 'Thực hành'
    END AS loai_mon,
    so_tiet,
    so_tin_chi
FROM mon_hoc
WHERE trang_thai = TRUE;
```

**Cột trả về:**

| Cột | Kiểu | Mô tả |
|-----|------|-------|
| `ma_mon_hoc` | VARCHAR(15) | Mã môn học |
| `ten_mon_hoc` | VARCHAR(150) | Tên môn học |
| `loai_mon` | TEXT | Loại môn (Lý thuyết/Thực hành) |
| `so_tiet` | INTEGER | Số tiết |
| `so_tin_chi` | INTEGER | Số tín chỉ (tính theo QĐ2) |

---

#### View 3: `v_chuong_trinh_hoc` (BM3)

```sql
CREATE OR REPLACE VIEW v_chuong_trinh_hoc AS
SELECT 
    nh.ma_nganh,
    nh.ten_nganh AS nganh_hoc,
    k.ten_khoa AS khoa,
    cth.hoc_ky_du_kien AS hoc_ky,
    mh.ma_mon_hoc,
    mh.ten_mon_hoc AS mon_hoc,
    mh.so_tin_chi,
    cth.ghi_chu
FROM chuong_trinh_hoc cth
JOIN nganh_hoc nh ON cth.ma_nganh = nh.ma_nganh
JOIN khoa k ON nh.ma_khoa = k.ma_khoa
JOIN mon_hoc mh ON cth.ma_mon_hoc = mh.ma_mon_hoc
WHERE cth.trang_thai = TRUE;
```

---

#### View 4: `v_mon_hoc_mo` (BM4)

```sql
CREATE OR REPLACE VIEW v_mon_hoc_mo AS
SELECT 
    hk.ma_hoc_ky,
    hk.ten_hoc_ky AS hoc_ky,
    nh.ma_nam_hoc,
    nh. ten_nam_hoc AS nam_hoc,
    ROW_NUMBER() OVER (PARTITION BY hk.ma_hoc_ky ORDER BY mh.ma_mon_hoc) AS stt,
    mh.ma_mon_hoc,
    mh.ten_mon_hoc AS mon_hoc,
    mh.so_tin_chi,
    mhm.so_luong_toi_da,
    mhm.so_luong_da_dang_ky
FROM mon_hoc_mo mhm
JOIN hoc_ky hk ON mhm.ma_hoc_ky = hk.ma_hoc_ky
JOIN nam_hoc nh ON hk.ma_nam_hoc = nh.ma_nam_hoc
JOIN mon_hoc mh ON mhm.ma_mon_hoc = mh.ma_mon_hoc
WHERE mhm. trang_thai = TRUE;
```

---

#### View 5: `v_phieu_dang_ky` (BM5)

```sql
CREATE OR REPLACE VIEW v_phieu_dang_ky AS
SELECT 
    pdk.so_phieu,
    pdk.ma_sv AS ma_so_sinh_vien,
    sv.ho_ten AS ten_sinh_vien,
    pdk.ngay_lap,
    hk.ten_hoc_ky AS hoc_ky,
    nh.ten_nam_hoc AS nam_hoc,
    ROW_NUMBER() OVER (PARTITION BY pdk.so_phieu ORDER BY ctdk.id) AS stt,
    mh.ten_mon_hoc AS mon_hoc,
    ctdk.so_tin_chi,
    ctdk. don_gia,
    ctdk.thanh_tien,
    pdk.tong_tin_chi,
    pdk. tong_tien_dang_ky,
    pdk.ti_le_giam,
    pdk.tien_mien_giam,
    pdk.tong_tien_phai_dong
FROM phieu_dang_ky pdk
JOIN sinh_vien sv ON pdk.ma_sv = sv.ma_sv
JOIN hoc_ky hk ON pdk.ma_hoc_ky = hk.ma_hoc_ky
JOIN nam_hoc nh ON hk.ma_nam_hoc = nh.ma_nam_hoc
JOIN chi_tiet_dang_ky ctdk ON pdk.so_phieu = ctdk.so_phieu
JOIN mon_hoc mh ON ctdk.ma_mon_hoc = mh.ma_mon_hoc
WHERE ctdk.trang_thai = 'Đã đăng ký' AND pdk.trang_thai = 'Đã đăng ký';
```

---

#### View 6: `v_phieu_thu_hoc_phi` (BM6)

```sql
CREATE OR REPLACE VIEW v_phieu_thu_hoc_phi AS
SELECT 
    pthp.so_phieu_thu AS so_phieu,
    pthp.ngay_lap,
    pthp.ma_sv AS ma_so_sinh_vien,
    sv.ho_ten AS ten_sinh_vien,
    pthp.so_tien_thu,
    pthp.hinh_thuc_thu,
    pthp.nguoi_thu,
    pthp.ghi_chu,
    hk.ten_hoc_ky,
    nh.ten_nam_hoc
FROM phieu_thu_hoc_phi pthp
JOIN sinh_vien sv ON pthp.ma_sv = sv.ma_sv
JOIN phieu_dang_ky pdk ON pthp.so_phieu_dang_ky = pdk. so_phieu
JOIN hoc_ky hk ON pdk.ma_hoc_ky = hk.ma_hoc_ky
JOIN nam_hoc nh ON hk.ma_nam_hoc = nh.ma_nam_hoc
WHERE pthp. trang_thai = 'Thành công';
```

---

#### View 7: `v_tinh_hinh_hoc_phi`

```sql
CREATE OR REPLACE VIEW v_tinh_hinh_hoc_phi AS
SELECT 
    pdk.so_phieu,
    pdk.ma_sv,
    sv.ho_ten,
    hk.ma_hoc_ky,
    hk.ten_hoc_ky,
    nh.ten_nam_hoc,
    pdk.tong_tien_dang_ky AS so_tien_dang_ky,
    pdk.tong_tien_phai_dong AS so_tien_phai_dong,
    COALESCE((SELECT SUM(so_tien_thu) FROM phieu_thu_hoc_phi 
              WHERE so_phieu_dang_ky = pdk. so_phieu 
              AND trang_thai = 'Thành công'), 0) AS so_tien_da_dong,
    pdk.tong_tien_phai_dong - COALESCE((SELECT SUM(so_tien_thu) 
              FROM phieu_thu_hoc_phi 
              WHERE so_phieu_dang_ky = pdk.so_phieu 
              AND trang_thai = 'Thành công'), 0) AS so_tien_con_lai,
    hk.han_dong_hoc_phi
FROM phieu_dang_ky pdk
JOIN sinh_vien sv ON pdk.ma_sv = sv.ma_sv
JOIN hoc_ky hk ON pdk.ma_hoc_ky = hk.ma_hoc_ky
JOIN nam_hoc nh ON hk.ma_nam_hoc = nh.ma_nam_hoc
WHERE pdk.trang_thai = 'Đã đăng ký';
```

---

#### View 8: `v_bao_cao_sv_chua_dong_hoc_phi` (BM7)

```sql
CREATE OR REPLACE VIEW v_bao_cao_sv_chua_dong_hoc_phi AS
SELECT 
    ma_hoc_ky,
    ten_hoc_ky AS hoc_ky,
    ten_nam_hoc AS nam_hoc,
    ROW_NUMBER() OVER (PARTITION BY ma_hoc_ky ORDER BY ma_sv) AS stt,
    ma_sv AS ma_so_sinh_vien,
    ho_ten,
    so_tien_dang_ky,
    so_tien_phai_dong,
    so_tien_con_lai,
    han_dong_hoc_phi,
    CASE 
        WHEN han_dong_hoc_phi < CURRENT_DATE THEN 'Quá hạn'
        ELSE 'Chưa đóng đủ'
    END AS trang_thai
FROM v_tinh_hinh_hoc_phi
WHERE so_tien_con_lai > 0;
```

**Cột trả về theo BM7:**

| Cột | Kiểu | Mô tả BM7 |
|-----|------|-----------|
| `stt` | BIGINT | STT |
| `ma_so_sinh_vien` | VARCHAR(15) | Mã số sinh viên |
| `so_tien_dang_ky` | DECIMAL(15,0) | Số tiền đăng ký |
| `so_tien_phai_dong` | DECIMAL(15,0) | Số tiền phải đóng (sau miễn giảm - QĐ7) |
| `so_tien_con_lai` | DECIMAL(15,0) | Số tiền còn lại |

---

## 8. FUNCTIONS VÀ STORED PROCEDURES

### 8.1. Danh sách Functions

| STT | Tên Function | Mô tả | Tham số | Trả về |
|-----|--------------|-------|---------|--------|
| 1 | `fn_lay_ti_le_giam_hoc_phi` | Lấy tỷ lệ giảm HP của SV (QĐ1) | `p_ma_sv` | `DECIMAL(5,2)` |
| 2 | `fn_lay_don_gia` | Lấy đơn giá tín chỉ (QĐ5) | `p_loai_mon`, `p_ma_hoc_ky` | `DECIMAL(12,0)` |
| 3 | `sp_dang_ky_mon_hoc` | Đăng ký môn học (BM5) | `p_ma_sv`, `p_ma_hoc_ky`, `p_ma_mon_hoc` | `TEXT` |
| 4 | `sp_huy_dang_ky_mon_hoc` | Hủy đăng ký môn học | `p_ma_sv`, `p_ma_hoc_ky`, `p_ma_mon_hoc` | `TEXT` |
| 5 | `sp_thu_hoc_phi` | Thu học phí (BM6, QĐ6) | `p_ma_sv`, `p_ma_hoc_ky`, `p_so_tien_thu`, ...  | `TEXT` |

### 8.2. Chi tiết Functions

#### Function 1: `fn_lay_ti_le_giam_hoc_phi` (QĐ1)

```sql
CREATE OR REPLACE FUNCTION fn_lay_ti_le_giam_hoc_phi(p_ma_sv VARCHAR)
RETURNS DECIMAL(5,2) AS $$
DECLARE
    v_ti_le DECIMAL(5,2) := 0;
    v_la_vsvx BOOLEAN;
BEGIN
    -- Lấy từ đối tượng ưu tiên cao nhất (do_uu_tien nhỏ nhất)
    SELECT dt.ti_le_giam_hoc_phi INTO v_ti_le
    FROM doi_tuong_sinh_vien dtsv
    JOIN doi_tuong dt ON dtsv.ma_doi_tuong = dt.ma_doi_tuong
    WHERE dtsv.ma_sv = p_ma_sv AND dt.trang_thai = TRUE
    ORDER BY dt. do_uu_tien
    LIMIT 1;
    
    -- Nếu chưa có, kiểm tra vùng sâu/vùng xa (QĐ1)
    IF v_ti_le IS NULL OR v_ti_le = 0 THEN
        SELECT h.la_vung_sau_vung_xa INTO v_la_vsvx
        FROM sinh_vien sv
        JOIN huyen h ON sv.ma_huyen = h.ma_huyen
        WHERE sv.ma_sv = p_ma_sv;
        
        IF v_la_vsvx = TRUE THEN
            SELECT ti_le_giam_hoc_phi INTO v_ti_le
            FROM doi_tuong
            WHERE ten_doi_tuong ILIKE '%vùng sâu%' 
               OR ten_doi_tuong ILIKE '%vùng xa%'
            LIMIT 1;
        END IF;
    END IF;
    
    RETURN COALESCE(v_ti_le, 0);
END;
$$ LANGUAGE plpgsql;
```

**Mô tả:** 
- Lấy tỷ lệ giảm học phí của sinh viên dựa trên đối tượng ưu tiên
- Ưu tiên đối tượng có `do_uu_tien` nhỏ nhất (QĐ1)
- Nếu SV ở vùng sâu/vùng xa mà chưa có đối tượng → tự động áp dụng

---

#### Function 2: `fn_lay_don_gia` (QĐ5)

```sql
CREATE OR REPLACE FUNCTION fn_lay_don_gia(
    p_loai_mon VARCHAR, 
    p_ma_hoc_ky VARCHAR DEFAULT NULL
)
RETURNS DECIMAL(12,0) AS $$
DECLARE
    v_don_gia DECIMAL(12,0);
BEGIN
    -- Ưu tiên lấy đơn giá theo học kỳ, nếu không có thì lấy chung
    SELECT don_gia INTO v_don_gia
    FROM don_gia_tin_chi
    WHERE loai_mon = p_loai_mon AND trang_thai = TRUE
      AND (ma_hoc_ky = p_ma_hoc_ky OR ma_hoc_ky IS NULL)
    ORDER BY ma_hoc_ky DESC NULLS LAST
    LIMIT 1;
    
    -- Mặc định theo QĐ5: LT = 27,000đ, TH = 37,000đ
    IF v_don_gia IS NULL THEN
        v_don_gia := CASE p_loai_mon 
            WHEN 'LT' THEN 27000 
            WHEN 'TH' THEN 37000 
            ELSE 0 
        END;
    END IF;
    
    RETURN v_don_gia;
END;
$$ LANGUAGE plpgsql;
```

**Mô tả:**
- Lấy đơn giá 1 tín chỉ theo loại môn (QĐ5)
- LT (Lý thuyết): 27,000 đ/tín chỉ
- TH (Thực hành): 37,000 đ/tín chỉ

---

#### Function 3: `sp_dang_ky_mon_hoc` (BM5, QĐ5)

```sql
CREATE OR REPLACE FUNCTION sp_dang_ky_mon_hoc(
    p_ma_sv VARCHAR,
    p_ma_hoc_ky VARCHAR,
    p_ma_mon_hoc VARCHAR
) RETURNS TEXT AS $$
DECLARE
    v_so_phieu INTEGER;
    v_so_tin_chi INTEGER;
    v_loai_mon VARCHAR(5);
    v_don_gia DECIMAL(12,0);
    v_thanh_tien DECIMAL(15,0);
    v_ti_le_giam DECIMAL(5,2);
BEGIN
    -- QĐ5: Kiểm tra môn có mở trong học kỳ không
    IF NOT EXISTS (
        SELECT 1 FROM mon_hoc_mo 
        WHERE ma_hoc_ky = p_ma_hoc_ky 
          AND ma_mon_hoc = p_ma_mon_hoc 
          AND trang_thai = TRUE
    ) THEN
        RETURN 'Môn học không mở trong học kỳ này';
    END IF;
    
    -- Lấy thông tin môn học
    SELECT so_tin_chi, loai_mon INTO v_so_tin_chi, v_loai_mon
    FROM mon_hoc WHERE ma_mon_hoc = p_ma_mon_hoc;
    
    -- Lấy đơn giá (QĐ5)
    v_don_gia := fn_lay_don_gia(v_loai_mon, p_ma_hoc_ky);
    v_thanh_tien := v_so_tin_chi * v_don_gia;
    
    -- Lấy tỷ lệ giảm (QĐ1)
    v_ti_le_giam := fn_lay_ti_le_giam_hoc_phi(p_ma_sv);
    
    -- Tạo/lấy phiếu đăng ký
    SELECT so_phieu INTO v_so_phieu
    FROM phieu_dang_ky 
    WHERE ma_sv = p_ma_sv AND ma_hoc_ky = p_ma_hoc_ky;
    
    IF v_so_phieu IS NULL THEN
        INSERT INTO phieu_dang_ky (ma_sv, ma_hoc_ky, ti_le_giam)
        VALUES (p_ma_sv, p_ma_hoc_ky, v_ti_le_giam)
        RETURNING so_phieu INTO v_so_phieu;
    END IF;
    
    -- Kiểm tra đã đăng ký chưa
    IF EXISTS (
        SELECT 1 FROM chi_tiet_dang_ky 
        WHERE so_phieu = v_so_phieu 
          AND ma_mon_hoc = p_ma_mon_hoc 
          AND trang_thai = 'Đã đăng ký'
    ) THEN
        RETURN 'Đã đăng ký môn học này';
    END IF;
    
    -- Thêm chi tiết đăng ký
    INSERT INTO chi_tiet_dang_ky (
        so_phieu, ma_mon_hoc, so_tin_chi, loai_mon, don_gia, thanh_tien
    ) VALUES (
        v_so_phieu, p_ma_mon_hoc, v_so_tin_chi, v_loai_mon, v_don_gia, v_thanh_tien
    );
    
    -- Cập nhật tổng tiền phiếu đăng ký
    UPDATE phieu_dang_ky SET
        tong_tin_chi = (
            SELECT COALESCE(SUM(so_tin_chi), 0) 
            FROM chi_tiet_dang_ky 
            WHERE so_phieu = v_so_phieu AND trang_thai = 'Đã đăng ký'
        ),
        tong_tien_dang_ky = (
            SELECT COALESCE(SUM(thanh_tien), 0) 
            FROM chi_tiet_dang_ky 
            WHERE so_phieu = v_so_phieu AND trang_thai = 'Đã đăng ký'
        ),
        tien_mien_giam = (
            SELECT COALESCE(SUM(thanh_tien), 0) 
            FROM chi_tiet_dang_ky 
            WHERE so_phieu = v_so_phieu AND trang_thai = 'Đã đăng ký'
        ) * v_ti_le_giam / 100,
        tong_tien_phai_dong = (
            SELECT COALESCE(SUM(thanh_tien), 0) 
            FROM chi_tiet_dang_ky 
            WHERE so_phieu = v_so_phieu AND trang_thai = 'Đã đăng ký'
        ) * (100 - v_ti_le_giam) / 100,
        ngay_cap_nhat = CURRENT_TIMESTAMP
    WHERE so_phieu = v_so_phieu;
    
    -- Cập nhật số lượng đăng ký của môn học mở
    UPDATE mon_hoc_mo 
    SET so_luong_da_dang_ky = so_luong_da_dang_ky + 1
    WHERE ma_hoc_ky = p_ma_hoc_ky AND ma_mon_hoc = p_ma_mon_hoc;
    
    RETURN 'Đăng ký thành công';
END;
$$ LANGUAGE plpgsql;
```

---

#### Function 4: `sp_thu_hoc_phi` (BM6, QĐ6)

```sql
CREATE OR REPLACE FUNCTION sp_thu_hoc_phi(
    p_ma_sv VARCHAR,
    p_ma_hoc_ky VARCHAR,
    p_so_tien_thu DECIMAL,
    p_hinh_thuc_thu VARCHAR DEFAULT 'Tiền mặt',
    p_nguoi_thu VARCHAR DEFAULT NULL,
    p_ghi_chu VARCHAR DEFAULT NULL
) RETURNS TEXT AS $$
DECLARE
    v_so_phieu INTEGER;
    v_con_lai DECIMAL(15,0);
BEGIN
    -- Lấy phiếu đăng ký
    SELECT so_phieu INTO v_so_phieu
    FROM phieu_dang_ky 
    WHERE ma_sv = p_ma_sv 
      AND ma_hoc_ky = p_ma_hoc_ky 
      AND trang_thai = 'Đã đăng ký';
    
    IF v_so_phieu IS NULL THEN
        RETURN 'Không tìm thấy phiếu đăng ký';
    END IF;
    
    -- Tính số tiền còn lại
    SELECT tong_tien_phai_dong - COALESCE((
        SELECT SUM(so_tien_thu) FROM phieu_thu_hoc_phi 
        WHERE so_phieu_dang_ky = v_so_phieu 
          AND trang_thai = 'Thành công'
    ), 0) INTO v_con_lai
    FROM phieu_dang_ky WHERE so_phieu = v_so_phieu;
    
    -- Kiểm tra số tiền thu
    IF p_so_tien_thu > v_con_lai THEN
        RETURN 'Số tiền thu vượt quá số tiền còn lại (' || 
               TO_CHAR(v_con_lai, 'FM999,999,999') || 'đ)';
    END IF;
    
    -- Tạo phiếu thu (QĐ6: SV có thể đóng nhiều lần)
    INSERT INTO phieu_thu_hoc_phi (
        so_phieu_dang_ky, ma_sv, so_tien_thu, 
        hinh_thuc_thu, nguoi_thu, ghi_chu
    ) VALUES (
        v_so_phieu, p_ma_sv, p_so_tien_thu, 
        p_hinh_thuc_thu, p_nguoi_thu, p_ghi_chu
    );
    
    RETURN 'Thu học phí thành công.  Còn lại:  ' || 
           TO_CHAR(v_con_lai - p_so_tien_thu, 'FM999,999,999') || 'đ';
END;
$$ LANGUAGE plpgsql;
```

---

## 9. QUY TẮC NGHIỆP VỤ (BUSINESS RULES)

### 9.1. Quy định theo đề tài

| Mã | Quy định | Bảng liên quan | Cách triển khai |
|----|----------|----------------|-----------------|
| QĐ1 | Quê quán gồm Huyện và Tỉnh.  Huyện có thuộc vùng sâu/xa hay không. SV có thể thuộc nhiều đối tượng, lấy đối tượng ưu tiên cao nhất | `tinh`, `huyen`, `doi_tuong`, `doi_tuong_sinh_vien` | Cột `la_vung_sau_vung_xa` trong `huyen`. Function `fn_lay_ti_le_giam_hoc_phi` |
| QĐ2 | Loại môn LT/TH.  Số tín chỉ = số tiết/15 (LT) hoặc /30 (TH) | `mon_hoc` | Computed column `so_tin_chi` |
| QĐ3 | Chương trình học theo ngành để mở môn trong học kỳ | `chuong_trinh_hoc`, `mon_hoc_mo` | FK liên kết |
| QĐ4 | Có HK I, HK II (chính) và có thể có HK Hè | `hoc_ky` | Cột `loai_hoc_ky` |
| QĐ5 | Đơn giá:  LT = 27,000đ/TC, TH = 37,000đ/TC.  SV chỉ ĐK môn có mở trong HK | `don_gia_tin_chi`, `mon_hoc_mo` | Function `fn_lay_don_gia`, `sp_dang_ky_mon_hoc` |
| QĐ6 | SV có thể đóng HP nhiều lần, phải hoàn thành trước hạn | `phieu_thu_hoc_phi`, `hoc_ky` | Cho phép nhiều phiếu thu/phiếu ĐK.  Cột `han_dong_hoc_phi` |
| QĐ7 | Số tiền phải đóng <= Số tiền đăng ký (do miễn giảm) | `phieu_dang_ky` | Cột `tong_tien_phai_dong` = `tong_tien_dang_ky` - `tien_mien_giam` |

### 9.2. Công thức tính toán

```
┌─────────────────────────────────────────────────────────────────┐
│                    CÔNG THỨC TÍNH HỌC PHÍ                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. Số tín chỉ (QĐ2):                                          │
│     - Môn LT: số_tín_chỉ = số_tiết / 15                        │
│     - Môn TH: số_tín_chỉ = số_tiết / 30                        │
│                                                                 │
│  2. Thành tiền mỗi môn (QĐ5):                                  │
│     thành_tiền = số_tín_chỉ × đơn_giá                          │
│     - Môn LT: đơn_giá = 27,000 đ                               │
│     - Môn TH: đơn_giá = 37,000 đ                               │
│                                                                 │
│  3. Tổng tiền đăng ký (BM7):                                   │
│     tổng_tiền_đăng_ký = SUM(thành_tiền các môn)                │
│                                                                 │
│  4. Tiền miễn giảm (QĐ1, QĐ7):                                 │
│     tiền_miễn_giảm = tổng_tiền_đăng_ký × tỉ_lệ_giảm / 100      │
│                                                                 │
│  5. Tổng tiền phải đóng (BM7):                                 │
│     tổng_tiền_phải_đóng = tổng_tiền_đăng_ký - tiền_miễn_giảm   │
│                                                                 │
│  6. Số tiền còn lại (BM7):                                     │
│     số_tiền_còn_lại = tổng_tiền_phải_đóng - SUM(số_tiền_đã_thu)│
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 10. PHỤ LỤC

### 10.1. Sơ đồ ERD chi tiết

```
                                ┌─────────────────┐
                                │      tinh       │
                                │─────────────────│
                                │ * ma_tinh (PK)  │
                                │   ten_tinh      │
                                │   trang_thai    │
                                └────────┬────────┘
                                         │ 1
                                         │
                                         │ n
                                ┌────────┴────────┐
                                │      huyen      │
                                │─────────────────│
                                │ * ma_huyen (PK) │
                                │   ten_huyen     │
                                │ # ma_tinh (FK)  │
                                │   la_vung_sau..  │
                                └────────┬────────┘
                                         │ 1
          ┌──────────────────────────────┼──────────────────────────────┐
          │                              │                              │
          │ n                            │                              │
┌─────────┴─────────┐                    │                    ┌─────────┴─────────┐
│       khoa        │                    │                    │    doi_tuong      │
│───────────────────│                    │                    │───────────────────│
│ * ma_khoa (PK)    │                    │                    │ * ma_doi_tuong(PK)│
│   ten_khoa        │                    │                    │   ten_doi_tuong   │
└─────────┬─────────┘                    │                    │   ti_le_giam_hp   │
          │ 1                            │                    │   do_uu_tien      │
          │                              │                    └─────────┬─────────┘
          │ n                            │                              │ 1
┌─────────┴─────────┐                    │                              │
│    nganh_hoc      │                    │                              │ n
│───────────────────│                    │                    ┌─────────┴─────────┐
│ * ma_nganh (PK)   │                    │                    │ doi_tuong_sv      │
│   ten_nganh       │                    │                    │───────────────────│
│ # ma_khoa (FK)    │                    │                    │ * id (PK)         │
└─────────┬─────────┘                    │                    │ # ma_sv (FK)      │
          │ 1                            │                    │ # ma_doi_tuong(FK)│
          │                              │                    └─────────┬─────────┘
          │ n                   n        │                              │ n
          └──────────────────────────────┼──────────────────────────────┘
                                         │
                                ┌────────┴────────┐
                                │   sinh_vien     │
                                │─────────────────│
                                │ * ma_sv (PK)    │
                                │   ho_ten        │
                                │   ngay_sinh     │
                                │   gioi_tinh     │
                                │ # ma_huyen (FK) │
                                │ # ma_nganh (FK) │
                                │   trang_thai    │
                                └────────┬────────┘
                                         │ 1
                    ┌────────────────────┼────────────────────┐
                    │                    │                    │
                    │ n                  │ n                  │ 1
          ┌─────────┴─────────┐ ┌────────┴────────┐ ┌─────────┴─────────┐
          │  phieu_dang_ky    │ │ phieu_thu_hp    │ │    tai_khoan      │
          │───────────────────│ │─────────────────│ │───────────���───────│
          │ * so_phieu (PK)   │ │ * so_phieu_thu  │ │ * ma_tai_khoan(PK)│
          │ # ma_sv (FK)      │ │ # so_phieu_dk   │ │   ten_dang_nhap   │
          │ # ma_hoc_ky (FK)  │ │ # ma_sv (FK)    │ │ # ma_vai_tro (FK) │
          │   ngay_lap        │ │   so_tien_thu   │ │ # ma_sv (FK)      │
          │   tong_tien_dk    │ │   hinh_thuc_thu │ └───────────────────┘
          │   ti_le_giam      │ └─────────────────┘
          │   tong_tien_phai.  │
          └─────────┬─────────┘
                    │ 1
                    │
                    │ n
          ┌─────────┴─────────┐
          │  chi_tiet_dk      │
          │───────────────────│
          │ * id (PK)         │
          │ # so_phieu (FK)   │
          │ # ma_mon_hoc (FK) │
          │   so_tin_chi      │
          │   don_gia         │
          │   thanh_tien      │
          └─────────┬─────────┘
                    │ n
                    │
                    │ 1
          ┌─────────┴─────────┐
          │     mon_hoc       │
          │───────────────────│
          │ * ma_mon_hoc (PK) │
          │   ten_mon_hoc     │
          │   loai_mon        │
          │   so_tiet         │
          │   so_tin_chi      │◄──────────────────┐
          └─────────┬─────────┘                   │
                    │ 1                           │
                    │                             │
                    │ n                           │
          ┌─────────┴─────────┐                   │
          │    mon_hoc_mo     │                   │
          │───────────────────│          ┌────────┴────────┐
          │ * id (PK)         │          │ chuong_trinh_hoc│
          │ # ma_hoc_ky (FK)  │          │─────────────────│
          │ # ma_mon_hoc (FK) │          │ * id (PK)       │
          │   so_luong_toi_da │          │ # ma_nganh (FK) │
          │   so_luong_da_dk  │          │ # ma_mon_hoc(FK)│
          └─────────┬─────────┘          │   hoc_ky_du_kien│
                    │ n                  └─────────────────┘
                    │
                    │ 1
          ┌─────────┴─────────┐
          │      hoc_ky       │
          │───────────────────│
          │ * ma_hoc_ky (PK)  │
          │   ten_hoc_ky      │
          │ # ma_nam_hoc (FK) │
          │   loai_hoc_ky     │
          │   han_dong_hp     │
          └─────────┬─────────┘
                    │ n
                    │
                    │ 1
          ┌─────────┴─────────┐
          │     nam_hoc       │
          │───────────────────│
          │ * ma_nam_hoc (PK) │
          │   ten_nam_hoc     │
          │   nam_bat_dau     │
          │   nam_ket_thuc    │
          └───────────────────┘

Chú thích:
  * :  Primary Key (Khóa chính)
  # : Foreign Key (Khóa ngoại)
  1 : Một
  n : Nhiều
```
### 10.2. Danh sách dữ liệu mẫu đề xuất (Tiếp theo)

| Bảng | Số bản ghi đề xuất | Ghi chú |
|------|-------------------|---------|
| `tinh` | 63 | 63 tỉnh/thành Việt Nam |
| `huyen` | 100+ | Các huyện/quận phổ biến |
| `doi_tuong` | 6-10 | Các đối tượng ưu tiên theo QĐ1 |
| `khoa` | 5-10 | Các khoa trong trường |
| `nganh_hoc` | 15-20 | Các ngành đào tạo |
| `sinh_vien` | 100+ | Sinh viên mẫu |
| `mon_hoc` | 50-100 | Các môn học |
| `chuong_trinh_hoc` | 200+ | CTĐT các ngành |
| `nam_hoc` | 3-5 | Các năm học gần đây |
| `hoc_ky` | 10-15 | Các học kỳ |
| `mon_hoc_mo` | 50+ | Môn mở trong HK hiện tại |
| `vai_tro` | 2 | Admin, Sinh viên |
| `quyen` | 10-15 | Các quyền hệ thống |
| `tai_khoan` | 100+ | Tài khoản người dùng |

### 10.3. Dữ liệu mẫu chi tiết

#### 10.3.1. Đối tượng ưu tiên (QĐ1)

```sql
INSERT INTO doi_tuong (ma_doi_tuong, ten_doi_tuong, ti_le_giam_hoc_phi, do_uu_tien, mo_ta) VALUES 
('DT01', 'Con liệt sĩ',           100. 00, 1, 'Miễn 100% học phí'),
('DT02', 'Con thương binh',        80.00, 2, 'Giảm 80% học phí'),
('DT03', 'Hộ nghèo',               70.00, 3, 'Giảm 70% học phí'),
('DT04', 'Vùng sâu vùng xa',       50.00, 4, 'Giảm 50% học phí'),
('DT05', 'Hộ cận nghèo',           50.00, 5, 'Giảm 50% học phí'),
('DT06', 'Dân tộc thiểu số',       30.00, 6, 'Giảm 30% học phí'),
('DT07', 'Mồ côi cha hoặc mẹ',     30.00, 7, 'Giảm 30% học phí'),
('DT08', 'Khuyết tật',             50.00, 8, 'Giảm 50% học phí');
```

#### 10.3.2. Đơn giá tín chỉ (QĐ5)

```sql
INSERT INTO don_gia_tin_chi (loai_mon, don_gia, ghi_chu) VALUES 
('LT', 27000, 'Đơn giá môn Lý thuyết - 27,000đ/tín chỉ (QĐ5)'),
('TH', 37000, 'Đơn giá môn Thực hành - 37,000đ/tín chỉ (QĐ5)');
```

#### 10.3.3. Môn học mẫu (BM2, QĐ2)

```sql
-- Môn Lý thuyết (LT): số tín chỉ = số tiết / 15
INSERT INTO mon_hoc (ma_mon_hoc, ten_mon_hoc, loai_mon, so_tiet) VALUES 
('LT001', 'Toán cao cấp',                    'LT', 45),  -- 3 TC
('LT002', 'Vật lý đại cương',                'LT', 45),  -- 3 TC
('LT003', 'Triết học Mác-Lênin',             'LT', 45),  -- 3 TC
('LT004', 'Kinh tế chính trị',               'LT', 30),  -- 2 TC
('LT005', 'Cơ sở dữ liệu',                   'LT', 45),  -- 3 TC
('LT006', 'Lập trình hướng đối tượng',       'LT', 45),  -- 3 TC
('LT007', 'Mạng máy tính',                   'LT', 60),  -- 4 TC
('LT008', 'Tiếng Anh cơ bản 1',              'LT', 60),  -- 4 TC
('LT009', 'Tiếng Anh cơ bản 2',              'LT', 60),  -- 4 TC
('LT010', 'Cấu trúc dữ liệu và giải thuật',  'LT', 45),  -- 3 TC
('LT011', 'Hệ điều hành',                    'LT', 45),  -- 3 TC
('LT012', 'Công nghệ phần mềm',              'LT', 45);  -- 3 TC

-- Môn Thực hành (TH): số tín chỉ = số tiết / 30
INSERT INTO mon_hoc (ma_mon_hoc, ten_mon_hoc, loai_mon, so_tiet) VALUES 
('TH001', 'Thực hành Cơ sở dữ liệu',         'TH', 60),  -- 2 TC
('TH002', 'Thực hành Lập trình',             'TH', 90),  -- 3 TC
('TH003', 'Thực hành Mạng máy tính',         'TH', 60),  -- 2 TC
('TH004', 'Đồ án môn học',                   'TH', 60),  -- 2 TC
('TH005', 'Thực hành Hệ điều hành',          'TH', 60),  -- 2 TC
('TH006', 'Đồ án tốt nghiệp',                'TH', 300); -- 10 TC
```

#### 10.3.4. Vai trò và Quyền

```sql
-- Vai trò
INSERT INTO vai_tro (ten_vai_tro, mo_ta) VALUES 
('Admin', 'Quản trị viên hệ thống - Toàn quyền'),
('Sinh viên', 'Sinh viên - Đăng ký môn học và xem học phí');

-- Quyền hệ thống
INSERT INTO quyen (ten_quyen, mo_ta, nhom_quyen) VALUES 
-- Nhóm quản lý sinh viên
('STUDENT_VIEW',        'Xem danh sách sinh viên',      'STUDENT'),
('STUDENT_CREATE',      'Thêm mới sinh viên',           'STUDENT'),
('STUDENT_EDIT',        'Chỉnh sửa thông tin sinh viên','STUDENT'),
('STUDENT_DELETE',      'Xóa sinh viên',                'STUDENT'),
-- Nhóm quản lý môn học
('COURSE_VIEW',         'Xem danh sách môn học',        'COURSE'),
('COURSE_MANAGE',       'Quản lý môn học',              'COURSE'),
-- Nhóm đăng ký
('REGISTRATION_VIEW',   'Xem đăng ký học phần',         'REGISTRATION'),
('REGISTRATION_MANAGE', 'Quản lý đăng ký học phần',     'REGISTRATION'),
-- Nhóm học phí
('PAYMENT_VIEW',        'Xem thông tin học phí',        'PAYMENT'),
('PAYMENT_COLLECT',     'Thu học phí',                  'PAYMENT'),
-- Nhóm báo cáo
('REPORT_VIEW',         'Xem báo cáo thống kê',         'REPORT'),
('REPORT_EXPORT',       'Xuất báo cáo',                 'REPORT'),
-- Nhóm sinh viên tự phục vụ
('MY_INFO_VIEW',        'Xem thông tin cá nhân',        'STUDENT_SELF'),
('MY_REGISTRATION',     'Đăng ký môn học của tôi',      'STUDENT_SELF'),
('MY_PAYMENT_VIEW',     'Xem học phí của tôi',          'STUDENT_SELF');

-- Phân quyền cho Admin (tất cả quyền quản lý)
INSERT INTO phan_quyen (ma_vai_tro, ma_quyen)
SELECT 1, ma_quyen FROM quyen 
WHERE nhom_quyen IN ('STUDENT', 'COURSE', 'REGISTRATION', 'PAYMENT', 'REPORT');

-- Phân quyền cho Sinh viên (chỉ quyền tự phục vụ)
INSERT INTO phan_quyen (ma_vai_tro, ma_quyen)
SELECT 2, ma_quyen FROM quyen 
WHERE nhom_quyen = 'STUDENT_SELF';
```

---

## 11. HƯỚNG DẪN SỬ DỤNG

### 11.1. Tạo Database

```sql
-- Bước 1: Tạo database
CREATE DATABASE ql_dangky_hocphi
    WITH ENCODING = 'UTF8'
    LC_COLLATE = 'vi_VN.UTF-8'
    LC_CTYPE = 'vi_VN.UTF-8';

-- Bước 2: Kết nối đến database
\c ql_dangky_hocphi

-- Bước 3: Chạy script tạo bảng (file SQL chính)
\i path/to/QuanLyDangKyMonHoc_HocPhi_PostgreSQL.sql
```

### 11.2. Các thao tác cơ bản

#### 11.2.1. Thêm sinh viên mới (BM1)

```sql
-- Thêm sinh viên
INSERT INTO sinh_vien (
    ma_sv, ho_ten, ngay_sinh, gioi_tinh, 
    ma_huyen, ma_nganh, sdt, email
) VALUES (
    'SV001', 'Nguyễn Văn An', '2003-05-15', 'Nam',
    'Q1', 'KTPM', '0901234567', 'an. nv@email.com'
);

-- Gán đối tượng ưu tiên cho sinh viên (nếu có)
INSERT INTO doi_tuong_sinh_vien (ma_sv, ma_doi_tuong, ghi_chu)
VALUES ('SV001', 'DT03', 'Sinh viên hộ nghèo');

-- Tạo tài khoản cho sinh viên
INSERT INTO tai_khoan (ten_dang_nhap, mat_khau, ma_vai_tro, ma_sv, email)
VALUES ('SV001', '$2a$10$... ', 2, 'SV001', 'an.nv@email. com');
```

#### 11.2.2. Thêm môn học (BM2)

```sql
-- Thêm môn Lý thuyết (số tín chỉ tự động tính = 45/15 = 3)
INSERT INTO mon_hoc (ma_mon_hoc, ten_mon_hoc, loai_mon, so_tiet)
VALUES ('LT013', 'Trí tuệ nhân tạo', 'LT', 45);

-- Thêm môn Thực hành (số tín chỉ tự động tính = 60/30 = 2)
INSERT INTO mon_hoc (ma_mon_hoc, ten_mon_hoc, loai_mon, so_tiet)
VALUES ('TH007', 'Thực hành AI', 'TH', 60);
```

#### 11.2.3. Thiết lập chương trình học (BM3)

```sql
-- Thêm môn vào chương trình đào tạo ngành KTPM
INSERT INTO chuong_trinh_hoc (ma_nganh, ma_mon_hoc, hoc_ky_du_kien, ghi_chu)
VALUES 
    ('KTPM', 'LT001', 1, 'Môn cơ sở'),
    ('KTPM', 'LT005', 2, 'Môn cơ sở ngành'),
    ('KTPM', 'TH001', 2, 'Thực hành đi kèm LT005'),
    ('KTPM', 'LT006', 3, 'Môn chuyên ngành');
```

#### 11.2.4. Mở môn học trong học kỳ (BM4)

```sql
-- Mở các môn cho học kỳ 1 năm 2025-2026
INSERT INTO mon_hoc_mo (ma_hoc_ky, ma_mon_hoc, so_luong_toi_da)
VALUES 
    ('HK1-2526', 'LT001', 100),
    ('HK1-2526', 'LT005', 80),
    ('HK1-2526', 'TH001', 40),
    ('HK1-2526', 'LT006', 60);
```

#### 11.2.5. Đăng ký môn học (BM5)

```sql
-- Sử dụng function đăng ký môn học
SELECT sp_dang_ky_mon_hoc('SV001', 'HK1-2526', 'LT001');
SELECT sp_dang_ky_mon_hoc('SV001', 'HK1-2526', 'LT005');
SELECT sp_dang_ky_mon_hoc('SV001', 'HK1-2526', 'TH001');

-- Xem phiếu đăng ký
SELECT * FROM v_phieu_dang_ky WHERE ma_so_sinh_vien = 'SV001';
```

#### 11.2.6. Thu học phí (BM6)

```sql
-- Sinh viên đóng học phí lần 1 (QĐ6:  có thể đóng nhiều lần)
SELECT sp_thu_hoc_phi(
    'SV001',           -- Mã SV
    'HK1-2526',        -- Mã học kỳ
    200000,            -- Số tiền thu
    'Tiền mặt',        -- Hình thức
    'Nguyễn Văn B',    -- Người thu
    'Đóng lần 1'       -- Ghi chú
);

-- Sinh viên đóng học phí lần 2
SELECT sp_thu_hoc_phi('SV001', 'HK1-2526', 150000, 'Chuyển khoản', NULL, 'Đóng lần 2');

-- Xem phiếu thu
SELECT * FROM v_phieu_thu_hoc_phi WHERE ma_so_sinh_vien = 'SV001';
```

#### 11.2.7. Xem báo cáo SV chưa đóng học phí (BM7)

```sql
-- Xem tất cả SV chưa đóng đủ học phí
SELECT * FROM v_bao_cao_sv_chua_dong_hoc_phi;

-- Lọc theo học kỳ
SELECT * FROM v_bao_cao_sv_chua_dong_hoc_phi 
WHERE ma_hoc_ky = 'HK1-2526';

-- Lọc SV quá hạn
SELECT * FROM v_bao_cao_sv_chua_dong_hoc_phi 
WHERE trang_thai = 'Quá hạn';
```

### 11.3. Queries thường dùng

#### 11.3.1. Thống kê sinh viên theo ngành

```sql
SELECT 
    k.ten_khoa,
    nh.ten_nganh,
    COUNT(sv.ma_sv) AS so_luong_sv,
    COUNT(CASE WHEN sv.trang_thai = 'Đang học' THEN 1 END) AS dang_hoc,
    COUNT(CASE WHEN sv.trang_thai = 'Tốt nghiệp' THEN 1 END) AS tot_nghiep
FROM sinh_vien sv
JOIN nganh_hoc nh ON sv.ma_nganh = nh. ma_nganh
JOIN khoa k ON nh.ma_khoa = k.ma_khoa
GROUP BY k.ten_khoa, nh.ten_nganh
ORDER BY k.ten_khoa, nh.ten_nganh;
```

#### 11.3.2. Thống kê đăng ký môn học theo học kỳ

```sql
SELECT 
    hk.ten_hoc_ky,
    nh.ten_nam_hoc,
    mh.ma_mon_hoc,
    mh.ten_mon_hoc,
    mhm.so_luong_toi_da,
    mhm.so_luong_da_dang_ky,
    mhm.so_luong_toi_da - mhm.so_luong_da_dang_ky AS con_trong
FROM mon_hoc_mo mhm
JOIN hoc_ky hk ON mhm.ma_hoc_ky = hk. ma_hoc_ky
JOIN nam_hoc nh ON hk.ma_nam_hoc = nh.ma_nam_hoc
JOIN mon_hoc mh ON mhm.ma_mon_hoc = mh.ma_mon_hoc
WHERE mhm.trang_thai = TRUE
ORDER BY hk.ma_hoc_ky, mh.ma_mon_hoc;
```

#### 11.3.3. Thống kê thu học phí theo học kỳ

```sql
SELECT 
    hk.ten_hoc_ky,
    nh.ten_nam_hoc,
    COUNT(DISTINCT pdk.ma_sv) AS tong_sv,
    SUM(pdk.tong_tien_dang_ky) AS tong_tien_dang_ky,
    SUM(pdk.tien_mien_giam) AS tong_mien_giam,
    SUM(pdk.tong_tien_phai_dong) AS tong_phai_dong,
    COALESCE(SUM(thu. da_thu), 0) AS tong_da_thu,
    SUM(pdk.tong_tien_phai_dong) - COALESCE(SUM(thu.da_thu), 0) AS tong_con_no,
    COUNT(CASE WHEN pdk.tong_tien_phai_dong <= COALESCE(thu.da_thu, 0) THEN 1 END) AS sv_da_dong_du,
    COUNT(CASE WHEN pdk.tong_tien_phai_dong > COALESCE(thu.da_thu, 0) THEN 1 END) AS sv_con_no
FROM phieu_dang_ky pdk
JOIN hoc_ky hk ON pdk.ma_hoc_ky = hk.ma_hoc_ky
JOIN nam_hoc nh ON hk.ma_nam_hoc = nh.ma_nam_hoc
LEFT JOIN (
    SELECT so_phieu_dang_ky, SUM(so_tien_thu) AS da_thu
    FROM phieu_thu_hoc_phi
    WHERE trang_thai = 'Thành công'
    GROUP BY so_phieu_dang_ky
) thu ON pdk.so_phieu = thu.so_phieu_dang_ky
WHERE pdk.trang_thai = 'Đã đăng ký'
GROUP BY hk.ma_hoc_ky, hk.ten_hoc_ky, nh.ten_nam_hoc
ORDER BY nh.ten_nam_hoc DESC, hk.thu_tu;
```

#### 11.3.4. Danh sách SV được miễn giảm học phí

```sql
SELECT 
    sv.ma_sv,
    sv.ho_ten,
    nh.ten_nganh,
    dt.ten_doi_tuong,
    dt. ti_le_giam_hoc_phi,
    h.ten_huyen || ', ' || t.ten_tinh AS que_quan,
    CASE WHEN h.la_vung_sau_vung_xa THEN 'Có' ELSE 'Không' END AS vung_sau_xa
FROM sinh_vien sv
JOIN nganh_hoc nh ON sv.ma_nganh = nh.ma_nganh
JOIN huyen h ON sv.ma_huyen = h.ma_huyen
JOIN tinh t ON h.ma_tinh = t.ma_tinh
LEFT JOIN doi_tuong_sinh_vien dtsv ON sv.ma_sv = dtsv.ma_sv
LEFT JOIN doi_tuong dt ON dtsv.ma_doi_tuong = dt.ma_doi_tuong
WHERE dtsv.id IS NOT NULL OR h.la_vung_sau_vung_xa = TRUE
ORDER BY dt. do_uu_tien NULLS LAST, sv.ma_sv;
```

---

## 12. BẢO TRÌ VÀ BACKUP

### 12.1. Backup Database

```bash
# Backup toàn bộ database
pg_dump -U postgres -h localhost -F c -b -v -f "backup_ql_dangky_hocphi_$(date +%Y%m%d).dump" ql_dangky_hocphi

# Backup chỉ schema (cấu trúc)
pg_dump -U postgres -h localhost -s -f "schema_backup. sql" ql_dangky_hocphi

# Backup chỉ data
pg_dump -U postgres -h localhost -a -f "data_backup.sql" ql_dangky_hocphi
```

### 12.2. Restore Database

```bash
# Restore từ file dump
pg_restore -U postgres -h localhost -d ql_dangky_hocphi -v "backup_ql_dangky_hocphi_20260116.dump"

# Restore từ file SQL
psql -U postgres -h localhost -d ql_dangky_hocphi -f "backup. sql"
```

### 12.3. Maintenance

```sql
-- Cập nhật thống kê
ANALYZE;

-- Vacuum để giải phóng không gian
VACUUM ANALYZE;

-- Reindex
REINDEX DATABASE ql_dangky_hocphi;

-- Kiểm tra kích thước các bảng
SELECT 
    relname AS table_name,
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
    pg_size_pretty(pg_relation_size(relid)) AS data_size,
    pg_size_pretty(pg_indexes_size(relid)) AS index_size
FROM pg_catalog. pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;
```

---

## 13. LỊCH SỬ PHIÊN BẢN

| Phiên bản | Ngày | Mô tả thay đổi |
|-----------|------|----------------|
| 1.0 | 2026-01-16 | Phiên bản đầu tiên - Đáp ứng BM1-BM7, QĐ1-QĐ7 |

---

## 14. LIÊN HỆ VÀ HỖ TRỢ

**Tác giả:** Copilot AI Assistant

**Mục đích:** Tài liệu mô tả database cho đề tài "Quản lý việc đăng ký môn học và thu học phí của sinh viên"

**Ghi chú:** 
- Database được thiết kế cho PostgreSQL 12+
- Đáp ứng đầy đủ 7 biểu mẫu (BM1-BM7) và 7 quy định (QĐ1-QĐ7) theo yêu cầu đề tài
- Hỗ trợ 2 role: Admin và Sinh viên