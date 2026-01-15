-- Database initialization script for Course Registration and Tuition Management System
-- PostgreSQL Database Schema

-- Drop tables if exist (in correct order due to foreign keys)
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS tuition_fees CASCADE;
DROP TABLE IF EXISTS course_registrations CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS semesters CASCADE;

-- Create semesters table
CREATE TABLE semesters (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    registration_start DATE,
    registration_end DATE,
    is_active BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create users table for authentication
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'student')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create students table
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    student_code VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    date_of_birth DATE,
    gender VARCHAR(10) CHECK (gender IN ('Nam', 'Nữ', 'Khác')),
    address TEXT,
    class_name VARCHAR(50),
    major VARCHAR(100),
    enrollment_year INT,
    user_id INT REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create courses table
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(200) NOT NULL,
    credits INT NOT NULL CHECK (credits > 0),
    description TEXT,
    fee_per_credit DECIMAL(12, 2) DEFAULT 0,
    max_students INT DEFAULT 50,
    semester_id INT REFERENCES semesters(id) ON DELETE CASCADE,
    schedule VARCHAR(100),
    room VARCHAR(50),
    instructor VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create course registrations table
CREATE TABLE course_registrations (
    id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(id) ON DELETE CASCADE,
    course_id INT REFERENCES courses(id) ON DELETE CASCADE,
    semester_id INT REFERENCES semesters(id) ON DELETE CASCADE,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'registered' CHECK (status IN ('registered', 'cancelled', 'completed')),
    grade DECIMAL(4, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id, course_id, semester_id)
);

-- Create tuition fees table
CREATE TABLE tuition_fees (
    id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(id) ON DELETE CASCADE,
    semester_id INT REFERENCES semesters(id) ON DELETE CASCADE,
    total_credits INT DEFAULT 0,
    total_amount DECIMAL(12, 2) DEFAULT 0,
    paid_amount DECIMAL(12, 2) DEFAULT 0,
    remaining_amount DECIMAL(12, 2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'unpaid' CHECK (status IN ('unpaid', 'partial', 'paid')),
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id, semester_id)
);

-- Create payments table
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    tuition_fee_id INT REFERENCES tuition_fees(id) ON DELETE CASCADE,
    student_id INT REFERENCES students(id) ON DELETE CASCADE,
    amount DECIMAL(12, 2) NOT NULL,
    payment_method VARCHAR(50) DEFAULT 'cash' CHECK (payment_method IN ('cash', 'bank_transfer', 'credit_card', 'momo', 'vnpay')),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_id VARCHAR(100),
    notes TEXT,
    created_by INT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data

-- Insert semesters
INSERT INTO semesters (name, year, start_date, end_date, registration_start, registration_end, is_active) VALUES
('Học kỳ 1', 2024, '2024-09-01', '2025-01-15', '2024-08-01', '2024-08-31', false),
('Học kỳ 2', 2024, '2025-02-01', '2025-06-15', '2025-01-15', '2025-01-31', true);

