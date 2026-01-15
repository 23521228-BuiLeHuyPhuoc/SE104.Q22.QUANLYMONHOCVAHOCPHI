import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { AuthProvider, useAuth } from './context/AuthContext';
import Layout from './components/Layout';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Students from './pages/Students';
import Courses from './pages/Courses';
import Registrations from './pages/Registrations';
import Tuition from './pages/Tuition';
import Payments from './pages/Payments';
import Semesters from './pages/Semesters';
import CourseRegistration from './pages/CourseRegistration';
import MyCourses from './pages/MyCourses';
import MyTuition from './pages/MyTuition';
import MyPayments from './pages/MyPayments';
import './App.css';

// Protected route wrapper for admin
const AdminRoute = ({ children }) => {
  const { isAdmin, loading } = useAuth();
  if (loading) return null;
  return isAdmin ? children : <Navigate to="/dashboard" replace />;
};

// Protected route wrapper for student
const StudentRoute = ({ children }) => {
  const { isAdmin, loading } = useAuth();
  if (loading) return null;
  return !isAdmin ? children : <Navigate to="/dashboard" replace />;
};

function App() {
  return (
    <AuthProvider>
      <Router>
        <Routes>
          <Route path="/login" element={<Login />} />
          
          <Route element={<Layout />}>
            <Route path="/dashboard" element={<Dashboard />} />
            
            {/* Admin routes */}
            <Route path="/students" element={<AdminRoute><Students /></AdminRoute>} />
            <Route path="/courses" element={<AdminRoute><Courses /></AdminRoute>} />
            <Route path="/registrations" element={<AdminRoute><Registrations /></AdminRoute>} />
            <Route path="/tuition" element={<AdminRoute><Tuition /></AdminRoute>} />
            <Route path="/payments" element={<AdminRoute><Payments /></AdminRoute>} />
            <Route path="/semesters" element={<AdminRoute><Semesters /></AdminRoute>} />
            
            {/* Student routes */}
            <Route path="/course-registration" element={<StudentRoute><CourseRegistration /></StudentRoute>} />
            <Route path="/my-courses" element={<StudentRoute><MyCourses /></StudentRoute>} />
            <Route path="/my-tuition" element={<StudentRoute><MyTuition /></StudentRoute>} />
            <Route path="/my-payments" element={<StudentRoute><MyPayments /></StudentRoute>} />
          </Route>
          
          <Route path="/" element={<Navigate to="/dashboard" replace />} />
          <Route path="*" element={<Navigate to="/dashboard" replace />} />
        </Routes>
      </Router>
      <ToastContainer
        position="top-right"
        autoClose={3000}
        hideProgressBar={false}
        newestOnTop
        closeOnClick
        rtl={false}
        pauseOnFocusLoss
        draggable
        pauseOnHover
        theme="light"
      />
    </AuthProvider>
  );
}

export default App;
