const pool = require('../config/database');

// Get all courses with pagination and filters
const getAllCourses = async (req, res) => {
  try {
    const { 
      page = 1, 
      limit = 10, 
      search = '', 
      semester_id,
      sortBy = 'id', 
      sortOrder = 'ASC' 
    } = req.query;
    const offset = (page - 1) * limit;

    const validSortFields = ['id', 'course_code', 'course_name', 'credits', 'max_students'];
    const sortField = validSortFields.includes(sortBy) ? sortBy : 'id';
    const order = sortOrder.toUpperCase() === 'DESC' ? 'DESC' : 'ASC';

    let whereClause = `WHERE (c.course_code ILIKE $1 OR c.course_name ILIKE $1)`;
    let params = [`%${search}%`];
    let paramIndex = 2;

    if (semester_id) {
      whereClause += ` AND c.semester_id = $${paramIndex}`;
      params.push(semester_id);
      paramIndex++;
    }

    // Count total
    const countResult = await pool.query(
      `SELECT COUNT(*) FROM courses c ${whereClause}`,
      params
    );
    const total = parseInt(countResult.rows[0].count);

    // Get courses with registered count
    const result = await pool.query(
      `SELECT c.*, s.name as semester_name, s.year as semester_year,
       (SELECT COUNT(*) FROM course_registrations cr WHERE cr.course_id = c.id AND cr.status = 'registered') as registered_count
       FROM courses c
       LEFT JOIN semesters s ON c.semester_id = s.id
       ${whereClause}
       ORDER BY c.${sortField} ${order}
       LIMIT $${paramIndex} OFFSET $${paramIndex + 1}`,
      [...params, limit, offset]
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
    console.error('Get all courses error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Get course by ID
const getCourseById = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await pool.query(
      `SELECT c.*, s.name as semester_name, s.year as semester_year,
       (SELECT COUNT(*) FROM course_registrations cr WHERE cr.course_id = c.id AND cr.status = 'registered') as registered_count
       FROM courses c
       LEFT JOIN semesters s ON c.semester_id = s.id
       WHERE c.id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy môn học'
      });
    }

    res.json({
      success: true,
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Get course by ID error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Create new course
const createCourse = async (req, res) => {
  try {
    const {
      course_code,
      course_name,
      credits,
      description,
      fee_per_credit,
      max_students,
      semester_id,
      schedule,
      room,
      instructor
    } = req.body;

    if (!course_code || !course_name || !credits) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập mã môn học, tên môn học và số tín chỉ'
      });
    }

    // Check if course code exists
    const existingCourse = await pool.query(
      'SELECT id FROM courses WHERE course_code = $1',
      [course_code]
    );

    if (existingCourse.rows.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'Mã môn học đã tồn tại'
      });
    }

    const result = await pool.query(
      `INSERT INTO courses 
       (course_code, course_name, credits, description, fee_per_credit, max_students, semester_id, schedule, room, instructor)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
       RETURNING *`,
      [course_code, course_name, credits, description, fee_per_credit || 500000, max_students || 50, semester_id, schedule, room, instructor]
    );

    res.status(201).json({
      success: true,
      message: 'Thêm môn học thành công',
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Create course error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Update course
const updateCourse = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      course_name,
      credits,
      description,
      fee_per_credit,
      max_students,
      semester_id,
      schedule,
      room,
      instructor,
      is_active
    } = req.body;

    // Check if course exists
    const existingCourse = await pool.query(
      'SELECT id FROM courses WHERE id = $1',
      [id]
    );

    if (existingCourse.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy môn học'
      });
    }

    const result = await pool.query(
      `UPDATE courses SET 
       course_name = COALESCE($1, course_name),
       credits = COALESCE($2, credits),
       description = COALESCE($3, description),
       fee_per_credit = COALESCE($4, fee_per_credit),
       max_students = COALESCE($5, max_students),
       semester_id = COALESCE($6, semester_id),
       schedule = COALESCE($7, schedule),
       room = COALESCE($8, room),
       instructor = COALESCE($9, instructor),
       is_active = COALESCE($10, is_active),
       updated_at = CURRENT_TIMESTAMP
       WHERE id = $11
       RETURNING *`,
      [course_name, credits, description, fee_per_credit, max_students, semester_id, schedule, room, instructor, is_active, id]
    );

    res.json({
      success: true,
      message: 'Cập nhật môn học thành công',
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Update course error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Delete course
const deleteCourse = async (req, res) => {
  try {
    const { id } = req.params;

    const existingCourse = await pool.query(
      'SELECT id FROM courses WHERE id = $1',
      [id]
    );

    if (existingCourse.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy môn học'
      });
    }

    // Check if course has registrations
    const registrations = await pool.query(
      'SELECT COUNT(*) FROM course_registrations WHERE course_id = $1 AND status = $2',
      [id, 'registered']
    );

    if (parseInt(registrations.rows[0].count) > 0) {
      return res.status(400).json({
        success: false,
        message: 'Không thể xóa môn học đã có sinh viên đăng ký'
      });
    }

    await pool.query('DELETE FROM courses WHERE id = $1', [id]);

    res.json({
      success: true,
      message: 'Xóa môn học thành công'
    });
  } catch (error) {
    console.error('Delete course error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Get course statistics
const getCourseStats = async (req, res) => {
  try {
    const totalResult = await pool.query('SELECT COUNT(*) FROM courses WHERE is_active = true');
    const totalCreditsResult = await pool.query('SELECT SUM(credits) FROM courses WHERE is_active = true');
    const byInstructorResult = await pool.query(
      `SELECT instructor, COUNT(*) as count 
       FROM courses 
       WHERE instructor IS NOT NULL AND is_active = true
       GROUP BY instructor 
       ORDER BY count DESC 
       LIMIT 10`
    );

    res.json({
      success: true,
      data: {
        total: parseInt(totalResult.rows[0].count),
        totalCredits: parseInt(totalCreditsResult.rows[0].sum) || 0,
        byInstructor: byInstructorResult.rows
      }
    });
  } catch (error) {
    console.error('Get course stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

module.exports = {
  getAllCourses,
  getCourseById,
  createCourse,
  updateCourse,
  deleteCourse,
  getCourseStats
};