-- Insert admin user (password: admin123 - CHANGE THIS IN PRODUCTION!)
-- Note: In production, create admin user via application or with a secure password
INSERT INTO users (username, password, role) VALUES
('admin', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin');

-- Insert sample courses
INSERT INTO courses (course_code, course_name, credits, description, fee_per_credit, max_students, semester_id, schedule, room, instructor) VALUES
('IT001', 'Nhập môn lập trình', 4, 'Giới thiệu về lập trình cơ bản', 500000, 50, 2, 'Thứ 2, Thứ 4 (7:00-9:00)', 'A101', 'Nguyễn Văn A'),
('IT002', 'Cấu trúc dữ liệu và giải thuật', 4, 'Các cấu trúc dữ liệu và thuật toán cơ bản', 500000, 45, 2, 'Thứ 3, Thứ 5 (9:00-11:00)', 'A102', 'Trần Thị B'),
('IT003', 'Cơ sở dữ liệu', 4, 'Hệ quản trị cơ sở dữ liệu', 500000, 50, 2, 'Thứ 2, Thứ 4 (13:00-15:00)', 'B201', 'Lê Văn C'),
('IT004', 'Lập trình hướng đối tượng', 4, 'Lập trình OOP với Java', 500000, 45, 2, 'Thứ 3, Thứ 5 (13:00-15:00)', 'B202', 'Phạm Thị D'),
('IT005', 'Mạng máy tính', 3, 'Kiến thức về mạng máy tính', 500000, 40, 2, 'Thứ 6 (7:00-10:00)', 'C301', 'Hoàng Văn E'),
('MA001', 'Toán cao cấp', 3, 'Giải tích và Đại số tuyến tính', 450000, 60, 2, 'Thứ 2, Thứ 4 (9:00-11:00)', 'D101', 'Nguyễn Thị F'),
('EN001', 'Tiếng Anh 1', 3, 'Tiếng Anh cơ bản', 400000, 40, 2, 'Thứ 5, Thứ 6 (15:00-17:00)', 'E102', 'Trần Văn G'),
('PH001', 'Triết học Mác - Lênin', 3, 'Triết học đại cương', 350000, 70, 2, 'Thứ 7 (7:00-10:00)', 'F201', 'Lê Thị H');

-- Create indexes for better performance
CREATE INDEX idx_students_student_code ON students(student_code);
CREATE INDEX idx_courses_course_code ON courses(course_code);
CREATE INDEX idx_course_registrations_student ON course_registrations(student_id);
CREATE INDEX idx_course_registrations_course ON course_registrations(course_id);
CREATE INDEX idx_tuition_fees_student ON tuition_fees(student_id);
CREATE INDEX idx_payments_student ON payments(student_id);

-- Create function to update tuition fees when course registration changes
CREATE OR REPLACE FUNCTION update_tuition_fee()
RETURNS TRIGGER AS $$
DECLARE
    v_total_credits INT;
    v_total_amount DECIMAL(12, 2);
    v_paid_amount DECIMAL(12, 2);
    v_fee_id INT;
BEGIN
    -- Calculate total credits and amount for the student in the semester
    SELECT 
        COALESCE(SUM(c.credits), 0),
        COALESCE(SUM(c.credits * c.fee_per_credit), 0)
    INTO v_total_credits, v_total_amount
    FROM course_registrations cr
    JOIN courses c ON cr.course_id = c.id
    WHERE cr.student_id = COALESCE(NEW.student_id, OLD.student_id)
    AND cr.semester_id = COALESCE(NEW.semester_id, OLD.semester_id)
    AND cr.status = 'registered';

    -- Get or create tuition fee record
    SELECT id, paid_amount INTO v_fee_id, v_paid_amount
    FROM tuition_fees
    WHERE student_id = COALESCE(NEW.student_id, OLD.student_id)
    AND semester_id = COALESCE(NEW.semester_id, OLD.semester_id);

    IF v_fee_id IS NULL THEN
        INSERT INTO tuition_fees (student_id, semester_id, total_credits, total_amount, remaining_amount, due_date)
        VALUES (
            COALESCE(NEW.student_id, OLD.student_id),
            COALESCE(NEW.semester_id, OLD.semester_id),
            v_total_credits,
            v_total_amount,
            v_total_amount,
            (SELECT registration_end + INTERVAL '30 days' FROM semesters WHERE id = COALESCE(NEW.semester_id, OLD.semester_id))
        );
    ELSE
        v_paid_amount := COALESCE(v_paid_amount, 0);
        UPDATE tuition_fees
        SET 
            total_credits = v_total_credits,
            total_amount = v_total_amount,
            remaining_amount = v_total_amount - v_paid_amount,
            status = CASE 
                WHEN v_paid_amount >= v_total_amount THEN 'paid'
                WHEN v_paid_amount > 0 THEN 'partial'
                ELSE 'unpaid'
            END,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = v_fee_id;
    END IF;

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Create trigger for course registration changes
DROP TRIGGER IF EXISTS trigger_update_tuition_fee ON course_registrations;
CREATE TRIGGER trigger_update_tuition_fee
AFTER INSERT OR UPDATE OR DELETE ON course_registrations
FOR EACH ROW EXECUTE FUNCTION update_tuition_fee();
