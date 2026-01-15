const pool = require('../config/database');

// Get all semesters
const getAllSemesters = async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT * FROM semesters ORDER BY year DESC, name DESC`
    );

    res.json({
      success: true,
      data: result.rows
    });
  } catch (error) {
    console.error('Get all semesters error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Get active semester
const getActiveSemester = async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT * FROM semesters WHERE is_active = true LIMIT 1`
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không có học kỳ đang hoạt động'
      });
    }

    res.json({
      success: true,
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Get active semester error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Get semester by ID
const getSemesterById = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await pool.query(
      `SELECT * FROM semesters WHERE id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy học kỳ'
      });
    }

    res.json({
      success: true,
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Get semester by ID error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Create new semester
const createSemester = async (req, res) => {
  try {
    const {
      name,
      year,
      start_date,
      end_date,
      registration_start,
      registration_end,
      is_active = false
    } = req.body;

    if (!name || !year || !start_date || !end_date) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập đầy đủ thông tin học kỳ'
      });
    }

    // If this semester is active, deactivate others
    if (is_active) {
      await pool.query('UPDATE semesters SET is_active = false');
    }

    const result = await pool.query(
      `INSERT INTO semesters (name, year, start_date, end_date, registration_start, registration_end, is_active)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [name, year, start_date, end_date, registration_start, registration_end, is_active]
    );

    res.status(201).json({
      success: true,
      message: 'Thêm học kỳ thành công',
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Create semester error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

// Update semester
const updateSemester = async (req, res) => {
  const client = await pool.connect();
  try {
    const { id } = req.params;
    const {
      name,
      year,
      start_date,
      end_date,
      registration_start,
      registration_end,
      is_active
    } = req.body;

    // Check if semester exists
    const existingSemester = await client.query(
      'SELECT id FROM semesters WHERE id = $1',
      [id]
    );

    if (existingSemester.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy học kỳ'
      });
    }

    await client.query('BEGIN');

    // If this semester is set to active, deactivate others
    if (is_active === true) {
      await client.query('UPDATE semesters SET is_active = false WHERE id != $1', [id]);
    }

    const result = await client.query(
      `UPDATE semesters SET 
       name = COALESCE($1, name),
       year = COALESCE($2, year),
       start_date = COALESCE($3, start_date),
       end_date = COALESCE($4, end_date),
       registration_start = COALESCE($5, registration_start),
       registration_end = COALESCE($6, registration_end),
       is_active = COALESCE($7, is_active),
       updated_at = CURRENT_TIMESTAMP
       WHERE id = $8
       RETURNING *`,
      [name, year, start_date, end_date, registration_start, registration_end, is_active, id]
    );

    await client.query('COMMIT');

    res.json({
      success: true,
      message: 'Cập nhật học kỳ thành công',
      data: result.rows[0]
    });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Update semester error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  } finally {
    client.release();
  }
};

// Delete semester
const deleteSemester = async (req, res) => {
  try {
    const { id } = req.params;

    const existingSemester = await pool.query(
      'SELECT id FROM semesters WHERE id = $1',
      [id]
    );

    if (existingSemester.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy học kỳ'
      });
    }

    // Check if semester has courses or registrations
    const hasData = await pool.query(
      `SELECT 
       (SELECT COUNT(*) FROM courses WHERE semester_id = $1) as course_count,
       (SELECT COUNT(*) FROM course_registrations WHERE semester_id = $1) as registration_count`,
      [id]
    );

    if (parseInt(hasData.rows[0].course_count) > 0 || parseInt(hasData.rows[0].registration_count) > 0) {
      return res.status(400).json({
        success: false,
        message: 'Không thể xóa học kỳ đã có môn học hoặc đăng ký'
      });
    }

    await pool.query('DELETE FROM semesters WHERE id = $1', [id]);

    res.json({
      success: true,
      message: 'Xóa học kỳ thành công'
    });
  } catch (error) {
    console.error('Delete semester error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};

module.exports = {
  getAllSemesters,
  getActiveSemester,
  getSemesterById,
  createSemester,
  updateSemester,
  deleteSemester
};
