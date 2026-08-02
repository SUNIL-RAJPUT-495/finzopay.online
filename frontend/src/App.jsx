import { Routes, Route } from "react-router-dom"
import Home from "./pages/web/Home"
import AdminLogin from "./pages/admin/AdminLogin"
import Dashboard from "./pages/admin/Dashboard"
import AdminLayout from "./components/admin/layout/AdminLayout"
import RpPlans from "./pages/admin/RpPlans"
import SellRpRequests from "./pages/admin/SellRpRequests"
import Users from "./pages/admin/Users"
import Banners from "./pages/admin/Banners"
import Referral from "./pages/admin/Referral"
import Support from "./pages/admin/Support"
import SocialMedia from "./pages/admin/SocialMedia"
import PaymentReturn from "./pages/web/PaymentReturn"
import Courses from "./pages/admin/Courses"
import SendNotification from "./pages/admin/SendNotification"
import Profile from "./pages/admin/Profile"
import BuyRpRequests from "./pages/admin/BuyRpRequests"
import { AdminAuthProvider } from "./context/AdminAuthContext"
import ProtectedRoute from "./components/admin/ProtectedRoute"

function App() {
  return (
    <Routes>
      {/* Website */}
      <Route path="/" element={<Home />} />

      {/* Webhook */}
      <Route path="/payment-return" element={<PaymentReturn />} />

      {/* Admin Routes with Session Context */}
      <Route element={<AdminAuthProvider />}>
        {/* Admin Login */}
        <Route path="/system/login" element={<AdminLogin />} />

        {/* Admin Protected Area */}
        <Route
          path="/system/"
          element={
            <ProtectedRoute>
              <AdminLayout />
            </ProtectedRoute>
          }
        >
          <Route path="dashboard" element={<Dashboard />} />

          {/* Banners */}
          <Route path="banners" element={<Banners />} />

          {/* RP Plans */}
          <Route path="rp-plans" element={<RpPlans />} />

          {/* RP Buy Request */}
          <Route path="rp-buy-request" element={<BuyRpRequests />} />

          {/* RP Sell Request */}
          <Route path="rp-sell-request" element={<SellRpRequests />} />

          {/* Referal */}
          <Route path="referral" element={<Referral />} />

          {/* Support */}
          <Route path="support" element={<Support />} />

          {/* Users */}
          <Route path="users" element={<Users />} />

          {/* Social Media */}
          <Route path="courses" element={<Courses />} />

          {/* Notification */}
          <Route path="notification" element={<SendNotification />} />

          {/* Social Media */}
          <Route path="social-media" element={<SocialMedia />} />

          {/* Social Media */}
          <Route path="profile" element={<Profile />} />

          {/* future routes */}
          {/* <Route path="users" element={<Users />} /> */}
        </Route>
      </Route>

      {/* ================= 404 ================= */}
      {/* <Route path="*" element={<NotFound />} /> */}
    </Routes>
  )
}

export default App
