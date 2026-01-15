const pool = require('../config/database');

// Get all course registrations with filters
const getAllRegistrations = async (req, res) => {
  try {
    const { 
      page = 1, 
      limit = 10, 
      student_id, 
      course_id, 
      semester_id,
      status,
      search = ''
    } = req.query;
    const offset = (page - 1) * limit;

    let whereConditions = [];
    let params = [];
    let paramIndex = 1;

    if (student_id) {
      whereConditions.push(`cr.student_id = $${paramIndex}`);
      params.push(student_id);
      paramIndex++;
    }

    if (course_id) {
      whereConditions.push(`cr.course_id = $${paramIndex}`);
      params.push(course_id);
      paramIndex++;
    }

    if (semester_id) {
      whereConditions.push(`cr.semester_id = $${paramIndex}`);
      params.push(semester_id);
      paramIndex++;
    }

    if (status) {
      whereConditions.push(`cr.status = $${paramIndex}`);
      params.push(status);
      paramIndex++;
    }

    if (search) {
      whereConditions.push(`(s.student_code ILIKE $${paramIndex} OR s.full_name ILIKE $${paramIndex} OR c.course_code ILIKE $${paramIndex} OR c.course_name ILIKE $${paramIndex})`);
      params.push(`%${search}%`);
      paramIndex++;
    }

    const whereClause = whereConditions.length > 0 ? `WHERE ${whereConditions.join(' AND ')}` : '';

    // Count total
    const countResult = await pool.query(
      `SELECT COUNT(*) FROM course_registrations cr
       JOIN students s ON cr.student_id = s.id
       JOIN courses c ON cr.course_id = c.id
       ${whereClause}`,
      params
    );
    const total = parseInt(countResult.rows[0].count);

    // Get registrations
    const result = await pool.query(
      `SELECT cr.*, 
       s.student_code, s.full_name as student_name,
       c.course_code, c.course_name, c.credits, c.fee_per_credit, c.schedule, c.room, c.instructor,
       sem.name as semester_name, sem.year as semester_year
       FROM course_registrations cr
       JOIN students s ON cr.student_id = s.id
       JOIN courses c ON cr.course_id = c.id
       LEFT JOIN semesters sem ON cr.semester_id = sem.id
       ${whereClause}
       ORDER BY cr.registration_date DESC
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
    console.error('Get all registrations error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Register course for student
const registerCourse = async (req, res) => {
  const client = await pool.connect();
  try {
    const { student_id, course_id, semester_id } = req.body;

    if (!student_id || !course_id || !semester_id) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp đầy đủ thông tin'
      });
    }

    // Check if student exists
    const studentCheck = await client.query('SELECT id FROM students WHERE id = $1', [student_id]);
    if (studentCheck.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy sinh viên'
      });
    }

    // Check if course exists and is active
    const courseCheck = await client.query(
      'SELECT id, max_students FROM courses WHERE id = $1 AND is_active = true',
      [course_id]
    );
    if (courseCheck.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy môn học hoặc môn học không hoạt động'
      });
    }

    // Check if registration already exists
    const existingReg = await client.query(
      `SELECT id, status FROM course_registrations 
       WHERE student_id = $1 AND course_id = $2 AND semester_id = $3`,
      [student_id, course_id, semester_id]
    );

    if (existingReg.rows.length > 0) {
      if (existingReg.rows[0].status === 'registered') {
        return res.status(400).json({
          success: false,
          message: 'Sinh viên đã đăng ký môn học này'
        });
      }
    }

    // Check course capacity
    const capacityCheck = await client.query(
      `SELECT COUNT(*) FROM course_registrations 
       WHERE course_id = $1 AND semester_id = $2 AND status = 'registered'`,
      [course_id, semester_id]
    );
    
    if (parseInt(capacityCheck.rows[0].count) >= courseCheck.rows[0].max_students) {
      return res.status(400).json({
        success: false,
        message: 'Môn học đã đầy'
      });
    }

    await client.query('BEGIN');

    let result;
    if (existingReg.rows.length > 0) {
      // Update existing registration
      result = await client.query(
        `UPDATE course_registrations 
         SET status = 'registered', registration_date = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP
         WHERE id = $1
         RETURNING *`,
        [existingReg.rows[0].id]
      );
    } else {
      // Create new registration
      result = await client.query(
        `INSERT INTO course_registrations (student_id, course_id, semester_id, status)
         VALUES ($1, $2, $3, 'registered')
         RETURNING *`,
        [student_id, course_id, semester_id]
      );
    }

    await client.query('COMMIT');

    res.status(201).json({
      success: true,
      message: 'Đăng ký môn học thành công',
      data: result.rows[0]
    });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Register course error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  } finally {
    client.release();
  }
};

// Cancel course registration
const cancelRegistration = async (req, res) => {
  try {
    const { id } = req.params;

    const existingReg = await pool.query(
      'SELECT id, status FROM course_registrations WHERE id = $1',
      [id]
    );

    if (existingReg.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy đăng ký'
      });
    }

    if (existingReg.rows[0].status === 'cancelled') {
      return res.status(400).json({
        success: false,
        message: 'Đăng ký đã bị hủy trước đó'
      });
    }

    const result = await pool.query(
      `UPDATE course_registrations 
       SET status = 'cancelled', updated_at = CURRENT_TIMESTAMP
       WHERE id = $1
       RETURNING *`,
      [id]
    );

    res.json({
      success: true,
      message: 'Hủy đăng ký thành công',
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Cancel registration error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Get registered courses for a student
const getStudentCourses = async (req, res) => {
  try {
    const { student_id } = req.params;
    const { semester_id, status = 'registered' } = req.query;

    let whereClause = 'WHERE cr.student_id = $1';
    let params = [student_id];
    let paramIndex = 2;

    if (semester_id) {
      whereClause += ` AND cr.semester_id = $${paramIndex}`;
      params.push(semester_id);
      paramIndex++;
    }

    if (status) {
      whereClause += ` AND cr.status = $${paramIndex}`;
      params.push(status);
    }

    const result = await pool.query(
      `SELECT cr.*, 
       c.course_code, c.course_name, c.credits, c.fee_per_credit, c.schedule, c.room, c.instructor,
       sem.name as semester_name, sem.year as semester_year
       FROM course_registrations cr
       JOIN courses c ON cr.course_id = c.id
       LEFT JOIN semesters sem ON cr.semester_id = sem.id
       ${whereClause}
       ORDER BY c.course_code`,
      params
    );

    // Calculate total credits and fees
    let totalCredits = 0;
    let totalFees = 0;
    result.rows.forEach(row => {
      totalCredits += row.credits;
      totalFees += row.credits * parseFloat(row.fee_per_credit);
    });

    res.json({
      success: true,
      data: {
        courses: result.rows,
        summary: {
          totalCourses: result.rows.length,
          totalCredits,
          totalFees
        }
      }
    });
  } catch (error) {
    console.error('Get student courses error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Get available courses for registration
const getAvailableCourses = async (req, res) => {
  try {
    const { student_id, semester_id } = req.query;

    if (!student_id || !semester_id) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp student_id và semester_id'
      });
    }

    // Get courses that student hasn't registered yet
    const result = await pool.query(
      `SELECT c.*, 
       (SELECT COUNT(*) FROM course_registrations cr WHERE cr.course_id = c.id AND cr.status = 'registered') as registered_count,
       s.name as semester_name, s.year as semester_year
       FROM courses c
       LEFT JOIN semesters s ON c.semester_id = s.id
       WHERE c.semester_id = $1 
       AND c.is_active = true
       AND c.id NOT IN (
         SELECT course_id FROM course_registrations 
         WHERE student_id = $2 AND semester_id = $1 AND status = 'registered'
       )
       ORDER BY c.course_code`,
      [semester_id, student_id]
    );

    res.json({
      success: true,
      data: result.rows
    });
  } catch (error) {
    console.error('Get available courses error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Get registration statistics
const getRegistrationStats = async (req, res) => {
  try {
    const { semester_id } = req.query;

    let whereClause = '';
    let params = [];
    if (semester_id) {
      whereClause = 'WHERE cr.semester_id = $1';
      params = [semester_id];
    }

    const totalResult = await pool.query(
      `SELECT COUNT(*) FROM course_registrations cr ${whereClause}`,
      params
    );

    const byStatusResult = await pool.query(
      `SELECT status, COUNT(*) as count 
       FROM course_registrations cr 
       ${whereClause}
       GROUP BY status`,
      params
    );

    const popularCoursesResult = await pool.query(
      `SELECT c.course_code, c.course_name, COUNT(cr.id) as registration_count
       FROM courses c
       LEFT JOIN course_registrations cr ON c.id = cr.course_id ${whereClause ? 'AND cr.semester_id = $1' : ''}
       WHERE cr.status = 'registered'
       GROUP BY c.id, c.course_code, c.course_name
       ORDER BY registration_count DESC
       LIMIT 10`,
      params
    );

    res.json({
      success: true,
      data: {
        total: parseInt(totalResult.rows[0].count),
        byStatus: byStatusResult.rows,
        popularCourses: popularCoursesResult.rows
      }
    });
  } catch (error) {
    console.error('Get registration stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

module.exports = {
  getAllRegistrations,
  registerCourse,
  cancelRegistration,
  getStudentCourses,
  getAvailableCourses,
  getRegistrationStats
};
