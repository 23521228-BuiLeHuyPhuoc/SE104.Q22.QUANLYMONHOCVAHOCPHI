# 📋 PHÂN CÔNG CÔNG VIỆC - TRIGGER & STORED PROCEDURES

## Hệ thống Quản lý Đăng ký Môn học và Thu Học phí

---

## 📌 TỔNG QUAN

Tài liệu này phân chia công việc viết Trigger và Stored Procedures cho **4 thành viên** trong nhóm, đảm bảo đáp ứng đầy đủ các yêu cầu từ BM1-BM7 và QĐ1-QĐ7.

---

## 👤 THÀNH VIÊN 1: Quản lý Sinh viên & Đối tượng ưu tiên

### Phụ trách: BM1, QĐ1

| STT | Tên Trigger/Function | Mô tả | Bảng liên quan |
|-----|---------------------|-------|----------------|
| 1 | `trg_sinh_vien_before_insert` | Kiểm tra và chuẩn hóa dữ liệu trước khi thêm sinh viên | `sinh_vien` |
| 2 | `trg_sinh_vien_after_insert` | Tự động tạo tài khoản cho sinh viên mới | `sinh_vien`, `tai_khoan` |
| 3 | `trg_doi_tuong_sinh_vien_after_insert` | Cập nhật tỷ lệ giảm HP khi gán đối tượng | `doi_tuong_sinh_vien`, `phieu_dang_ky` |
| 4 | `trg_doi_tuong_sinh_vien_after_delete` | Cập nhật lại tỷ lệ giảm khi xóa đối tượng | `doi_tuong_sinh_vien`, `phieu_dang_ky` |
| 5 | `fn_lay_ti_le_giam_hoc_phi(ma_sv)` | Lấy tỷ lệ giảm học phí theo đối tượng ưu tiên cao nhất (QĐ1) | `doi_tuong`, `doi_tuong_sinh_vien`, `huyen` |
| 6 | `fn_kiem_tra_vung_sau_vung_xa(ma_huyen)` | Kiểm tra huyện có thuộc vùng sâu/xa không (QĐ1) | `huyen` |
| 7 | `sp_lap_ho_so_sinh_vien(...)` | Procedure tạo hồ sơ sinh viên đầy đủ (BM1) | `sinh_vien`, `tai_khoan`, `doi_tuong_sinh_vien` |
| 8 | `trg_huyen_before_update` | Cập nhật tỷ lệ giảm cho SV khi thay đổi vùng sâu/xa | `huyen`, `sinh_vien`, `phieu_dang_ky` |

### Chi tiết yêu cầu:
- **BM1**: Lập hồ sơ sinh viên (Họ tên, Ngày sinh, Giới tính, Quê quán, Đối tượng, Ngành học)
- **QĐ1**: 
  - Quê quán gồm Huyện và Tỉnh
  - Lưu danh sách vùng sâu/vùng xa
  - Xác định đối tượng ưu tiên có độ ưu tiên cao nhất
  - Tỷ lệ giảm HP: 100%, 80%, 50%, 30%...

---

## 👤 THÀNH VIÊN 2: Quản lý Môn học & Chương trình học

### Phụ trách: BM2, BM3, QĐ2, QĐ3

| STT | Tên Trigger/Function | Mô tả | Bảng liên quan |
|-----|---------------------|-------|----------------|
| 1 | `trg_mon_hoc_before_insert` | Kiểm tra loại môn (LT/TH) và số tiết hợp lệ | `mon_hoc` |
| 2 | `trg_mon_hoc_after_insert` | Tự động tạo lớp học mặc định cho môn mới | `mon_hoc`, `lop` |
| 3 | `fn_tinh_so_tin_chi(loai_mon, so_tiet)` | Tính số tín chỉ theo QĐ2 (LT: số tiết/15, TH: số tiết/30) | - |
| 4 | `trg_lop_before_insert` | Kiểm tra môn học tồn tại, đặt mã lớp | `lop`, `mon_hoc` |
| 5 | `sp_nhap_danh_sach_mon_hoc(...)` | Procedure nhập danh sách môn học (BM2) | `mon_hoc` |
| 6 | `trg_chuong_trinh_hoc_before_insert` | Kiểm tra ngành và môn học hợp lệ | `chuong_trinh_hoc`, `nganh_hoc`, `mon_hoc` |
| 7 | `sp_nhap_chuong_trinh_hoc(ma_nganh, ...)` | Procedure nhập chương trình học theo ngành (BM3) | `chuong_trinh_hoc`, `nganh_hoc`, `mon_hoc` |
| 8 | `trg_dieu_kien_mon_hoc_before_insert` | Kiểm tra điều kiện tiên quyết/học trước hợp lệ | `dieu_kien_mon_hoc`, `mon_hoc` |
| 9 | `fn_lay_chuong_trinh_hoc_theo_nganh(ma_nganh)` | Lấy danh sách môn học của ngành theo học kỳ (BM3) | `chuong_trinh_hoc` |

