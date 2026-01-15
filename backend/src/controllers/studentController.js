const pool = require('../config/database');
const bcrypt = require('bcryptjs');

// Get all students with pagination and search
const getAllStudents = async (req, res) => {
  try {
    const { page = 1, limit = 10, search = '', sortBy = 'id', sortOrder = 'ASC' } = req.query;
    const offset = (page - 1) * limit;

    const validSortFields = ['id', 'student_code', 'full_name', 'email', 'class_name', 'created_at'];
    const sortField = validSortFields.includes(sortBy) ? sortBy : 'id';
    const order = sortOrder.toUpperCase() === 'DESC' ? 'DESC' : 'ASC';

    // Count total
    const countResult = await pool.query(
      `SELECT COUNT(*) FROM students 
       WHERE student_code ILIKE $1 OR full_name ILIKE $1 OR email ILIKE $1`,
      [`%${search}%`]
    );
    const total = parseInt(countResult.rows[0].count);

    // Get students
    const result = await pool.query(
      `SELECT s.*, u.username 
       FROM students s 
       LEFT JOIN users u ON s.user_id = u.id
       WHERE s.student_code ILIKE $1 OR s.full_name ILIKE $1 OR s.email ILIKE $1
       ORDER BY s.${sortField} ${order}
       LIMIT $2 OFFSET $3`,
      [`%${search}%`, limit, offset]
    );

    res.json({
      success: true,
      data: result.rows,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        totalPages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('Get all students error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Get student by ID
const getStudentById = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await pool.query(
      `SELECT s.*, u.username 
       FROM students s 
       LEFT JOIN users u ON s.user_id = u.id
       WHERE s.id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy sinh viên'
      });
    }

    res.json({
      success: true,
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Get student by ID error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Create new student
const createStudent = async (req, res) => {
  const client = await pool.connect();
  try {
    const {
      student_code,
      full_name,
      email,
      phone,
      date_of_birth,
      gender,
      address,
      class_name,
      major,
      enrollment_year,
      password = 'student123' // default password
    } = req.body;

    if (!student_code || !full_name || !email) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập mã sinh viên, họ tên và email'
      });
    }

    // Check if student code or email exists
    const existingStudent = await client.query(
      'SELECT id FROM students WHERE student_code = $1 OR email = $2',
      [student_code, email]
    );

    if (existingStudent.rows.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'Mã sinh viên hoặc email đã tồn tại'
      });
    }

    await client.query('BEGIN');

    // Create user account for student
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);
    
    const userResult = await client.query(
      'INSERT INTO users (username, password, role) VALUES ($1, $2, $3) RETURNING id',
      [student_code, hashedPassword, 'student']
    );
    const userId = userResult.rows[0].id;

    // Create student
    const result = await client.query(
      `INSERT INTO students 
       (student_code, full_name, email, phone, date_of_birth, gender, address, class_name, major, enrollment_year, user_id)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
       RETURNING *`,
      [student_code, full_name, email, phone, date_of_birth, gender, address, class_name, major, enrollment_year, userId]
    );

    await client.query('COMMIT');

    res.status(201).json({
      success: true,
      message: 'Thêm sinh viên thành công',
      data: result.rows[0]
    });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Create student error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  } finally {
    client.release();
  }
};

// Update student
const updateStudent = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      full_name,
      email,
      phone,
      date_of_birth,
      gender,
      address,
      class_name,
      major,
      enrollment_year
    } = req.body;

    // Check if student exists
    const existingStudent = await pool.query(
      'SELECT id FROM students WHERE id = $1',
      [id]
    );

    if (existingStudent.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy sinh viên'
      });
    }

    // Check email uniqueness
    if (email) {
      const emailCheck = await pool.query(
        'SELECT id FROM students WHERE email = $1 AND id != $2',
        [email, id]
      );
      if (emailCheck.rows.length > 0) {
        return res.status(400).json({
          success: false,
          message: 'Email đã được sử dụng'
        });
      }
    }

    const result = await pool.query(
      `UPDATE students SET 
       full_name = COALESCE($1, full_name),
       email = COALESCE($2, email),
       phone = COALESCE($3, phone),
       date_of_birth = COALESCE($4, date_of_birth),
       gender = COALESCE($5, gender),
       address = COALESCE($6, address),
       class_name = COALESCE($7, class_name),
       major = COALESCE($8, major),
       enrollment_year = COALESCE($9, enrollment_year),
       updated_at = CURRENT_TIMESTAMP
       WHERE id = $10
       RETURNING *`,
      [full_name, email, phone, date_of_birth, gender, address, class_name, major, enrollment_year, id]
    );

    res.json({
      success: true,
      message: 'Cập nhật sinh viên thành công',
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Update student error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Delete student
const deleteStudent = async (req, res) => {
  const client = await pool.connect();
  try {
    const { id } = req.params;

    const existingStudent = await client.query(
      'SELECT id, user_id FROM students WHERE id = $1',
      [id]
    );

    if (existingStudent.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy sinh viên'
      });
    }

    await client.query('BEGIN');

    // Delete student
    await client.query('DELETE FROM students WHERE id = $1', [id]);

    // Delete associated user account
    if (existingStudent.rows[0].user_id) {
      await client.query('DELETE FROM users WHERE id = $1', [existingStudent.rows[0].user_id]);
    }

    await client.query('COMMIT');

    res.json({
      success: true,
      message: 'Xóa sinh viên thành công'
    });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Delete student error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  } finally {
    client.release();
  }
};

// Get student statistics
const getStudentStats = async (req, res) => {
  try {
    const totalResult = await pool.query('SELECT COUNT(*) FROM students');
    const byClassResult = await pool.query(
      `SELECT class_name, COUNT(*) as count 
       FROM students 
       WHERE class_name IS NOT NULL 
       GROUP BY class_name 
       ORDER BY count DESC 
       LIMIT 10`
    );
    const byMajorResult = await pool.query(
      `SELECT major, COUNT(*) as count 
       FROM students 
       WHERE major IS NOT NULL 
       GROUP BY major 
       ORDER BY count DESC`
    );

    res.json({
      success: true,
      data: {
        total: parseInt(totalResult.rows[0].count),
        byClass: byClassResult.rows,
        byMajor: byMajorResult.rows
      }
    });
  } catch (error) {
    console.error('Get student stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

module.exports = {
  getAllStudents,
  getStudentById,
  createStudent,
  updateStudent,
  deleteStudent,
  getStudentStats
};
