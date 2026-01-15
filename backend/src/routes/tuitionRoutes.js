const express = require('express');
const router = express.Router();
const tuitionController = require('../controllers/tuitionController');
const { authMiddleware, adminMiddleware } = require('../middleware/auth');

// All routes require authentication
router.use(authMiddleware);

// Get all tuition fees
router.get('/', tuitionController.getAllTuitionFees);

// Get tuition statistics
router.get('/stats', tuitionController.getTuitionStats);

// Get student's tuition fees
router.get('/student/:student_id', tuitionController.getStudentTuitionFee);

// Get tuition fee by ID
router.get('/:id', tuitionController.getTuitionFeeById);

// Calculate tuition fee
router.post('/calculate', tuitionController.calculateTuitionFee);

module.exports = router;
