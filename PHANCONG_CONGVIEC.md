# 📋 PHÂN CÔNG CÔNG VIỆC - THAO TÁC FILE

## Hệ thống Quản lý Đăng ký Môn học và Thu Học phí

---

## 📌 TỔNG QUAN

Tài liệu này phân chia công việc chi tiết cho **4 thành viên** trong nhóm, bao gồm các công việc cần làm và các file cần thao tác trong cả Backend và Frontend.

---

## 👤 THÀNH VIÊN 1: Quản lý Sinh viên & Đối tượng ưu tiên

### Phụ trách: BM1 - Lập hồ sơ sinh viên, QĐ1 - Quê quán & Đối tượng ưu tiên

### 📁 Files Backend cần thao tác:

| STT | File | Công việc |
|-----|------|-----------|
| 1 | `backend/src/controllers/studentController.js` | Thêm/sửa API CRUD sinh viên, lấy tỷ lệ giảm HP |
| 2 | `backend/src/routes/studentRoutes.js` | Định nghĩa routes cho sinh viên |
| 3 | `backend/src/controllers/locationController.js` | **Tạo mới** - API quản lý Tỉnh/Huyện |
| 4 | `backend/src/routes/locationRoutes.js` | **Tạo mới** - Routes cho Tỉnh/Huyện |
| 5 | `backend/src/controllers/priorityObjectController.js` | **Tạo mới** - API quản lý đối tượng ưu tiên |
| 6 | `backend/src/routes/priorityObjectRoutes.js` | **Tạo mới** - Routes đối tượng ưu tiên |
| 7 | `backend/src/index.js` | Đăng ký routes mới |

### 📁 Files Frontend cần thao tác:

| STT | File | Công việc |
|-----|------|-----------|
| 1 | `frontend/src/pages/Students.jsx` | Cập nhật giao diện quản lý sinh viên theo BM1 |
| 2 | `frontend/src/pages/Students.css` | Styles cho trang sinh viên |
| 3 | `frontend/src/pages/admin/LocationManagement.jsx` | **Tạo mới** - Quản lý Tỉnh/Huyện |
| 4 | `frontend/src/pages/admin/LocationManagement.css` | **Tạo mới** - Styles |
| 5 | `frontend/src/pages/admin/PriorityObjects.jsx` | **Tạo mới** - Quản lý đối tượng ưu tiên |
| 6 | `frontend/src/pages/admin/PriorityObjects.css` | **Tạo mới** - Styles |
| 7 | `frontend/src/services/locationService.js` | **Tạo mới** - API service cho địa danh |
| 8 | `frontend/src/services/priorityObjectService.js` | **Tạo mới** - API service đối tượng |
| 9 | `frontend/src/App.jsx` | Thêm routes mới |

### 📝 Chi tiết công việc:

#### A. Backend Tasks:
- [ ] Tạo API lấy danh sách Tỉnh/Thành phố
- [ ] Tạo API lấy danh sách Huyện/Quận theo Tỉnh
- [ ] Tạo API CRUD đối tượng ưu tiên (con liệt sĩ, thương binh, vùng sâu...)
- [ ] Tạo API gán đối tượng cho sinh viên
- [ ] Tạo API tính tỷ lệ giảm học phí theo đối tượng ưu tiên cao nhất
- [ ] Cập nhật API tạo sinh viên (bao gồm quê quán, đối tượng)
- [ ] Tạo API upload ảnh đại diện sinh viên

#### B. Frontend Tasks:
- [ ] Tạo form lập hồ sơ sinh viên theo BM1
- [ ] Tạo dropdown chọn Tỉnh → Huyện (cascade)
- [ ] Tạo giao diện quản lý đối tượng ưu tiên
- [ ] Tạo giao diện gán đối tượng cho sinh viên
- [ ] Hiển thị tỷ lệ giảm HP của sinh viên
- [ ] Hiển thị thông tin vùng sâu/vùng xa

---

## 👤 THÀNH VIÊN 2: Quản lý Môn học & Chương trình học

### Phụ trách: BM2 - Nhập danh sách môn học, BM3 - Nhập chương trình học, QĐ2 - Loại môn & Số tín chỉ, QĐ3 - Kế hoạch đào tạo

### 📁 Files Backend cần thao tác:

