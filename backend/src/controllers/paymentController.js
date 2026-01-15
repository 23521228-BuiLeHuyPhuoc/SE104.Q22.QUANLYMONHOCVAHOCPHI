const pool = require('../config/database');

// Get all payments with filters
const getAllPayments = async (req, res) => {
  try {
    const { 
      page = 1, 
      limit = 10, 
      student_id, 
      tuition_fee_id,
      payment_method,
      start_date,
      end_date,
      search = ''
    } = req.query;
    const offset = (page - 1) * limit;

    let whereConditions = [];
    let params = [];
    let paramIndex = 1;

    if (student_id) {
      whereConditions.push(`p.student_id = $${paramIndex}`);
      params.push(student_id);
      paramIndex++;
    }

    if (tuition_fee_id) {
      whereConditions.push(`p.tuition_fee_id = $${paramIndex}`);
      params.push(tuition_fee_id);
      paramIndex++;
    }

    if (payment_method) {
      whereConditions.push(`p.payment_method = $${paramIndex}`);
      params.push(payment_method);
      paramIndex++;
    }

    if (start_date) {
      whereConditions.push(`p.payment_date >= $${paramIndex}`);
      params.push(start_date);
      paramIndex++;
    }

    if (end_date) {
      whereConditions.push(`p.payment_date <= $${paramIndex}`);
      params.push(end_date);
      paramIndex++;
    }

    if (search) {
      whereConditions.push(`(s.student_code ILIKE $${paramIndex} OR s.full_name ILIKE $${paramIndex} OR p.transaction_id ILIKE $${paramIndex})`);
      params.push(`%${search}%`);
      paramIndex++;
    }

    const whereClause = whereConditions.length > 0 ? `WHERE ${whereConditions.join(' AND ')}` : '';

    // Count total
    const countResult = await pool.query(
      `SELECT COUNT(*) FROM payments p
       JOIN students s ON p.student_id = s.id
       ${whereClause}`,
      params
    );
    const total = parseInt(countResult.rows[0].count);

    // Get payments
    const result = await pool.query(
      `SELECT p.*, 
       s.student_code, s.full_name as student_name,
       tf.total_amount, tf.semester_id,
       sem.name as semester_name, sem.year as semester_year,
       u.username as created_by_name
       FROM payments p
       JOIN students s ON p.student_id = s.id
       LEFT JOIN tuition_fees tf ON p.tuition_fee_id = tf.id
       LEFT JOIN semesters sem ON tf.semester_id = sem.id
       LEFT JOIN users u ON p.created_by = u.id
       ${whereClause}
       ORDER BY p.payment_date DESC
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
    console.error('Get all payments error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Create new payment
const createPayment = async (req, res) => {
  const client = await pool.connect();
  try {
    const {
      tuition_fee_id,
      amount,
      payment_method = 'cash',
      transaction_id,
      notes
    } = req.body;

    if (!tuition_fee_id || !amount) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp tuition_fee_id và số tiền thanh toán'
      });
    }

    if (amount <= 0) {
      return res.status(400).json({
        success: false,
        message: 'Số tiền thanh toán phải lớn hơn 0'
      });
    }

    // Get tuition fee info
    const tuitionFee = await client.query(
      'SELECT * FROM tuition_fees WHERE id = $1',
      [tuition_fee_id]
    );

    if (tuitionFee.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy thông tin học phí'
      });
    }

    const fee = tuitionFee.rows[0];
    
    if (fee.status === 'paid') {
      return res.status(400).json({
        success: false,
        message: 'Học phí đã được thanh toán đầy đủ'
      });
    }

    await client.query('BEGIN');

    // Create payment record
    const paymentResult = await client.query(
      `INSERT INTO payments (tuition_fee_id, student_id, amount, payment_method, transaction_id, notes, created_by)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [tuition_fee_id, fee.student_id, amount, payment_method, transaction_id, notes, req.user?.id]
    );

    // Update tuition fee
    const newPaidAmount = parseFloat(fee.paid_amount) + parseFloat(amount);
    const newRemainingAmount = parseFloat(fee.total_amount) - newPaidAmount;
    const newStatus = newRemainingAmount <= 0 ? 'paid' : 'partial';

    await client.query(
      `UPDATE tuition_fees 
       SET paid_amount = $1, remaining_amount = $2, status = $3, updated_at = CURRENT_TIMESTAMP
       WHERE id = $4`,
      [newPaidAmount, Math.max(0, newRemainingAmount), newStatus, tuition_fee_id]
    );

    await client.query('COMMIT');

    res.status(201).json({
      success: true,
      message: 'Thanh toán thành công',
      data: {
        payment: paymentResult.rows[0],
        tuitionFeeUpdate: {
          paid_amount: newPaidAmount,
          remaining_amount: Math.max(0, newRemainingAmount),
          status: newStatus
        }
      }
    });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Create payment error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  } finally {
    client.release();
  }
};

