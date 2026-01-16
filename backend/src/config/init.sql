-- =====================================================
-- Database: ql_dangky_hocphi (Quản lý Đăng ký Môn học và Thu Học phí)
-- PostgreSQL 12+
-- Mã hóa: UTF-8
-- =====================================================

-- Drop tables if exist (in correct order due to foreign keys)
DROP TABLE IF EXISTS thong_bao_ca_nhan CASCADE;
DROP TABLE IF EXISTS thong_bao CASCADE;
DROP TABLE IF EXISTS phieu_thu_hoc_phi CASCADE;
DROP TABLE IF EXISTS chi_tiet_dang_ky CASCADE;
DROP TABLE IF EXISTS phieu_dang_ky CASCADE;
DROP TABLE IF EXISTS don_gia_tin_chi CASCADE;
DROP TABLE IF EXISTS lop_mo CASCADE;
DROP TABLE IF EXISTS chuong_trinh_hoc CASCADE;
DROP TABLE IF EXISTS hoc_ky CASCADE;
DROP TABLE IF EXISTS nam_hoc CASCADE;
DROP TABLE IF EXISTS lop CASCADE;
DROP TABLE IF EXISTS mon_hoc CASCADE;
DROP TABLE IF EXISTS doi_tuong_sinh_vien CASCADE;
DROP TABLE IF EXISTS quan_tri_vien CASCADE;
DROP TABLE IF EXISTS sinh_vien CASCADE;
DROP TABLE IF EXISTS tai_khoan CASCADE;
DROP TABLE IF EXISTS nganh_hoc CASCADE;
DROP TABLE IF EXISTS khoa CASCADE;
DROP TABLE IF EXISTS doi_tuong CASCADE;
DROP TABLE IF EXISTS huyen CASCADE;
DROP TABLE IF EXISTS tinh CASCADE;

-- =====================================================
-- 1. BẢNG tinh - Tỉnh/Thành phố (QĐ1)
-- =====================================================
CREATE TABLE tinh (
    ma_tinh VARCHAR(10) NOT NULL,
    ten_tinh VARCHAR(100) NOT NULL,
    trang_thai BOOLEAN DEFAULT TRUE,
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT tinh_pkey PRIMARY KEY (ma_tinh)
);

