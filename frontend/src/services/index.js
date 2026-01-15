import api from './api';

export const authService = {
  login: async (username, password) => {
    const response = await api.post('/auth/login', { username, password });
    return response.data;
  },

  register: async (userData) => {
    const response = await api.post('/auth/register', userData);
    return response.data;
  },

  getMe: async () => {
    const response = await api.get('/auth/me');
    return response.data;
  },

  changePassword: async (currentPassword, newPassword) => {
    const response = await api.put('/auth/change-password', { currentPassword, newPassword });
    return response.data;
  },
};

export const studentService = {
  getAll: async (params) => {
    const response = await api.get('/students', { params });
    return response.data;
  },

  getById: async (id) => {
    const response = await api.get(`/students/${id}`);
    return response.data;
  },

  create: async (data) => {
    const response = await api.post('/students', data);
    return response.data;
  },

  update: async (id, data) => {
    const response = await api.put(`/students/${id}`, data);
    return response.data;
  },

  delete: async (id) => {
    const response = await api.delete(`/students/${id}`);
    return response.data;
  },

  getStats: async () => {
    const response = await api.get('/students/stats');
    return response.data;
  },
};

export const courseService = {
  getAll: async (params) => {
    const response = await api.get('/courses', { params });
    return response.data;
  },

  getById: async (id) => {
    const response = await api.get(`/courses/${id}`);
    return response.data;
  },

  create: async (data) => {
    const response = await api.post('/courses', data);
    return response.data;
  },

  update: async (id, data) => {
    const response = await api.put(`/courses/${id}`, data);
    return response.data;
  },

  delete: async (id) => {
    const response = await api.delete(`/courses/${id}`);
    return response.data;
  },

  getStats: async () => {
    const response = await api.get('/courses/stats');
    return response.data;
  },
};

export const registrationService = {
  getAll: async (params) => {
    const response = await api.get('/registrations', { params });
    return response.data;
  },

  getStudentCourses: async (studentId, params) => {
    const response = await api.get(`/registrations/student/${studentId}`, { params });
    return response.data;
  },

  getAvailableCourses: async (params) => {
    const response = await api.get('/registrations/available', { params });
    return response.data;
  },

  register: async (data) => {
    const response = await api.post('/registrations', data);
    return response.data;
  },

  cancel: async (id) => {
    const response = await api.put(`/registrations/${id}/cancel`);
    return response.data;
  },

  getStats: async (params) => {
    const response = await api.get('/registrations/stats', { params });
    return response.data;
  },
};

export const tuitionService = {
  getAll: async (params) => {
    const response = await api.get('/tuition', { params });
    return response.data;
  },

  getById: async (id) => {
    const response = await api.get(`/tuition/${id}`);
    return response.data;
  },

  getStudentTuition: async (studentId, params) => {
    const response = await api.get(`/tuition/student/${studentId}`, { params });
    return response.data;
  },

  calculate: async (data) => {
    const response = await api.post('/tuition/calculate', data);
    return response.data;
  },

  getStats: async (params) => {
    const response = await api.get('/tuition/stats', { params });
    return response.data;
  },
};

export const paymentService = {
  getAll: async (params) => {
    const response = await api.get('/payments', { params });
    return response.data;
  },

  getById: async (id) => {
    const response = await api.get(`/payments/${id}`);
    return response.data;
  },

  getStudentPayments: async (studentId) => {
    const response = await api.get(`/payments/student/${studentId}`);
    return response.data;
  },

  create: async (data) => {
    const response = await api.post('/payments', data);
    return response.data;
  },

  getStats: async (params) => {
    const response = await api.get('/payments/stats', { params });
    return response.data;
  },
};

export const semesterService = {
  getAll: async () => {
    const response = await api.get('/semesters');
    return response.data;
  },

  getActive: async () => {
    const response = await api.get('/semesters/active');
    return response.data;
  },

  getById: async (id) => {
    const response = await api.get(`/semesters/${id}`);
    return response.data;
  },

  create: async (data) => {
    const response = await api.post('/semesters', data);
    return response.data;
  },

  update: async (id, data) => {
    const response = await api.put(`/semesters/${id}`, data);
    return response.data;
  },

  delete: async (id) => {
    const response = await api.delete(`/semesters/${id}`);
    return response.data;
  },
};
