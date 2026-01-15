const pool = require('../config/database');

// Get all tuition fees with filters
const getAllTuitionFees = async (req, res) => {
  try {
    const { 
      page = 1, 
      limit = 10, 
      student_id, 
      semester_id,
      status,
      search = ''
    } = req.query;
    const offset = (page - 1) * limit;

    let whereConditions = [];
    let params = [];
    let paramIndex = 1;

    if (student_id) {
      whereConditions.push(`tf.student_id = $${paramIndex}`);
      params.push(student_id);
      paramIndex++;
    }

    if (semester_id) {
      whereConditions.push(`tf.semester_id = $${paramIndex}`);
      params.push(semester_id);
      paramIndex++;
    }

    if (status) {
      whereConditions.push(`tf.status = $${paramIndex}`);
      params.push(status);
      paramIndex++;
    }

    if (search) {
      whereConditions.push(`(s.student_code ILIKE $${paramIndex} OR s.full_name ILIKE $${paramIndex})`);
      params.push(`%${search}%`);
      paramIndex++;
    }

    const whereClause = whereConditions.length > 0 ? `WHERE ${whereConditions.join(' AND ')}` : '';

    // Count total
    const countResult = await pool.query(
      `SELECT COUNT(*) FROM tuition_fees tf
       JOIN students s ON tf.student_id = s.id
       ${whereClause}`,
      params
    );
    const total = parseInt(countResult.rows[0].count);

    // Get tuition fees
    const result = await pool.query(
      `SELECT tf.*, 
       s.student_code, s.full_name as student_name, s.email, s.class_name,
       sem.name as semester_name, sem.year as semester_year
       FROM tuition_fees tf
       JOIN students s ON tf.student_id = s.id
       LEFT JOIN semesters sem ON tf.semester_id = sem.id
       ${whereClause}
       ORDER BY tf.created_at DESC
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
    console.error('Get all tuition fees error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Get tuition fee by ID
const getTuitionFeeById = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await pool.query(
      `SELECT tf.*, 
       s.student_code, s.full_name as student_name, s.email, s.class_name,
       sem.name as semester_name, sem.year as semester_year
       FROM tuition_fees tf
       JOIN students s ON tf.student_id = s.id
       LEFT JOIN semesters sem ON tf.semester_id = sem.id
       WHERE tf.id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy thông tin học phí'
      });
    }

    // Get payment history
    const payments = await pool.query(
      `SELECT p.*, u.username as created_by_name
       FROM payments p
       LEFT JOIN users u ON p.created_by = u.id
       WHERE p.tuition_fee_id = $1
       ORDER BY p.payment_date DESC`,
      [id]
    );

    // Get registered courses
    const courses = await pool.query(
      `SELECT c.course_code, c.course_name, c.credits, c.fee_per_credit,
       (c.credits * c.fee_per_credit) as course_fee
       FROM course_registrations cr
       JOIN courses c ON cr.course_id = c.id
       WHERE cr.student_id = $1 AND cr.semester_id = $2 AND cr.status = 'registered'`,
      [result.rows[0].student_id, result.rows[0].semester_id]
    );

    res.json({
      success: true,
      data: {
        tuitionFee: result.rows[0],
        payments: payments.rows,
        courses: courses.rows
      }
    });
  } catch (error) {
    console.error('Get tuition fee by ID error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Get student's tuition fee
const getStudentTuitionFee = async (req, res) => {
  try {
    const { student_id } = req.params;
    const { semester_id } = req.query;

    let whereClause = 'WHERE tf.student_id = $1';
    let params = [student_id];

    if (semester_id) {
      whereClause += ' AND tf.semester_id = $2';
      params.push(semester_id);
    }

    const result = await pool.query(
      `SELECT tf.*, 
       sem.name as semester_name, sem.year as semester_year
       FROM tuition_fees tf
       LEFT JOIN semesters sem ON tf.semester_id = sem.id
       ${whereClause}
       ORDER BY sem.year DESC, sem.name DESC`,
      params
    );

    res.json({
      success: true,
      data: result.rows
    });
  } catch (error) {
    console.error('Get student tuition fee error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Calculate tuition fee for student
const calculateTuitionFee = async (req, res) => {
  try {
    const { student_id, semester_id } = req.body;

    if (!student_id || !semester_id) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp student_id và semester_id'
      });
    }

    // Get registered courses
    const coursesResult = await pool.query(
      `SELECT c.credits, c.fee_per_credit
       FROM course_registrations cr
       JOIN courses c ON cr.course_id = c.id
       WHERE cr.student_id = $1 AND cr.semester_id = $2 AND cr.status = 'registered'`,
      [student_id, semester_id]
    );

    let totalCredits = 0;
    let totalAmount = 0;

    coursesResult.rows.forEach(course => {
      totalCredits += course.credits;
      totalAmount += course.credits * parseFloat(course.fee_per_credit);
    });

    // Check existing tuition fee record
    const existingFee = await pool.query(
      'SELECT * FROM tuition_fees WHERE student_id = $1 AND semester_id = $2',
      [student_id, semester_id]
    );

    let tuitionFee;
    if (existingFee.rows.length > 0) {
      // Update existing record
      const paidAmount = parseFloat(existingFee.rows[0].paid_amount) || 0;
      const remainingAmount = totalAmount - paidAmount;
      const status = paidAmount >= totalAmount ? 'paid' : (paidAmount > 0 ? 'partial' : 'unpaid');

      const updateResult = await pool.query(
        `UPDATE tuition_fees 
         SET total_credits = $1, total_amount = $2, remaining_amount = $3, status = $4, updated_at = CURRENT_TIMESTAMP
         WHERE id = $5
         RETURNING *`,
        [totalCredits, totalAmount, remainingAmount, status, existingFee.rows[0].id]
      );
      tuitionFee = updateResult.rows[0];
    } else {
      // Create new record
      const dueDate = await pool.query(
        'SELECT registration_end + INTERVAL \'30 days\' as due_date FROM semesters WHERE id = $1',
        [semester_id]
      );

      const insertResult = await pool.query(
        `INSERT INTO tuition_fees (student_id, semester_id, total_credits, total_amount, remaining_amount, due_date)
         VALUES ($1, $2, $3, $4, $5, $6)
         RETURNING *`,
        [student_id, semester_id, totalCredits, totalAmount, totalAmount, dueDate.rows[0]?.due_date]
      );
      tuitionFee = insertResult.rows[0];
    }

    res.json({
      success: true,
      message: 'Tính học phí thành công',
      data: tuitionFee
    });
  } catch (error) {
    console.error('Calculate tuition fee error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Get tuition statistics
const getTuitionStats = async (req, res) => {
  try {
    const { semester_id } = req.query;

    let whereClause = '';
    let params = [];
    if (semester_id) {
      whereClause = 'WHERE tf.semester_id = $1';
      params = [semester_id];
    }

    const totalResult = await pool.query(
      `SELECT 
       COUNT(*) as total_records,
       COALESCE(SUM(total_amount), 0) as total_amount,
       COALESCE(SUM(paid_amount), 0) as total_paid,
       COALESCE(SUM(remaining_amount), 0) as total_remaining
       FROM tuition_fees tf ${whereClause}`,
      params
    );

    const byStatusResult = await pool.query(
      `SELECT status, COUNT(*) as count, COALESCE(SUM(total_amount), 0) as total_amount
       FROM tuition_fees tf
       ${whereClause}
       GROUP BY status`,
      params
    );

    res.json({
      success: true,
      data: {
        summary: totalResult.rows[0],
        byStatus: byStatusResult.rows
      }
    });
  } catch (error) {
    console.error('Get tuition stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

module.exports = {
  getAllTuitionFees,
  getTuitionFeeById,
  getStudentTuitionFee,
  calculateTuitionFee,
  getTuitionStats
};
