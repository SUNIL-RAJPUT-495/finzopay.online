import express from 'express';
import upload from '../../middleware/multer.js';
import { adminLogin, adminLogout, adminSignup, getAdminProfile, updateAdmin } from '../../controllers/admin/authController.js';
import { authentication, authorizeRoles } from '../../middleware/authMiddleware.js';
import { loginLimiter } from '../../middleware/rateLimitMiddleware.js';
import { getDashboardStats } from '../../controllers/admin/dashboardController.js';
import { getUserDetails, getUsersList, toggleUserBlock } from '../../controllers/admin/userController.js';
import { createBanner, deleteBanner, getBanners, updateBanner } from '../../controllers/admin/bannerController.js';
import { addRPPlan, getAllBuyedRPPlans, getAllRPPlans, updateRPPlan, verifyBuyRP } from '../../controllers/admin/buyRPController.js';
import { getPendingSellRequests, markSellAsPaid, rejectSellRequest } from '../../controllers/admin/sellRPController.js';
import { createReferral, deleteReferral, getReferrals, updateReferralStatus } from '../../controllers/admin/referralController.js';
import { getLinks, updateLinks } from '../../controllers/admin/socialController.js';
import { deleteSupport, getAllSupport, updateSupportStatus } from '../../controllers/admin/supportController.js';
import { addCourse, getAllCourses, toggleCourseStatus, updateCourse } from '../../controllers/admin/courseController.js';
// import { sendPushNotification } from '../../controllers/admin/notificationController.js';

const router = express.Router();


// auth routes
router.post('/signup', adminSignup);
router.post('/login', loginLimiter, adminLogin);

// Protect all subsequent admin routes
router.use(authentication);
router.use(authorizeRoles('admin', 'super_admin'));

router.get('/profile', getAdminProfile);
router.put("/update", upload.single("qrCode"), updateAdmin);
// router.post('/update-profile', authorizeRoles('admin'), updateProfile);
// router.post('/change-password', authorizeRoles('admin'), changePassword);
router.post('/logout', adminLogout);

// dashboard route
router.get('/dashboard', getDashboardStats)


// User Routes
router.get("/users", getUsersList);
router.put("/users/toggle-block/:userId", toggleUserBlock);
router.get("/users/:userId", getUserDetails);


// Banners
router.post("/banners", upload.single('image'), createBanner);
router.get("/banners", getBanners);
router.put("/banners/:id", updateBanner);
router.delete("/banners/:id", deleteBanner);


// Buy RP Plan 
router.post("/rpplan/add", addRPPlan);
router.put("/rpplan/update/:id", updateRPPlan);
router.get("/rpplan/list", getAllRPPlans);

router.get("/rpplan/buyed/list", getAllBuyedRPPlans);
router.post("/rpplan/buyed/verify/:id", verifyBuyRP);



// Sell RP Plan
router.get("/sellrp/pending", getPendingSellRequests);
router.post("/sellrp/paid/:id", markSellAsPaid);
router.post("/sellrp/reject/:id", rejectSellRequest);


// Referral
router.get("/referral", getReferrals);
router.post("/referral", createReferral);
router.patch("/referral/:id", updateReferralStatus);
router.delete("/referral/:id", deleteReferral);



// Support
router.get("/support", getAllSupport);
router.put("/support/:id/status", updateSupportStatus);
router.delete("/support/:id", deleteSupport);


// Social links
router.get("/social-links", getLinks);
router.post("/social-links", updateLinks);


// Notification
// router.post("/send", sendPushNotification);


// Courses
router.post("/course/add", addCourse);
router.get("/course/list", getAllCourses);
router.put("/course/update/:id", updateCourse);
router.put("/course/status/:id", toggleCourseStatus);



export default router;