### Chi tiết yêu cầu:
- **BM2**: Nhập danh sách môn học (Mã MH, Tên MH, Loại môn, Số tiết)
- **QĐ2**: 
  - Loại môn: LT (Lý thuyết) hoặc TH (Thực hành)
  - Số tín chỉ = số tiết/15 (LT) hoặc số tiết/30 (TH)
- **BM3**: Chương trình học theo ngành và khoa
- **QĐ3**: Dựa trên chương trình học để mở môn trong học kỳ

---

## 👤 THÀNH VIÊN 3: Quản lý Học kỳ & Đăng ký môn học

### Phụ trách: BM4, BM5, QĐ4, QĐ5

| STT | Tên Trigger/Function | Mô tả | Bảng liên quan |
|-----|---------------------|-------|----------------|
| 1 | `trg_hoc_ky_before_insert` | Kiểm tra năm học, loại học kỳ (Chính/Hè) | `hoc_ky`, `nam_hoc` |
| 2 | `sp_mo_lop_trong_hoc_ky(ma_hoc_ky, ...)` | Procedure mở lớp học trong học kỳ (BM4) | `lop_mo`, `hoc_ky`, `lop` |
| 3 | `trg_lop_mo_before_insert` | Kiểm tra lớp và học kỳ hợp lệ | `lop_mo`, `lop`, `hoc_ky` |
| 4 | `fn_lay_don_gia(loai_mon, loai_hoc, ma_hoc_ky)` | Lấy đơn giá tín chỉ theo loại môn và loại học (QĐ5) | `don_gia_tin_chi`, `hoc_ky` |
| 5 | `trg_phieu_dang_ky_before_insert` | Kiểm tra SV và học kỳ hợp lệ, tính tỷ lệ giảm | `phieu_dang_ky`, `sinh_vien`, `hoc_ky` |
| 6 | `sp_dang_ky_lop(ma_sv, ma_hoc_ky, ma_lop, loai_dang_ky)` | Procedure đăng ký lớp học (BM5) | `phieu_dang_ky`, `chi_tiet_dang_ky`, `lop_mo` |
| 7 | `trg_chi_tiet_dang_ky_after_insert` | Cập nhật tổng tín chỉ và tổng tiền phiếu đăng ký | `chi_tiet_dang_ky`, `phieu_dang_ky` |
| 8 | `trg_chi_tiet_dang_ky_after_update` | Cập nhật khi hủy môn đăng ký | `chi_tiet_dang_ky`, `phieu_dang_ky`, `lop_mo` |
| 9 | `fn_kiem_tra_lop_mo(ma_hoc_ky, ma_lop)` | Kiểm tra lớp có mở trong học kỳ không (QĐ5) | `lop_mo` |
| 10 | `fn_kiem_tra_si_so_lop(ma_lop, ma_hoc_ky)` | Kiểm tra sĩ số còn chỗ trống | `lop_mo`, `lop` |
| 11 | `sp_huy_dang_ky_lop(ma_sv, ma_hoc_ky, ma_lop)` | Procedure hủy đăng ký lớp | `chi_tiet_dang_ky`, `phieu_dang_ky`, `lop_mo` |

### Chi tiết yêu cầu:
- **BM4**: Danh sách môn học mở trong học kỳ (Học kỳ, Năm học, Môn học)
- **QĐ4**: 
  - 2 học kỳ chính (HK I, HK II)
  - Có thể có học kỳ hè (tùy theo nhu cầu)
- **BM5**: Phiếu đăng ký học phần (Số phiếu, MSSV, Ngày lập, Học kỳ, Năm học, Môn học, Số tín chỉ)
- **QĐ5**: 
  - Đơn giá: LT = 27,000đ/TC, TH = 37,000đ/TC (học mới)
  - Đơn giá học lại, cải thiện, học hè khác nhau
  - SV chỉ được đăng ký môn có mở trong học kỳ

---

## 👤 THÀNH VIÊN 4: Quản lý Học phí & Báo cáo

### Phụ trách: BM6, BM7, QĐ6, QĐ7