| STT | File | Công việc |
|-----|------|-----------|
| 1 | `backend/src/controllers/courseController.js` | Cập nhật API môn học (loại môn, số tiết, số TC) |
| 2 | `backend/src/routes/courseRoutes.js` | Cập nhật routes môn học |
| 3 | `backend/src/controllers/classController.js` | Cập nhật API lớp học |
| 4 | `backend/src/routes/classRoutes.js` | Cập nhật routes lớp học |
| 5 | `backend/src/controllers/curriculumController.js` | **Tạo mới** - API chương trình học |
| 6 | `backend/src/routes/curriculumRoutes.js` | **Tạo mới** - Routes chương trình học |
| 7 | `backend/src/controllers/departmentController.js` | **Tạo mới** - API Khoa/Ngành |
| 8 | `backend/src/routes/departmentRoutes.js` | **Tạo mới** - Routes Khoa/Ngành |
| 9 | `backend/src/controllers/prerequisiteController.js` | **Tạo mới** - API điều kiện môn học |
| 10 | `backend/src/routes/prerequisiteRoutes.js` | **Tạo mới** - Routes điều kiện |
| 11 | `backend/src/index.js` | Đăng ký routes mới |

### 📁 Files Frontend cần thao tác:

| STT | File | Công việc |
|-----|------|-----------|
| 1 | `frontend/src/pages/Courses.jsx` | Cập nhật giao diện theo BM2 (loại môn, số tiết) |
| 2 | `frontend/src/pages/Courses.css` | Styles cho trang môn học |
| 3 | `frontend/src/pages/Classes.jsx` | Cập nhật giao diện quản lý lớp |
| 4 | `frontend/src/pages/Classes.css` | Styles cho trang lớp học |
| 5 | `frontend/src/pages/admin/Curriculum.jsx` | **Tạo mới** - Quản lý chương trình học theo BM3 |
| 6 | `frontend/src/pages/admin/Curriculum.css` | **Tạo mới** - Styles |
| 7 | `frontend/src/pages/admin/Departments.jsx` | **Tạo mới** - Quản lý Khoa/Ngành |
| 8 | `frontend/src/pages/admin/Departments.css` | **Tạo mới** - Styles |
| 9 | `frontend/src/services/curriculumService.js` | **Tạo mới** - API service chương trình học |
| 10 | `frontend/src/services/departmentService.js` | **Tạo mới** - API service Khoa/Ngành |
| 11 | `frontend/src/App.jsx` | Thêm routes mới |

### 📝 Chi tiết công việc:

#### A. Backend Tasks:
- [ ] Cập nhật API môn học: thêm trường loại môn (LT/TH), số tiết
- [ ] Tự động tính số tín chỉ theo QĐ2 (LT: số tiết/15, TH: số tiết/30)
- [ ] Tạo API CRUD Khoa
- [ ] Tạo API CRUD Ngành học (thuộc Khoa)
- [ ] Tạo API CRUD chương trình học (môn học theo ngành, học kỳ dự kiến)
- [ ] Tạo API CRUD điều kiện môn học (tiên quyết, học trước)
- [ ] Tạo API lấy chương trình học theo ngành

#### B. Frontend Tasks:
- [ ] Tạo form nhập môn học theo BM2 (Mã MH, Tên MH, Loại môn, Số tiết)
- [ ] Hiển thị số tín chỉ tự động tính
- [ ] Tạo giao diện quản lý Khoa/Ngành
- [ ] Tạo form nhập chương trình học theo BM3 (Ngành, Khoa, Học kỳ, Môn học)
- [ ] Tạo giao diện quản lý điều kiện tiên quyết/học trước
- [ ] Hiển thị danh sách môn học theo ngành

---

## 👤 THÀNH VIÊN 3: Quản lý Học kỳ & Đăng ký môn học

### Phụ trách: BM4 - Nhập môn học mở trong học kỳ, BM5 - Lập phiếu đăng ký học phần, QĐ4 - Học kỳ chính/hè, QĐ5 - Đơn giá tín chỉ

### 📁 Files Backend cần thao tác:

| STT | File | Công việc |
|-----|------|-----------|
| 1 | `backend/src/controllers/semesterController.js` | Cập nhật API học kỳ (loại học kỳ, hạn đóng HP) |
| 2 | `backend/src/routes/semesterRoutes.js` | Cập nhật routes học kỳ |
| 3 | `backend/src/controllers/registrationController.js` | Cập nhật API đăng ký môn học theo BM5 |
| 4 | `backend/src/routes/registrationRoutes.js` | Cập nhật routes đăng ký |
| 5 | `backend/src/controllers/openClassController.js` | **Tạo mới** - API lớp mở trong học kỳ (BM4) |
| 6 | `backend/src/routes/openClassRoutes.js` | **Tạo mới** - Routes lớp mở |
| 7 | `backend/src/controllers/priceController.js` | **Tạo mới** - API đơn giá tín chỉ (QĐ5) |
| 8 | `backend/src/routes/priceRoutes.js` | **Tạo mới** - Routes đơn giá |
| 9 | `backend/src/controllers/academicYearController.js` | **Tạo mới** - API năm học |
| 10 | `backend/src/routes/academicYearRoutes.js` | **Tạo mới** - Routes năm học |
| 11 | `backend/src/index.js` | Đăng ký routes mới |