-- =====================================================
-- 2. BẢNG huyen - Huyện/Quận (QĐ1)
-- =====================================================
CREATE TABLE huyen (
    ma_huyen VARCHAR(10) NOT NULL,
    ten_huyen VARCHAR(100) NOT NULL,
    ma_tinh VARCHAR(10) NOT NULL,
    la_vung_sau_vung_xa BOOLEAN DEFAULT FALSE,
    trang_thai BOOLEAN DEFAULT TRUE,
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT huyen_pkey PRIMARY KEY (ma_huyen),
    CONSTRAINT fk_huyen_tinh FOREIGN KEY (ma_tinh) 
        REFERENCES tinh(ma_tinh) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- =====================================================
-- 3. BẢNG doi_tuong - Đối tượng ưu tiên (QĐ1)
-- =====================================================
CREATE TABLE doi_tuong (
    ma_doi_tuong VARCHAR(10) NOT NULL,
    ten_doi_tuong VARCHAR(100) NOT NULL,
    ti_le_giam_hoc_phi DECIMAL(5,2) NOT NULL,
    do_uu_tien INTEGER NOT NULL,
    mo_ta VARCHAR(300),
    trang_thai BOOLEAN DEFAULT TRUE,
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT doi_tuong_pkey PRIMARY KEY (ma_doi_tuong),
    CONSTRAINT chk_ti_le_giam CHECK (ti_le_giam_hoc_phi >= 0 AND ti_le_giam_hoc_phi <= 100)
);

-- =====================================================
-- 4. BẢNG khoa - Khoa (QĐ1)
-- =====================================================
CREATE TABLE khoa (
    ma_khoa VARCHAR(10) NOT NULL,
    ten_khoa VARCHAR(100) NOT NULL,
    ten_viet_tat VARCHAR(20),
    sdt VARCHAR(15),
    email VARCHAR(100),
    dia_chi VARCHAR(200),
    truong_khoa VARCHAR(100),
    trang_thai BOOLEAN DEFAULT TRUE,
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT khoa_pkey PRIMARY KEY (ma_khoa)
);

-- =====================================================
-- 5. BẢNG nganh_hoc - Ngành học (QĐ1)
-- =====================================================
CREATE TABLE nganh_hoc (
    ma_nganh VARCHAR(10) NOT NULL,
    ten_nganh VARCHAR(100) NOT NULL,
    ma_khoa VARCHAR(10) NOT NULL,
    so_tin_chi_toi_thieu INTEGER DEFAULT 120,
    thoi_gian_dao_tao DECIMAL(3,1) DEFAULT 4,
    mo_ta VARCHAR(500),
    trang_thai BOOLEAN DEFAULT TRUE,
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT nganh_hoc_pkey PRIMARY KEY (ma_nganh),
    CONSTRAINT fk_nganh_khoa FOREIGN KEY (ma_khoa) 
        REFERENCES khoa(ma_khoa) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- =====================================================
-- 6. BẢNG tai_khoan - Tài khoản đăng nhập
-- =====================================================
CREATE TABLE tai_khoan (
    ma_tai_khoan SERIAL NOT NULL,
    ten_dang_nhap VARCHAR(50) NOT NULL,
    mat_khau VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'sinh_vien',
    ma_sv VARCHAR(15),
    ho_ten VARCHAR(100),
    email VARCHAR(100),
    sdt VARCHAR(15),
    anh_dai_dien VARCHAR(255),
    lan_dang_nhap_cuoi TIMESTAMP,
    refresh_token VARCHAR(500),
    trang_thai BOOLEAN DEFAULT TRUE,
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ngay_cap_nhat TIMESTAMP,
    CONSTRAINT tai_khoan_pkey PRIMARY KEY (ma_tai_khoan),
    CONSTRAINT tai_khoan_ten_dang_nhap_key UNIQUE (ten_dang_nhap),
    CONSTRAINT chk_role CHECK (role IN ('admin', 'sinh_vien'))
);

-- =====================================================
-- 7. BẢNG sinh_vien - Sinh viên (BM1, QĐ1)
-- =====================================================
CREATE TABLE sinh_vien (
    ma_sv VARCHAR(15) NOT NULL,
    ma_tai_khoan INTEGER,
    ho_ten VARCHAR(100) NOT NULL,
    ngay_sinh DATE NOT NULL,
    gioi_tinh VARCHAR(5) NOT NULL,
    cccd VARCHAR(20),
    ma_huyen VARCHAR(10) NOT NULL,
    ma_nganh VARCHAR(10) NOT NULL,
    dia_chi_lien_he VARCHAR(200),
    sdt VARCHAR(15),
    email VARCHAR(100),
    anh_dai_dien VARCHAR(255),
    ho_ten_cha VARCHAR(100),
    sdt_cha VARCHAR(15),
    ho_ten_me VARCHAR(100),
    sdt_me VARCHAR(15),
    ngay_nhap_hoc DATE DEFAULT CURRENT_DATE,
    trang_thai VARCHAR(30) DEFAULT 'Đang học',
    ghi_chu VARCHAR(300),
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ngay_cap_nhat TIMESTAMP,
    CONSTRAINT sinh_vien_pkey PRIMARY KEY (ma_sv),
    CONSTRAINT sinh_vien_cccd_key UNIQUE (cccd),
    CONSTRAINT sinh_vien_ma_tai_khoan_key UNIQUE (ma_tai_khoan),
    CONSTRAINT chk_gioi_tinh CHECK (gioi_tinh IN ('Nam', 'Nữ')),
    CONSTRAINT chk_trang_thai_sv CHECK (trang_thai IN ('Đang học', 'Bảo lưu', 'Nghỉ học', 'Tốt nghiệp')),
    CONSTRAINT fk_sv_huyen FOREIGN KEY (ma_huyen) 
        REFERENCES huyen(ma_huyen) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_sv_nganh FOREIGN KEY (ma_nganh) 
        REFERENCES nganh_hoc(ma_nganh) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_sv_tk FOREIGN KEY (ma_tai_khoan) 
        REFERENCES tai_khoan(ma_tai_khoan) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Add FK from tai_khoan to sinh_vien (bidirectional relationship)
ALTER TABLE tai_khoan 
    ADD CONSTRAINT fk_tk_sv FOREIGN KEY (ma_sv) 
    REFERENCES sinh_vien(ma_sv) ON DELETE SET NULL ON UPDATE CASCADE;

-- Add unique constraint for ma_sv in tai_khoan
ALTER TABLE tai_khoan 
    ADD CONSTRAINT tai_khoan_ma_sv_key UNIQUE (ma_sv);

-- =====================================================
-- 8. BẢNG doi_tuong_sinh_vien - Đối tượng của Sinh viên (QĐ1)
-- =====================================================
CREATE TABLE doi_tuong_sinh_vien (
    id SERIAL NOT NULL,
    ma_sv VARCHAR(15) NOT NULL,
    ma_doi_tuong VARCHAR(10) NOT NULL,
    file_minh_chung VARCHAR(255),
    ghi_chu VARCHAR(200),
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT doi_tuong_sinh_vien_pkey PRIMARY KEY (id),
    CONSTRAINT uq_dtsv UNIQUE (ma_sv, ma_doi_tuong),
    CONSTRAINT fk_dtsv_sv FOREIGN KEY (ma_sv) 
        REFERENCES sinh_vien(ma_sv) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_dtsv_dt FOREIGN KEY (ma_doi_tuong) 
        REFERENCES doi_tuong(ma_doi_tuong) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- =====================================================
-- 9. BẢNG quan_tri_vien - Quản trị viên
-- =====================================================
CREATE TABLE quan_tri_vien (
    ma_quan_tri_vien SERIAL NOT NULL,
    ma_tai_khoan INTEGER NOT NULL,
    ho_ten VARCHAR(100) NOT NULL,
    ngay_sinh DATE,
    gioi_tinh VARCHAR(5),
    sdt VARCHAR(15),
    email VARCHAR(100),
    dia_chi VARCHAR(200),
    chuc_vu VARCHAR(100),
    phong_ban VARCHAR(100),
    anh_dai_dien VARCHAR(255),
    ghi_chu VARCHAR(300),
    trang_thai BOOLEAN DEFAULT TRUE,
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ngay_cap_nhat TIMESTAMP,
    CONSTRAINT quan_tri_vien_pkey PRIMARY KEY (ma_quan_tri_vien),
    CONSTRAINT quan_tri_vien_ma_tai_khoan_key UNIQUE (ma_tai_khoan),
    CONSTRAINT chk_gioi_tinh_qtv CHECK (gioi_tinh IN ('Nam', 'Nữ')),
    CONSTRAINT fk_qtv_tk FOREIGN KEY (ma_tai_khoan) 
        REFERENCES tai_khoan(ma_tai_khoan) ON DELETE CASCADE ON UPDATE CASCADE
);

-- =====================================================
-- 10. BẢNG mon_hoc - Môn học (BM2, QĐ2)
-- =====================================================
CREATE TABLE mon_hoc (
    ma_mon_hoc VARCHAR(15) NOT NULL,
    ten_mon_hoc VARCHAR(150) NOT NULL,
    ma_khoa VARCHAR(10) NOT NULL,
    loai_mon VARCHAR(5) NOT NULL,
    so_tiet INTEGER NOT NULL,
    so_tin_chi INTEGER GENERATED ALWAYS AS (
        CASE 
            WHEN loai_mon = 'LT' THEN so_tiet / 15
            WHEN loai_mon = 'TH' THEN so_tiet / 30
            ELSE 0
        END
    ) STORED,
    mo_ta VARCHAR(500),
    trang_thai BOOLEAN DEFAULT TRUE,
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT mon_hoc_pkey PRIMARY KEY (ma_mon_hoc),
    CONSTRAINT chk_loai_mon CHECK (loai_mon IN ('LT', 'TH')),
    CONSTRAINT chk_so_tiet CHECK (so_tiet > 0),
    CONSTRAINT fk_monhoc_khoa FOREIGN KEY (ma_khoa) 
        REFERENCES khoa(ma_khoa) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- =====================================================
-- 11. BẢNG lop - Lớp học
-- =====================================================
CREATE TABLE lop (
    ma_lop VARCHAR(20) NOT NULL,
    ten_lop VARCHAR(100) NOT NULL,
    ma_mon_hoc VARCHAR(15) NOT NULL,
    giang_vien VARCHAR(100),
    lich_hoc VARCHAR(200),
    phong_hoc VARCHAR(50),
    so_luong_toi_da INTEGER DEFAULT 50,
    mo_ta VARCHAR(300),
    trang_thai BOOLEAN DEFAULT TRUE,
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT lop_pkey PRIMARY KEY (ma_lop),
    CONSTRAINT fk_lop_monhoc FOREIGN KEY (ma_mon_hoc) 
        REFERENCES mon_hoc(ma_mon_hoc) ON DELETE CASCADE ON UPDATE CASCADE
);

-- =====================================================
-- 12. BẢNG chuong_trinh_hoc - Chương trình học (BM3, QĐ3)
-- =====================================================
CREATE TABLE chuong_trinh_hoc (
    id SERIAL NOT NULL,
    ma_nganh VARCHAR(10) NOT NULL,
    ma_mon_hoc VARCHAR(15) NOT NULL,
    hoc_ky_du_kien INTEGER NOT NULL,
    bat_buoc BOOLEAN DEFAULT TRUE,
    ghi_chu VARCHAR(200),
    trang_thai BOOLEAN DEFAULT TRUE,
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chuong_trinh_hoc_pkey PRIMARY KEY (id),
    CONSTRAINT uq_cth UNIQUE (ma_nganh, ma_mon_hoc),
    CONSTRAINT chk_hoc_ky_du_kien CHECK (hoc_ky_du_kien >= 1 AND hoc_ky_du_kien <= 10),
    CONSTRAINT fk_cth_nganh FOREIGN KEY (ma_nganh) 
        REFERENCES nganh_hoc(ma_nganh) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cth_mon FOREIGN KEY (ma_mon_hoc) 
        REFERENCES mon_hoc(ma_mon_hoc) ON DELETE CASCADE ON UPDATE CASCADE
);

-- =====================================================
-- 13. BẢNG nam_hoc - Năm học (BM4)
-- =====================================================
CREATE TABLE nam_hoc (
    ma_nam_hoc VARCHAR(15) NOT NULL,
    ten_nam_hoc VARCHAR(50) NOT NULL,
    nam_bat_dau INTEGER NOT NULL,
    nam_ket_thuc INTEGER NOT NULL,
    trang_thai BOOLEAN DEFAULT TRUE,
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT nam_hoc_pkey PRIMARY KEY (ma_nam_hoc)
);

-- =====================================================
-- 14. BẢNG hoc_ky - Học kỳ (BM4, QĐ4, QĐ6)
-- =====================================================
CREATE TABLE hoc_ky (
    ma_hoc_ky VARCHAR(15) NOT NULL,
    ten_hoc_ky VARCHAR(50) NOT NULL,
    ma_nam_hoc VARCHAR(15) NOT NULL,
    loai_hoc_ky VARCHAR(20) DEFAULT 'Chính',
    thu_tu INTEGER DEFAULT 1,
    ngay_bat_dau DATE,
    ngay_ket_thuc DATE,
    ngay_bat_dau_dang_ky TIMESTAMP,
    ngay_ket_thuc_dang_ky TIMESTAMP,
    han_dong_hoc_phi DATE,
    trang_thai VARCHAR(20) DEFAULT 'Sắp diễn ra',
    ghi_chu VARCHAR(300),
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT hoc_ky_pkey PRIMARY KEY (ma_hoc_ky),
    CONSTRAINT chk_loai_hoc_ky CHECK (loai_hoc_ky IN ('Chính', 'Hè')),
    CONSTRAINT chk_trang_thai_hk CHECK (trang_thai IN ('Sắp diễn ra', 'Đang diễn ra', 'Đã kết thúc')),
    CONSTRAINT fk_hk_namhoc FOREIGN KEY (ma_nam_hoc) 
        REFERENCES nam_hoc(ma_nam_hoc) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- =====================================================
-- 15. BẢNG lop_mo - Lớp mở trong học kỳ (BM4, QĐ4, QĐ5)
-- =====================================================
CREATE TABLE lop_mo (
    id SERIAL NOT NULL,
    ma_hoc_ky VARCHAR(15) NOT NULL,
    ma_lop VARCHAR(20) NOT NULL,
    so_luong_da_dang_ky INTEGER DEFAULT 0,
    ghi_chu VARCHAR(200),
    trang_thai BOOLEAN DEFAULT TRUE,
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT lop_mo_pkey PRIMARY KEY (id),
    CONSTRAINT uq_lopmo UNIQUE (ma_hoc_ky, ma_lop),
    CONSTRAINT fk_lopmo_hocky FOREIGN KEY (ma_hoc_ky) 
        REFERENCES hoc_ky(ma_hoc_ky) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_lopmo_lop FOREIGN KEY (ma_lop) 
        REFERENCES lop(ma_lop) ON DELETE CASCADE ON UPDATE CASCADE
);

-- =====================================================
-- 16. BẢNG don_gia_tin_chi - Đơn giá tín chỉ (QĐ5)
-- =====================================================
CREATE TABLE don_gia_tin_chi (
    id SERIAL NOT NULL,
    loai_mon VARCHAR(5) NOT NULL,
    loai_hoc VARCHAR(20) NOT NULL DEFAULT 'hoc_moi',
    don_gia DECIMAL(12,0) NOT NULL,
    ma_hoc_ky VARCHAR(15),
    ngay_ap_dung DATE DEFAULT CURRENT_DATE,
    trang_thai BOOLEAN DEFAULT TRUE,
    ghi_chu VARCHAR(200),
    CONSTRAINT don_gia_tin_chi_pkey PRIMARY KEY (id),
    CONSTRAINT uq_dgtc UNIQUE (loai_mon, loai_hoc, ma_hoc_ky),
    CONSTRAINT chk_loai_mon_dg CHECK (loai_mon IN ('LT', 'TH')),
    CONSTRAINT chk_loai_hoc CHECK (loai_hoc IN ('hoc_moi', 'hoc_lai', 'hoc_cai_thien', 'hoc_he')),
    CONSTRAINT fk_dgtc_hk FOREIGN KEY (ma_hoc_ky) 
        REFERENCES hoc_ky(ma_hoc_ky) ON DELETE SET NULL ON UPDATE CASCADE
);

-- =====================================================
-- 17. BẢNG phieu_dang_ky - Phiếu đăng ký học phần (BM5, QĐ5, QĐ7)
-- =====================================================
CREATE TABLE phieu_dang_ky (
    so_phieu SERIAL NOT NULL,
    ma_sv VARCHAR(15) NOT NULL,
    ma_hoc_ky VARCHAR(15) NOT NULL,
    ngay_lap TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tong_tin_chi INTEGER DEFAULT 0,
    tong_tien_dang_ky DECIMAL(15,0) DEFAULT 0,
    ti_le_giam DECIMAL(5,2) DEFAULT 0,
    tien_mien_giam DECIMAL(15,0) DEFAULT 0,
    tong_tien_phai_dong DECIMAL(15,0) DEFAULT 0,
    trang_thai VARCHAR(30) DEFAULT 'Đã đăng ký',
    ghi_chu VARCHAR(300),
    ngay_cap_nhat TIMESTAMP,
    CONSTRAINT phieu_dang_ky_pkey PRIMARY KEY (so_phieu),
    CONSTRAINT uq_pdk UNIQUE (ma_sv, ma_hoc_ky),
    CONSTRAINT chk_trang_thai_pdk CHECK (trang_thai IN ('Đã đăng ký', 'Đã hủy')),
    CONSTRAINT fk_pdk_sv FOREIGN KEY (ma_sv) 
        REFERENCES sinh_vien(ma_sv) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pdk_hk FOREIGN KEY (ma_hoc_ky) 
        REFERENCES hoc_ky(ma_hoc_ky) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- =====================================================
-- 18. BẢNG chi_tiet_dang_ky - Chi tiết đăng ký (BM5, QĐ5)
-- =====================================================
CREATE TABLE chi_tiet_dang_ky (
    id SERIAL NOT NULL,
    so_phieu INTEGER NOT NULL,
    ma_lop VARCHAR(20) NOT NULL,
    loai_dang_ky VARCHAR(20) DEFAULT 'hoc_moi',
    so_tin_chi INTEGER NOT NULL,
    loai_mon VARCHAR(5) NOT NULL,
    don_gia DECIMAL(12,0) NOT NULL,
    thanh_tien DECIMAL(15,0) NOT NULL,
    trang_thai VARCHAR(30) DEFAULT 'Đã đăng ký',
    ngay_dang_ky TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ngay_huy TIMESTAMP,
    ly_do_huy VARCHAR(200),
    CONSTRAINT chi_tiet_dang_ky_pkey PRIMARY KEY (id),
    CONSTRAINT uq_ctdk UNIQUE (so_phieu, ma_lop),
    CONSTRAINT chk_trang_thai_ctdk CHECK (trang_thai IN ('Đã đăng ký', 'Đã hủy')),
    CONSTRAINT chk_loai_dang_ky CHECK (loai_dang_ky IN ('hoc_moi', 'hoc_lai', 'hoc_cai_thien')),
    CONSTRAINT fk_ctdk_phieu FOREIGN KEY (so_phieu) 
        REFERENCES phieu_dang_ky(so_phieu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ctdk_lop FOREIGN KEY (ma_lop) 
        REFERENCES lop(ma_lop) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- =====================================================
-- 19. BẢNG phieu_thu_hoc_phi - Phiếu thu học phí (BM6, QĐ6)
-- =====================================================
CREATE TABLE phieu_thu_hoc_phi (
    so_phieu_thu SERIAL NOT NULL,
    so_phieu_dang_ky INTEGER NOT NULL,
    ma_sv VARCHAR(15) NOT NULL,
    ngay_lap TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    so_tien_thu DECIMAL(15,0) NOT NULL,
    hinh_thuc_thu VARCHAR(50) DEFAULT 'Tiền mặt',
    ma_giao_dich VARCHAR(100),
    nguoi_thu VARCHAR(100),
    ghi_chu VARCHAR(300),
    trang_thai VARCHAR(20) DEFAULT 'Thành công',
    CONSTRAINT phieu_thu_hoc_phi_pkey PRIMARY KEY (so_phieu_thu),
    CONSTRAINT chk_so_tien_thu CHECK (so_tien_thu > 0),
    CONSTRAINT chk_hinh_thuc_thu CHECK (hinh_thuc_thu IN ('Tiền mặt', 'Chuyển khoản', 'Thẻ', 'Ví điện tử')),
    CONSTRAINT chk_trang_thai_pthp CHECK (trang_thai IN ('Thành công', 'Đã hủy')),
    CONSTRAINT fk_pthp_pdk FOREIGN KEY (so_phieu_dang_ky) 
        REFERENCES phieu_dang_ky(so_phieu) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pthp_sv FOREIGN KEY (ma_sv) 
        REFERENCES sinh_vien(ma_sv) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- =====================================================
-- 20. BẢNG thong_bao - Thông báo chung
-- =====================================================
CREATE TABLE thong_bao (
    ma_thong_bao SERIAL NOT NULL,
    tieu_de VARCHAR(200) NOT NULL,
    noi_dung TEXT NOT NULL,
    loai_thong_bao VARCHAR(50),
    doi_tuong VARCHAR(30) DEFAULT 'Tất cả',
    ghim_top BOOLEAN DEFAULT FALSE,
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ngay_het_han TIMESTAMP,
    nguoi_tao INTEGER,
    trang_thai BOOLEAN DEFAULT TRUE,
    CONSTRAINT thong_bao_pkey PRIMARY KEY (ma_thong_bao),
    CONSTRAINT fk_tb_nguoitao FOREIGN KEY (nguoi_tao) 
        REFERENCES tai_khoan(ma_tai_khoan) ON DELETE SET NULL ON UPDATE CASCADE
);

-- =====================================================
-- 21. BẢNG thong_bao_ca_nhan - Thông báo cá nhân
-- =====================================================
CREATE TABLE thong_bao_ca_nhan (
    id BIGSERIAL NOT NULL,
    ma_tai_khoan INTEGER NOT NULL,
    tieu_de VARCHAR(200) NOT NULL,
    noi_dung TEXT,
    loai_thong_bao VARCHAR(50),
    duong_dan VARCHAR(255),
    da_doc BOOLEAN DEFAULT FALSE,
    ngay_doc TIMESTAMP,
    ngay_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT thong_bao_ca_nhan_pkey PRIMARY KEY (id),
    CONSTRAINT fk_tbcn_tk FOREIGN KEY (ma_tai_khoan) 
        REFERENCES tai_khoan(ma_tai_khoan) ON DELETE CASCADE ON UPDATE CASCADE
);

-- =====================================================
-- INDEXES - Tối ưu hiệu suất truy vấn
-- =====================================================

-- Index cho bảng huyen
CREATE INDEX idx_huyen_ma_tinh ON huyen(ma_tinh);

-- Index cho bảng nganh_hoc
CREATE INDEX idx_nganh_ma_khoa ON nganh_hoc(ma_khoa);

-- Index cho bảng sinh_vien
CREATE INDEX idx_sv_ma_huyen ON sinh_vien(ma_huyen);
CREATE INDEX idx_sv_ma_nganh ON sinh_vien(ma_nganh);
CREATE INDEX idx_sv_ma_tai_khoan ON sinh_vien(ma_tai_khoan);
CREATE INDEX idx_sv_trang_thai ON sinh_vien(trang_thai);

-- Index cho bảng tai_khoan
CREATE INDEX idx_tk_ten_dang_nhap ON tai_khoan(ten_dang_nhap);
CREATE INDEX idx_tk_role ON tai_khoan(role);

-- Index cho bảng doi_tuong_sinh_vien
CREATE INDEX idx_dtsv_ma_sv ON doi_tuong_sinh_vien(ma_sv);
CREATE INDEX idx_dtsv_ma_doi_tuong ON doi_tuong_sinh_vien(ma_doi_tuong);

-- Index cho bảng mon_hoc
CREATE INDEX idx_mh_ma_khoa ON mon_hoc(ma_khoa);
CREATE INDEX idx_mh_loai_mon ON mon_hoc(loai_mon);

-- Index cho bảng lop
CREATE INDEX idx_lop_ma_mon_hoc ON lop(ma_mon_hoc);

-- Index cho bảng chuong_trinh_hoc
CREATE INDEX idx_cth_ma_nganh ON chuong_trinh_hoc(ma_nganh);
CREATE INDEX idx_cth_ma_mon_hoc ON chuong_trinh_hoc(ma_mon_hoc);

-- Index cho bảng hoc_ky
CREATE INDEX idx_hk_ma_nam_hoc ON hoc_ky(ma_nam_hoc);
CREATE INDEX idx_hk_trang_thai ON hoc_ky(trang_thai);

-- Index cho bảng lop_mo
CREATE INDEX idx_lm_ma_hoc_ky ON lop_mo(ma_hoc_ky);
CREATE INDEX idx_lm_ma_lop ON lop_mo(ma_lop);

-- Index cho bảng don_gia_tin_chi
CREATE INDEX idx_dgtc_loai_mon ON don_gia_tin_chi(loai_mon);
CREATE INDEX idx_dgtc_loai_hoc ON don_gia_tin_chi(loai_hoc);

-- Index cho bảng phieu_dang_ky
CREATE INDEX idx_pdk_ma_sv ON phieu_dang_ky(ma_sv);
CREATE INDEX idx_pdk_ma_hoc_ky ON phieu_dang_ky(ma_hoc_ky);
CREATE INDEX idx_pdk_trang_thai ON phieu_dang_ky(trang_thai);

-- Index cho bảng chi_tiet_dang_ky
CREATE INDEX idx_ctdk_so_phieu ON chi_tiet_dang_ky(so_phieu);
CREATE INDEX idx_ctdk_ma_lop ON chi_tiet_dang_ky(ma_lop);
CREATE INDEX idx_ctdk_trang_thai ON chi_tiet_dang_ky(trang_thai);

-- Index cho bảng phieu_thu_hoc_phi
CREATE INDEX idx_pthp_so_phieu_dang_ky ON phieu_thu_hoc_phi(so_phieu_dang_ky);
CREATE INDEX idx_pthp_ma_sv ON phieu_thu_hoc_phi(ma_sv);
CREATE INDEX idx_pthp_trang_thai ON phieu_thu_hoc_phi(trang_thai);

-- Index cho bảng thong_bao
CREATE INDEX idx_tb_nguoi_tao ON thong_bao(nguoi_tao);
CREATE INDEX idx_tb_trang_thai ON thong_bao(trang_thai);

-- Index cho bảng thong_bao_ca_nhan
CREATE INDEX idx_tbcn_ma_tai_khoan ON thong_bao_ca_nhan(ma_tai_khoan);
CREATE INDEX idx_tbcn_da_doc ON thong_bao_ca_nhan(da_doc);

-- =====================================================
-- FUNCTIONS - Các hàm nghiệp vụ
-- =====================================================

-- Function 1: Lấy tỷ lệ giảm học phí của sinh viên (QĐ1)
CREATE OR REPLACE FUNCTION fn_lay_ti_le_giam_hoc_phi(p_ma_sv VARCHAR)
RETURNS DECIMAL(5,2) AS $$
DECLARE
    v_ti_le DECIMAL(5,2);
    v_la_vung_sau_xa BOOLEAN;
BEGIN
    -- Lấy tỷ lệ giảm từ đối tượng ưu tiên cao nhất
    SELECT dt.ti_le_giam_hoc_phi INTO v_ti_le
    FROM doi_tuong_sinh_vien dtsv
    JOIN doi_tuong dt ON dtsv.ma_doi_tuong = dt.ma_doi_tuong
    WHERE dtsv.ma_sv = p_ma_sv AND dt.trang_thai = TRUE
    ORDER BY dt.do_uu_tien ASC
    LIMIT 1;
    
    -- Nếu chưa có đối tượng, kiểm tra vùng sâu vùng xa
    IF v_ti_le IS NULL THEN
        SELECT h.la_vung_sau_vung_xa INTO v_la_vung_sau_xa
        FROM sinh_vien sv
        JOIN huyen h ON sv.ma_huyen = h.ma_huyen
        WHERE sv.ma_sv = p_ma_sv;
        
        IF v_la_vung_sau_xa = TRUE THEN
            -- Lấy tỷ lệ giảm của đối tượng vùng sâu vùng xa
            SELECT ti_le_giam_hoc_phi INTO v_ti_le
            FROM doi_tuong
            WHERE LOWER(ten_doi_tuong) LIKE '%vùng sâu%' OR LOWER(ten_doi_tuong) LIKE '%vùng xa%'
            LIMIT 1;
        END IF;
    END IF;
    
    RETURN COALESCE(v_ti_le, 0);
END;
$$ LANGUAGE plpgsql;

-- Function 2: Lấy đơn giá tín chỉ (QĐ5)
CREATE OR REPLACE FUNCTION fn_lay_don_gia(
    p_loai_mon VARCHAR, 
    p_loai_hoc VARCHAR DEFAULT 'hoc_moi',
    p_ma_hoc_ky VARCHAR DEFAULT NULL
)
RETURNS DECIMAL(12,0) AS $$
DECLARE
    v_don_gia DECIMAL(12,0);
    v_loai_hoc_ky VARCHAR(20);
BEGIN
    -- Xác định loại học: nếu học kỳ hè thì áp dụng giá học hè
    IF p_ma_hoc_ky IS NOT NULL THEN
        SELECT loai_hoc_ky INTO v_loai_hoc_ky
        FROM hoc_ky WHERE ma_hoc_ky = p_ma_hoc_ky;
        
        IF v_loai_hoc_ky = 'Hè' AND p_loai_hoc = 'hoc_moi' THEN
            -- Nếu là học kỳ hè, áp dụng giá học hè
            SELECT don_gia INTO v_don_gia
            FROM don_gia_tin_chi
            WHERE loai_mon = p_loai_mon 
              AND loai_hoc = 'hoc_he' 
              AND trang_thai = TRUE
              AND (ma_hoc_ky = p_ma_hoc_ky OR ma_hoc_ky IS NULL)
            ORDER BY ma_hoc_ky DESC NULLS LAST
            LIMIT 1;
        END IF;
    END IF;
    
    -- Nếu chưa có giá, lấy theo loại học cụ thể
    IF v_don_gia IS NULL THEN
        SELECT don_gia INTO v_don_gia
        FROM don_gia_tin_chi
        WHERE loai_mon = p_loai_mon 
          AND loai_hoc = p_loai_hoc 
          AND trang_thai = TRUE
          AND (ma_hoc_ky = p_ma_hoc_ky OR ma_hoc_ky IS NULL)
        ORDER BY ma_hoc_ky DESC NULLS LAST
        LIMIT 1;
    END IF;
    
    -- Mặc định theo QĐ5 (học mới)
    IF v_don_gia IS NULL THEN
        v_don_gia := CASE 
            WHEN p_loai_mon = 'LT' AND p_loai_hoc = 'hoc_moi' THEN 27000
            WHEN p_loai_mon = 'TH' AND p_loai_hoc = 'hoc_moi' THEN 37000
            WHEN p_loai_mon = 'LT' AND p_loai_hoc = 'hoc_lai' THEN 32000
            WHEN p_loai_mon = 'TH' AND p_loai_hoc = 'hoc_lai' THEN 42000
            WHEN p_loai_mon = 'LT' AND p_loai_hoc = 'hoc_cai_thien' THEN 30000
            WHEN p_loai_mon = 'TH' AND p_loai_hoc = 'hoc_cai_thien' THEN 40000
            WHEN p_loai_mon = 'LT' AND p_loai_hoc = 'hoc_he' THEN 35000
            WHEN p_loai_mon = 'TH' AND p_loai_hoc = 'hoc_he' THEN 45000
            ELSE 27000
        END;
    END IF;
    
    RETURN v_don_gia;
END;
$$ LANGUAGE plpgsql;

-- Function 3: Đăng ký lớp học (BM5, QĐ5)
CREATE OR REPLACE FUNCTION sp_dang_ky_lop(
    p_ma_sv VARCHAR,
    p_ma_hoc_ky VARCHAR,
    p_ma_lop VARCHAR,
    p_loai_dang_ky VARCHAR DEFAULT 'hoc_moi'
) RETURNS TEXT AS $$
DECLARE
    v_so_phieu INTEGER;
    v_so_tin_chi INTEGER;
    v_loai_mon VARCHAR(5);
    v_don_gia DECIMAL(12,0);
    v_thanh_tien DECIMAL(15,0);
    v_ti_le_giam DECIMAL(5,2);
    v_ma_mon_hoc VARCHAR(15);
BEGIN
    -- Kiểm tra lớp có mở trong học kỳ không
    IF NOT EXISTS (
        SELECT 1 FROM lop_mo 
        WHERE ma_hoc_ky = p_ma_hoc_ky 
          AND ma_lop = p_ma_lop 
          AND trang_thai = TRUE
    ) THEN
        RETURN 'Lớp học không mở trong học kỳ này';
    END IF;
    
    -- Kiểm tra sĩ số còn chỗ
    IF EXISTS (
        SELECT 1 FROM lop_mo lm
        JOIN lop l ON lm.ma_lop = l.ma_lop
        WHERE lm.ma_hoc_ky = p_ma_hoc_ky 
          AND lm.ma_lop = p_ma_lop
          AND lm.so_luong_da_dang_ky >= l.so_luong_toi_da
    ) THEN
        RETURN 'Lớp học đã đầy';
    END IF;
    
    -- Lấy thông tin lớp và môn học
    SELECT mh.ma_mon_hoc, mh.so_tin_chi, mh.loai_mon 
    INTO v_ma_mon_hoc, v_so_tin_chi, v_loai_mon
    FROM lop l
    JOIN mon_hoc mh ON l.ma_mon_hoc = mh.ma_mon_hoc
    WHERE l.ma_lop = p_ma_lop;
    
    -- Lấy đơn giá theo loại học (QĐ5)
    v_don_gia := fn_lay_don_gia(v_loai_mon, p_loai_dang_ky, p_ma_hoc_ky);
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
    
    -- Kiểm tra đã đăng ký lớp này chưa
    IF EXISTS (
        SELECT 1 FROM chi_tiet_dang_ky 
        WHERE so_phieu = v_so_phieu 
          AND ma_lop = p_ma_lop 
          AND trang_thai = 'Đã đăng ký'
    ) THEN
        RETURN 'Đã đăng ký lớp này';
    END IF;
    
    -- Thêm chi tiết đăng ký
    INSERT INTO chi_tiet_dang_ky (
        so_phieu, ma_lop, loai_dang_ky, so_tin_chi, loai_mon, don_gia, thanh_tien
    ) VALUES (
        v_so_phieu, p_ma_lop, p_loai_dang_ky, v_so_tin_chi, v_loai_mon, v_don_gia, v_thanh_tien
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
    
    -- Cập nhật số lượng đăng ký của lớp mở
    UPDATE lop_mo 
    SET so_luong_da_dang_ky = so_luong_da_dang_ky + 1
    WHERE ma_hoc_ky = p_ma_hoc_ky AND ma_lop = p_ma_lop;
    
    RETURN 'Đăng ký thành công';
END;
$$ LANGUAGE plpgsql;

-- Function 4: Thu học phí (BM6, QĐ6)
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
    
    RETURN 'Thu học phí thành công. Còn lại: ' || 
           TO_CHAR(v_con_lai - p_so_tien_thu, 'FM999,999,999') || 'đ';
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- VIEWS - Các view báo cáo
-- =====================================================

-- View: Phiếu đăng ký chi tiết
CREATE OR REPLACE VIEW v_phieu_dang_ky AS
SELECT 
    pdk.so_phieu,
    sv.ma_sv AS ma_so_sinh_vien,
    sv.ho_ten AS ho_ten_sinh_vien,
    nh.ten_nganh,
    hk.ma_hoc_ky,
    hk.ten_hoc_ky,
    namhoc.ten_nam_hoc,
    pdk.ngay_lap,
    pdk.tong_tin_chi,
    pdk.tong_tien_dang_ky,
    pdk.ti_le_giam,
    pdk.tien_mien_giam,
    pdk.tong_tien_phai_dong,
    COALESCE((
        SELECT SUM(so_tien_thu) FROM phieu_thu_hoc_phi 
        WHERE so_phieu_dang_ky = pdk.so_phieu AND trang_thai = 'Thành công'
    ), 0) AS da_dong,
    pdk.tong_tien_phai_dong - COALESCE((
        SELECT SUM(so_tien_thu) FROM phieu_thu_hoc_phi 
        WHERE so_phieu_dang_ky = pdk.so_phieu AND trang_thai = 'Thành công'
    ), 0) AS con_no,
    pdk.trang_thai
FROM phieu_dang_ky pdk
JOIN sinh_vien sv ON pdk.ma_sv = sv.ma_sv
JOIN nganh_hoc nh ON sv.ma_nganh = nh.ma_nganh
JOIN hoc_ky hk ON pdk.ma_hoc_ky = hk.ma_hoc_ky
JOIN nam_hoc namhoc ON hk.ma_nam_hoc = namhoc.ma_nam_hoc;

-- View: Phiếu thu học phí chi tiết
CREATE OR REPLACE VIEW v_phieu_thu_hoc_phi AS
SELECT 
    pthp.so_phieu_thu,
    sv.ma_sv AS ma_so_sinh_vien,
    sv.ho_ten AS ho_ten_sinh_vien,
    hk.ma_hoc_ky,
    hk.ten_hoc_ky,
    pthp.ngay_lap,
    pthp.so_tien_thu,
    pthp.hinh_thuc_thu,
    pthp.ma_giao_dich,
    pthp.nguoi_thu,
    pthp.ghi_chu,
    pthp.trang_thai
FROM phieu_thu_hoc_phi pthp
JOIN sinh_vien sv ON pthp.ma_sv = sv.ma_sv
JOIN phieu_dang_ky pdk ON pthp.so_phieu_dang_ky = pdk.so_phieu
JOIN hoc_ky hk ON pdk.ma_hoc_ky = hk.ma_hoc_ky;

-- View: Báo cáo SV chưa đóng học phí (BM7)
CREATE OR REPLACE VIEW v_bao_cao_sv_chua_dong_hoc_phi AS
SELECT 
    pdk.so_phieu,
    sv.ma_sv,
    sv.ho_ten,
    sv.sdt,
    sv.email,
    nh.ten_nganh,
    hk.ma_hoc_ky,
    hk.ten_hoc_ky,
    hk.han_dong_hoc_phi,
    pdk.tong_tien_phai_dong,
    COALESCE((
        SELECT SUM(so_tien_thu) FROM phieu_thu_hoc_phi 
        WHERE so_phieu_dang_ky = pdk.so_phieu AND trang_thai = 'Thành công'
    ), 0) AS da_dong,
    pdk.tong_tien_phai_dong - COALESCE((
        SELECT SUM(so_tien_thu) FROM phieu_thu_hoc_phi 
        WHERE so_phieu_dang_ky = pdk.so_phieu AND trang_thai = 'Thành công'
    ), 0) AS con_no,
    CASE 
        WHEN hk.han_dong_hoc_phi < CURRENT_DATE THEN 'Quá hạn'
        ELSE 'Trong hạn'
    END AS trang_thai
FROM phieu_dang_ky pdk
JOIN sinh_vien sv ON pdk.ma_sv = sv.ma_sv
JOIN nganh_hoc nh ON sv.ma_nganh = nh.ma_nganh
JOIN hoc_ky hk ON pdk.ma_hoc_ky = hk.ma_hoc_ky
WHERE pdk.trang_thai = 'Đã đăng ký'
  AND pdk.tong_tien_phai_dong > COALESCE((
        SELECT SUM(so_tien_thu) FROM phieu_thu_hoc_phi 
        WHERE so_phieu_dang_ky = pdk.so_phieu AND trang_thai = 'Thành công'
    ), 0);

-- =====================================================
-- END OF INIT.SQL
-- =====================================================
