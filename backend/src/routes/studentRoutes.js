const express = require('express');
const router = express.Router();
const studentController = require('../controllers/studentController');
const { authMiddleware, adminMiddleware } = require('../middleware/auth');

// All routes require authentication
router.use(authMiddleware);

// Get all students (with pagination and search)
router.get('/', studentController.getAllStudents);

// Get student statistics
router.get('/stats', studentController.getStudentStats);

// Get student by ID
router.get('/:id', studentController.getStudentById);

// Admin only routes
router.post('/', adminMiddleware, studentController.createStudent);
router.put('/:id', adminMiddleware, studentController.updateStudent);
router.delete('/:id', adminMiddleware, studentController.deleteStudent);

module.exports = router;