### 📁 Files Frontend cần thao tác:

| STT | File | Công việc |
|-----|------|-----------|
| 1 | `frontend/src/pages/Semesters.jsx` | Cập nhật giao diện học kỳ (loại, hạn đóng HP) |
| 2 | `frontend/src/pages/Semesters.css` | Styles cho trang học kỳ |
| 3 | `frontend/src/pages/Registrations.jsx` | Cập nhật giao diện phiếu đăng ký theo BM5 |
| 4 | `frontend/src/pages/Registrations.css` | Styles cho trang đăng ký |
| 5 | `frontend/src/pages/CourseRegistration.jsx` | Cập nhật giao diện đăng ký môn cho SV |
| 6 | `frontend/src/pages/CourseRegistration.css` | Styles |
| 7 | `frontend/src/pages/admin/OpenClasses.jsx` | **Tạo mới** - Quản lý lớp mở theo BM4 |
| 8 | `frontend/src/pages/admin/OpenClasses.css` | **Tạo mới** - Styles |
| 9 | `frontend/src/pages/admin/UnitPrices.jsx` | **Tạo mới** - Quản lý đơn giá tín chỉ |
| 10 | `frontend/src/pages/admin/UnitPrices.css` | **Tạo mới** - Styles |
| 11 | `frontend/src/services/openClassService.js` | **Tạo mới** - API service lớp mở |
| 12 | `frontend/src/services/priceService.js` | **Tạo mới** - API service đơn giá |
| 13 | `frontend/src/App.jsx` | Thêm routes mới |

### 📝 Chi tiết công việc:

#### A. Backend Tasks:
- [ ] Cập nhật API học kỳ: thêm loại học kỳ (Chính/Hè), hạn đóng HP
- [ ] Tạo API CRUD năm học
- [ ] Tạo API mở lớp trong học kỳ theo BM4
- [ ] Tạo API lấy danh sách lớp mở trong học kỳ
- [ ] Tạo API CRUD đơn giá tín chỉ (theo loại môn, loại học)
- [ ] Cập nhật API đăng ký: kiểm tra lớp có mở không, tính tiền tự động
- [ ] Tạo API lập phiếu đăng ký học phần theo BM5
- [ ] Tạo API tính tiền đăng ký = số TC × đơn giá

#### B. Frontend Tasks:
- [ ] Cập nhật form học kỳ (thêm loại học kỳ, hạn đóng HP)
- [ ] Tạo giao diện mở lớp trong học kỳ theo BM4
- [ ] Tạo giao diện quản lý đơn giá tín chỉ
- [ ] Cập nhật giao diện đăng ký môn cho sinh viên
- [ ] Hiển thị phiếu đăng ký học phần theo BM5
- [ ] Hiển thị thành tiền tự động khi chọn môn

---

## 👤 THÀNH VIÊN 4: Quản lý Học phí & Báo cáo

### Phụ trách: BM6 - Lập phiếu thu học phí, BM7 - Báo cáo SV chưa đóng HP, QĐ6 - Đóng nhiều lần, QĐ7 - Miễn giảm

### 📁 Files Backend cần thao tác:

| STT | File | Công việc |
|-----|------|-----------|
| 1 | `backend/src/controllers/tuitionController.js` | Cập nhật API học phí (tính miễn giảm) |
| 2 | `backend/src/routes/tuitionRoutes.js` | Cập nhật routes học phí |
| 3 | `backend/src/controllers/paymentController.js` | Cập nhật API phiếu thu theo BM6 |
| 4 | `backend/src/routes/paymentRoutes.js` | Cập nhật routes phiếu thu |
| 5 | `backend/src/controllers/reportController.js` | **Tạo mới** - API báo cáo theo BM7 |
| 6 | `backend/src/routes/reportRoutes.js` | **Tạo mới** - Routes báo cáo |
| 7 | `backend/src/controllers/notificationController.js` | Cập nhật API thông báo nhắc HP |
| 8 | `backend/src/routes/notificationRoutes.js` | Cập nhật routes thông báo |
| 9 | `backend/src/controllers/statisticsController.js` | **Tạo mới** - API thống kê tổng hợp |
| 10 | `backend/src/routes/statisticsRoutes.js` | **Tạo mới** - Routes thống kê |
| 11 | `backend/src/controllers/exportController.js` | **Tạo mới** - API xuất báo cáo Excel/PDF |
| 12 | `backend/src/routes/exportRoutes.js` | **Tạo mới** - Routes xuất báo cáo |
| 13 | `backend/src/index.js` | Đăng ký routes mới |

