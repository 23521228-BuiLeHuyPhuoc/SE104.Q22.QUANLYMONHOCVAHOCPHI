-- =====================================================
-- Database: ql_dangky_hocphi (Quản lý Đăng ký Môn học và Thu Học phí)
-- File: create_database.sql
-- PostgreSQL 12+
-- Mã hóa: UTF-8
-- =====================================================

-- =====================================================
-- HƯỚNG DẪN SỬ DỤNG:
-- =====================================================
-- File này dùng để TẠO DATABASE. Chạy file này TRƯỚC khi chạy init_schema.sql
--
-- Cách 1 (Terminal): 
--   psql -U postgres -f create_database.sql
--
-- Cách 2 (pgAdmin 4):
--   1. Mở pgAdmin 4
--   2. Kết nối đến server PostgreSQL
--   3. Mở Query Tool (chọn database 'postgres' hoặc bất kỳ database nào khác)
--   4. Mở file create_database.sql hoặc copy nội dung vào Query Tool
--   5. Chạy script (F5 hoặc nút Execute)
--   6. SAU KHI CHẠY XONG: Kết nối vào database 'ql_dangky_hocphi' và chạy file init_schema.sql
--
-- CẢNH BÁO: Script này sẽ XÓA database hiện tại nếu tồn tại!
-- =====================================================

-- Kết thúc tất cả connections đến database nếu tồn tại
-- CẢNH BÁO: Lệnh này sẽ ngắt kết nối của tất cả người dùng đang truy cập database
-- Đảm bảo không có giao dịch quan trọng đang thực hiện trước khi chạy
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'ql_dangky_hocphi'
  AND pid <> pg_backend_pid();

-- Xóa database nếu tồn tại (sử dụng DROP DATABASE IF EXISTS)
DROP DATABASE IF EXISTS ql_dangky_hocphi;

-- Tạo database mới
-- Lưu ý: Sử dụng locale 'C' để đảm bảo tương thích với tất cả hệ thống.
-- Nếu cần sắp xếp tiếng Việt đúng cách, hãy thay đổi thành 'vi_VN.UTF-8'
-- (yêu cầu locale này phải được cài đặt trên hệ thống)
CREATE DATABASE ql_dangky_hocphi
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TEMPLATE = template0
    CONNECTION LIMIT = -1;

-- =====================================================
-- BƯỚC TIẾP THEO:
-- =====================================================
-- Sau khi chạy file này thành công:
-- 1. Đóng Query Tool hiện tại
-- 2. Trong pgAdmin 4: Click phải vào 'Databases' -> 'Refresh'
-- 3. Mở Query Tool cho database 'ql_dangky_hocphi' 
--    (Click phải vào 'ql_dangky_hocphi' -> 'Query Tool')
-- 4. Mở và chạy file 'init_schema.sql'
-- =====================================================