| STT | Tên Trigger/Function | Mô tả | Bảng liên quan |
|-----|---------------------|-------|----------------|
| 1 | `trg_phieu_thu_hoc_phi_before_insert` | Kiểm tra phiếu đăng ký và số tiền thu hợp lệ | `phieu_thu_hoc_phi`, `phieu_dang_ky` |
| 2 | `trg_phieu_thu_hoc_phi_after_insert` | Cập nhật trạng thái đã đóng đủ nếu cần | `phieu_thu_hoc_phi`, `phieu_dang_ky` |
| 3 | `sp_thu_hoc_phi(ma_sv, ma_hoc_ky, so_tien, hinh_thuc, nguoi_thu, ghi_chu)` | Procedure thu học phí (BM6) | `phieu_thu_hoc_phi`, `phieu_dang_ky` |
| 4 | `fn_tinh_so_tien_con_lai(ma_sv, ma_hoc_ky)` | Tính số tiền còn lại phải đóng (QĐ7) | `phieu_dang_ky`, `phieu_thu_hoc_phi` |
| 5 | `fn_tinh_tong_tien_da_thu(so_phieu_dang_ky)` | Tính tổng tiền đã thu cho 1 phiếu đăng ký | `phieu_thu_hoc_phi` |
| 6 | `sp_lap_bao_cao_sv_chua_dong_hp(ma_hoc_ky)` | Procedure lập báo cáo SV chưa đóng đủ HP (BM7) | `phieu_dang_ky`, `phieu_thu_hoc_phi`, `sinh_vien`, `hoc_ky` |
| 7 | `trg_hoc_ky_check_han_dong_hp` | Kiểm tra và cảnh báo SV chưa đóng HP khi đến hạn | `hoc_ky`, `phieu_dang_ky`, `thong_bao_ca_nhan` |
| 8 | `fn_kiem_tra_qua_han_dong_hp(ma_sv, ma_hoc_ky)` | Kiểm tra SV đã quá hạn đóng HP chưa (QĐ6) | `phieu_dang_ky`, `hoc_ky` |
| 9 | `sp_gui_thong_bao_nhac_hp(ma_hoc_ky)` | Gửi thông báo nhắc nộp HP cho SV chưa đóng đủ | `thong_bao_ca_nhan`, `sinh_vien`, `tai_khoan` |
| 10 | `trg_phieu_thu_hoc_phi_after_update` | Xử lý khi hủy phiếu thu | `phieu_thu_hoc_phi`, `phieu_dang_ky` |

### Chi tiết yêu cầu:
- **BM6**: Phiếu thu học phí (Số phiếu, Ngày lập, MSSV, Số tiền thu)
- **QĐ6**: 
  - Phiếu thu dựa trên phiếu đăng ký học phần
  - SV có thể đóng nhiều lần cho 1 phiếu đăng ký
  - Phải hoàn thành trước hạn (không được thi cuối kỳ nếu chưa đóng đủ)
- **BM7**: Báo cáo SV chưa hoàn thành đóng HP (MSSV, Số tiền đăng ký, Số tiền phải đóng, Số tiền còn lại)
- **QĐ7**: 
  - Số tiền phải đóng <= Số tiền đăng ký (do miễn giảm theo đối tượng)

---

## 📊 TỔNG HỢP CÔNG VIỆC

| Thành viên | BM | QĐ | Số Trigger | Số Function | Số Procedure |
|------------|----|----|------------|-------------|--------------|
| **TV1** | BM1 | QĐ1 | 4 | 2 | 1 |
| **TV2** | BM2, BM3 | QĐ2, QĐ3 | 4 | 2 | 2 |
| **TV3** | BM4, BM5 | QĐ4, QĐ5 | 4 | 3 | 3 |
| **TV4** | BM6, BM7 | QĐ6, QĐ7 | 3 | 3 | 3 |

---

## 📝 QUY TẮC ĐẶT TÊN

### Trigger
```
trg_<tên_bảng>_<timing>_<event>
Ví dụ: trg_sinh_vien_before_insert
```

### Function
```
fn_<chức_năng>
Ví dụ: fn_lay_ti_le_giam_hoc_phi
```

### Stored Procedure
```
sp_<chức_năng>
Ví dụ: sp_dang_ky_lop
```

---

## ⏰ TIMELINE CÔNG VIỆC

| Giai đoạn | Công việc | Thời gian |
|-----------|-----------|-----------|
| 1 | Phân tích yêu cầu chi tiết | 2 ngày |
| 2 | Viết Trigger/Function/Procedure | 5 ngày |
| 3 | Test đơn vị từng chức năng | 2 ngày |
| 4 | Test tích hợp toàn hệ thống | 2 ngày |
| 5 | Review và hoàn thiện | 1 ngày |

---

## 📌 LƯU Ý QUAN TRỌNG

1. **Đảm bảo tính nhất quán dữ liệu**: Tất cả trigger phải đảm bảo dữ liệu luôn nhất quán
2. **Xử lý lỗi**: Mỗi function/procedure phải có xử lý lỗi rõ ràng
3. **Transaction**: Các procedure phức tạp cần sử dụng transaction để đảm bảo atomic
4. **Performance**: Tránh các query không hiệu quả trong trigger (vì trigger chạy với mỗi row)
5. **Documentation**: Comment rõ ràng cho mỗi trigger/function/procedure