### 📁 Files Frontend cần thao tác:

| STT | File | Công việc |
|-----|------|-----------|
| 1 | `frontend/src/pages/Tuition.jsx` | Cập nhật giao diện học phí (miễn giảm, còn lại) |
| 2 | `frontend/src/pages/Tuition.css` | Styles cho trang học phí |
| 3 | `frontend/src/pages/Payments.jsx` | Cập nhật giao diện phiếu thu theo BM6 |
| 4 | `frontend/src/pages/Payments.css` | Styles cho trang phiếu thu |
| 5 | `frontend/src/pages/Reports.jsx` | Cập nhật giao diện báo cáo theo BM7 |
| 6 | `frontend/src/pages/Reports.css` | Styles cho trang báo cáo |
| 7 | `frontend/src/pages/MyTuition.jsx` | Cập nhật giao diện xem học phí của SV |
| 8 | `frontend/src/pages/MyTuition.css` | Styles |
| 9 | `frontend/src/pages/MyPayments.jsx` | Cập nhật giao diện lịch sử thanh toán |
| 10 | `frontend/src/pages/MyPayments.css` | Styles |
| 11 | `frontend/src/pages/admin/Statistics.jsx` | **Tạo mới** - Giao diện thống kê tổng hợp |
| 12 | `frontend/src/pages/admin/Statistics.css` | **Tạo mới** - Styles cho trang thống kê |
| 13 | `frontend/src/services/reportService.js` | **Tạo mới** - API service báo cáo |
| 14 | `frontend/src/services/statisticsService.js` | **Tạo mới** - API service thống kê |
| 15 | `frontend/src/services/exportService.js` | **Tạo mới** - API service xuất báo cáo |
| 16 | `frontend/src/App.jsx` | Cập nhật routes nếu cần |

### 📝 Chi tiết công việc:

#### A. Backend Tasks:
- [ ] Cập nhật API học phí: tính miễn giảm theo đối tượng
- [ ] Tính công thức: Tiền phải đóng = Tiền đăng ký - Tiền miễn giảm
- [ ] Tạo API lập phiếu thu học phí theo BM6
- [ ] Hỗ trợ sinh viên đóng nhiều lần (QĐ6)
- [ ] Tạo API tính số tiền còn lại phải đóng
- [ ] Tạo API lập báo cáo SV chưa đóng đủ HP theo BM7
- [ ] Tạo API kiểm tra hạn đóng HP
- [ ] Tạo API gửi thông báo nhắc đóng HP

#### B. Frontend Tasks:
- [ ] Cập nhật giao diện học phí: hiển thị số tiền đăng ký, miễn giảm, phải đóng
- [ ] Tạo form lập phiếu thu theo BM6
- [ ] Hiển thị lịch sử thanh toán của từng phiếu đăng ký
- [ ] Tạo báo cáo SV chưa đóng HP theo BM7
- [ ] Hiển thị trạng thái: Đã đóng đủ / Còn nợ / Quá hạn
- [ ] Xuất báo cáo ra Excel/PDF

---

## 📊 TỔNG HỢP FILES

| Thành viên | Files Backend | Files Frontend | Files Tạo Mới |
|------------|---------------|----------------|---------------|
| **TV1** | 7 | 9 | 8 |
| **TV2** | 11 | 11 | 10 |
| **TV3** | 11 | 13 | 10 |
| **TV4** | 13 | 16 | 11 |

---

## 📁 CẤU TRÚC THƯ MỤC SAU KHI HOÀN THÀNH

