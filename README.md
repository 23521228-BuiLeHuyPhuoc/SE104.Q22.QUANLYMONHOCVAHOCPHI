# HỆ THỐNG QUẢN LÝ VIỆC ĐĂNG KÝ MÔN HỌC VÀ THU HỌC PHÍ CỦA SINH VIÊN

Đề tài SE104.Q22 - Hệ thống quản lý đăng ký môn học và thu học phí sinh viên.

## 📋 Mô tả dự án

Hệ thống web application quản lý việc đăng ký môn học và thu học phí của sinh viên, được phát triển bằng:
- **Frontend**: ReactJS (Vite)
- **Backend**: NodeJS (Express)
- **Database**: PostgreSQL

## ✨ Tính năng

### 👨‍💼 Quản trị viên (Admin)
- Quản lý sinh viên (CRUD)
- Quản lý môn học (CRUD)
- Quản lý học kỳ
- Xem danh sách đăng ký môn học
- Quản lý học phí và theo dõi công nợ
- Ghi nhận thanh toán học phí
- Xem báo cáo thống kê

### 👨‍🎓 Sinh viên
- Đăng ký môn học theo học kỳ
- Xem danh sách môn học đã đăng ký
- Xem thông tin học phí
- Xem lịch sử thanh toán

## 🚀 Cài đặt và Chạy

### Yêu cầu hệ thống
- Node.js >= 18.x
- PostgreSQL >= 14.x
- npm hoặc yarn

### 1. Cài đặt Database

```bash
# Đăng nhập vào PostgreSQL
psql -U postgres

# Tạo database
CREATE DATABASE course_registration;

# Chạy script khởi tạo (từ thư mục backend)
psql -U postgres -d course_registration -f src/config/init.sql
```

### 2. Cài đặt Backend

```bash
cd backend

# Cài đặt dependencies
npm install

# Copy file cấu hình môi trường
cp .env.example .env

# Chỉnh sửa .env với thông tin database của bạn

# Chạy server
npm start
```

Server sẽ chạy tại: http://localhost:5000

### 3. Cài đặt Frontend

```bash
cd frontend

# Cài đặt dependencies
npm install

# Chạy development server
npm run dev
```

Frontend sẽ chạy tại: http://localhost:5173

## 🔐 Tài khoản mặc định

### Admin
- Username: `admin`
- Password: `admin123`

### Sinh viên
- Tạo sinh viên mới qua giao diện Admin
- Username: Mã sinh viên
- Password mặc định: `student123`

## 📁 Cấu trúc dự án

```
├── backend/
│   ├── src/
│   │   ├── config/         # Cấu hình database và SQL init
│   │   ├── controllers/    # Controllers xử lý logic
│   │   ├── middleware/     # Middleware xác thực
│   │   ├── routes/         # Định nghĩa API routes
│   │   └── index.js        # Entry point
│   ├── .env.example
│   └── package.json
│
├── frontend/
│   ├── src/
│   │   ├── components/     # Các component dùng chung
│   │   ├── context/        # React Context (Auth)
│   │   ├── pages/          # Các trang giao diện
│   │   ├── services/       # API services
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── package.json
│   └── vite.config.js
│
└── README.md
```

## 🔗 API Endpoints

### Authentication
- `POST /api/auth/login` - Đăng nhập
- `POST /api/auth/register` - Đăng ký (Admin only)
- `GET /api/auth/me` - Lấy thông tin user hiện tại

### Students
- `GET /api/students` - Danh sách sinh viên
- `GET /api/students/:id` - Chi tiết sinh viên
- `POST /api/students` - Thêm sinh viên
- `PUT /api/students/:id` - Cập nhật sinh viên
- `DELETE /api/students/:id` - Xóa sinh viên

### Courses
- `GET /api/courses` - Danh sách môn học
- `GET /api/courses/:id` - Chi tiết môn học
- `POST /api/courses` - Thêm môn học
- `PUT /api/courses/:id` - Cập nhật môn học
- `DELETE /api/courses/:id` - Xóa môn học

### Course Registrations
- `GET /api/registrations` - Danh sách đăng ký
- `POST /api/registrations` - Đăng ký môn học
- `PUT /api/registrations/:id/cancel` - Hủy đăng ký
- `GET /api/registrations/student/:student_id` - Môn học của sinh viên
- `GET /api/registrations/available` - Môn học có thể đăng ký

### Tuition Fees
- `GET /api/tuition` - Danh sách học phí
- `GET /api/tuition/:id` - Chi tiết học phí
- `GET /api/tuition/student/:student_id` - Học phí của sinh viên
- `POST /api/tuition/calculate` - Tính học phí

### Payments
- `GET /api/payments` - Danh sách thanh toán
- `POST /api/payments` - Ghi nhận thanh toán
- `GET /api/payments/student/:student_id` - Lịch sử thanh toán của sinh viên

### Semesters
- `GET /api/semesters` - Danh sách học kỳ
- `GET /api/semesters/active` - Học kỳ hiện tại
- `POST /api/semesters` - Thêm học kỳ
- `PUT /api/semesters/:id` - Cập nhật học kỳ
- `DELETE /api/semesters/:id` - Xóa học kỳ

## 📸 Screenshots

Giao diện hệ thống bao gồm:
- Trang đăng nhập
- Dashboard tổng quan
- Quản lý sinh viên
- Quản lý môn học
- Đăng ký môn học
- Quản lý học phí
- Ghi nhận thanh toán
- Quản lý học kỳ

## 🛠️ Công nghệ sử dụng

### Frontend
- React 19
- React Router DOM 7
- Axios
- React Icons
- React Toastify
- Vite

### Backend
- Node.js
- Express.js
- PostgreSQL (pg)
- JWT (jsonwebtoken)
- bcryptjs
- CORS
- dotenv

## 📝 License

ISC License

## 👥 Tác giả

- SE104.Q22 - Đồ án môn học