// Get payment by ID
const getPaymentById = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await pool.query(
      `SELECT p.*, 
       s.student_code, s.full_name as student_name,
       tf.total_amount, tf.semester_id,
       sem.name as semester_name, sem.year as semester_year,
       u.username as created_by_name
       FROM payments p
       JOIN students s ON p.student_id = s.id
       LEFT JOIN tuition_fees tf ON p.tuition_fee_id = tf.id
       LEFT JOIN semesters sem ON tf.semester_id = sem.id
       LEFT JOIN users u ON p.created_by = u.id
       WHERE p.id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy thông tin thanh toán'
      });
    }

    res.json({
      success: true,
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Get payment by ID error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Get student's payment history
const getStudentPayments = async (req, res) => {
  try {
    const { student_id } = req.params;

    const result = await pool.query(
      `SELECT p.*, 
       tf.total_amount, tf.semester_id,
       sem.name as semester_name, sem.year as semester_year
       FROM payments p
       LEFT JOIN tuition_fees tf ON p.tuition_fee_id = tf.id
       LEFT JOIN semesters sem ON tf.semester_id = sem.id
       WHERE p.student_id = $1
       ORDER BY p.payment_date DESC`,
      [student_id]
    );

    // Calculate total paid
    const totalPaid = result.rows.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);

    res.json({
      success: true,
      data: {
        payments: result.rows,
        totalPaid
      }
    });
  } catch (error) {
    console.error('Get student payments error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Get payment statistics
const getPaymentStats = async (req, res) => {
  try {
    const { start_date, end_date, semester_id } = req.query;

    let whereConditions = [];
    let params = [];
    let paramIndex = 1;

    if (start_date) {
      whereConditions.push(`p.payment_date >= $${paramIndex}`);
      params.push(start_date);
      paramIndex++;
    }

    if (end_date) {
      whereConditions.push(`p.payment_date <= $${paramIndex}`);
      params.push(end_date);
      paramIndex++;
    }

    if (semester_id) {
      whereConditions.push(`tf.semester_id = $${paramIndex}`);
      params.push(semester_id);
      paramIndex++;
    }

    const whereClause = whereConditions.length > 0 ? `WHERE ${whereConditions.join(' AND ')}` : '';

    const totalResult = await pool.query(
      `SELECT 
       COUNT(*) as total_transactions,
       COALESCE(SUM(p.amount), 0) as total_amount
       FROM payments p
       LEFT JOIN tuition_fees tf ON p.tuition_fee_id = tf.id
       ${whereClause}`,
      params
    );

    const byMethodResult = await pool.query(
      `SELECT payment_method, COUNT(*) as count, COALESCE(SUM(p.amount), 0) as total_amount
       FROM payments p
       LEFT JOIN tuition_fees tf ON p.tuition_fee_id = tf.id
       ${whereClause}
       GROUP BY payment_method`,
      params
    );

    // Daily payments for last 30 days
    const dailyResult = await pool.query(
      `SELECT DATE(payment_date) as date, COUNT(*) as count, COALESCE(SUM(amount), 0) as total
       FROM payments
       WHERE payment_date >= CURRENT_DATE - INTERVAL '30 days'
       GROUP BY DATE(payment_date)
       ORDER BY date DESC`
    );

    res.json({
      success: true,
      data: {
        summary: totalResult.rows[0],
        byMethod: byMethodResult.rows,
        daily: dailyResult.rows
      }
    });
  } catch (error) {
    console.error('Get payment stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

module.exports = {
  getAllPayments,
  createPayment,
  getPaymentById,
  getStudentPayments,
  getPaymentStats
};