```
├── backend/
│   ├── src/
│   │   ├── config/
│   │   │   ├── database.js
│   │   │   └── init.sql (cập nhật trigger)
│   │   ├── controllers/
│   │   │   ├── authController.js
│   │   │   ├── studentController.js ✏️
│   │   │   ├── courseController.js ✏️
│   │   │   ├── classController.js ✏️
│   │   │   ├── semesterController.js ✏️
│   │   │   ├── registrationController.js ✏️
│   │   │   ├── tuitionController.js ✏️
│   │   │   ├── paymentController.js ✏️
│   │   │   ├── notificationController.js ✏️
│   │   │   ├── locationController.js 🆕
│   │   │   ├── priorityObjectController.js 🆕
│   │   │   ├── curriculumController.js 🆕
│   │   │   ├── departmentController.js 🆕
│   │   │   ├── prerequisiteController.js 🆕
│   │   │   ├── openClassController.js 🆕
│   │   │   ├── priceController.js 🆕
│   │   │   ├── academicYearController.js 🆕
│   │   │   ├── reportController.js 🆕
│   │   │   ├── statisticsController.js 🆕
│   │   │   └── exportController.js 🆕
│   │   ├── routes/
│   │   │   ├── authRoutes.js
│   │   │   ├── studentRoutes.js ✏️
│   │   │   ├── courseRoutes.js ✏️
│   │   │   ├── classRoutes.js ✏️
│   │   │   ├── semesterRoutes.js ✏️
│   │   │   ├── registrationRoutes.js ✏️
│   │   │   ├── tuitionRoutes.js ✏️
│   │   │   ├── paymentRoutes.js ✏️
│   │   │   ├── notificationRoutes.js ✏️
│   │   │   ├── locationRoutes.js 🆕
│   │   │   ├── priorityObjectRoutes.js 🆕
│   │   │   ├── curriculumRoutes.js 🆕
│   │   │   ├── departmentRoutes.js 🆕
│   │   │   ├── prerequisiteRoutes.js 🆕
│   │   │   ├── openClassRoutes.js 🆕
│   │   │   ├── priceRoutes.js 🆕
│   │   │   ├── academicYearRoutes.js 🆕
│   │   │   ├── reportRoutes.js 🆕
│   │   │   ├── statisticsRoutes.js 🆕
│   │   │   └── exportRoutes.js 🆕
│   │   └── index.js ✏️
│
├── frontend/
│   ├── src/
│   │   ├── pages/
│   │   │   ├── Students.jsx ✏️
│   │   │   ├── Courses.jsx ✏️
│   │   │   ├── Classes.jsx ✏️
│   │   │   ├── Semesters.jsx ✏️
│   │   │   ├── Registrations.jsx ✏️
│   │   │   ├── CourseRegistration.jsx ✏️
│   │   │   ├── Tuition.jsx ✏️
│   │   │   ├── Payments.jsx ✏️
│   │   │   ├── Reports.jsx ✏️
│   │   │   ├── MyTuition.jsx ✏️
│   │   │   ├── MyPayments.jsx ✏️
│   │   │   ├── admin/
│   │   │   │   ├── LocationManagement.jsx 🆕
│   │   │   │   ├── PriorityObjects.jsx 🆕
│   │   │   │   ├── Curriculum.jsx 🆕
│   │   │   │   ├── Departments.jsx 🆕
│   │   │   │   ├── OpenClasses.jsx 🆕
│   │   │   │   ├── UnitPrices.jsx 🆕
│   │   │   │   └── Statistics.jsx 🆕
│   │   │   └── student/
│   │   ├── services/
│   │   │   ├── locationService.js 🆕
│   │   │   ├── priorityObjectService.js 🆕
│   │   │   ├── curriculumService.js 🆕
│   │   │   ├── departmentService.js 🆕
│   │   │   ├── openClassService.js 🆕
│   │   │   ├── priceService.js 🆕
│   │   │   ├── reportService.js 🆕
│   │   │   ├── statisticsService.js 🆕
│   │   │   └── exportService.js 🆕
│   │   └── App.jsx ✏️
```

**Chú thích:**
- 🆕 File tạo mới
- ✏️ File cần chỉnh sửa

---

## ⏰ TIMELINE CÔNG VIỆC

| Tuần | Công việc | Thành viên |
|------|-----------|------------|
| **Tuần 1** | Phân tích yêu cầu, thiết kế API | Tất cả |
| **Tuần 2** | Backend: Tạo controllers và routes | TV1, TV2 |
| **Tuần 3** | Backend: Hoàn thiện API | TV3, TV4 |
| **Tuần 4** | Frontend: Tạo giao diện admin | TV1, TV2 |
| **Tuần 5** | Frontend: Hoàn thiện giao diện | TV3, TV4 |
| **Tuần 6** | Test và tích hợp | Tất cả |
| **Tuần 7** | Review và hoàn thiện | Tất cả |

---

## 📌 QUY TẮC LÀM VIỆC

1. **Git Branch**: Mỗi thành viên tạo branch riêng: `feature/tv1-student`, `feature/tv2-course`...
2. **Code Review**: Merge vào `develop` phải có review từ 1 thành viên khác
3. **Commit Message**: Tuân theo format: `[TV1] feat: Thêm API đối tượng ưu tiên`
4. **API Documentation**: Cập nhật README hoặc Swagger khi thêm API mới
5. **Testing**: Viết test cho các API quan trọng
