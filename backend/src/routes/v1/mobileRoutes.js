import express from 'express';
import { loginUser, getUserProfile, verifyLoginOtp, sendRegisterOtp, verifyRegisterOtp, sendResetPasswordOtp, resetPassword, changePassword } from '../../controllers/mobile/authController.js';
import { mobileAuth } from '../../middleware/mobileAuthMiddleware.js';
import { createBuyRPRequest, getAllRPPlans, getBuyRPHistory, getRPPlans } from '../../controllers/mobile/buyRPController.js';
import { createSellRequest, getSellPageData, getSellRPHistory } from '../../controllers/mobile/sellRPController.js';
import { addBankAccount, deleteBankAccount, getBankAccounts, updateBankAccount } from '../../controllers/mobile/bankAccountController.js';
import { getHome } from '../../controllers/mobile/homeController.js';
import { createPayment, getPaymentStatus, verifyPayment } from '../../controllers/mobile/paymentController.js';
import { upiGatewayWebhook } from '../../controllers/upigatewayWebhook.js';
import { createSupport } from '../../controllers/mobile/supportController.js';
import { getLinks } from '../../controllers/admin/socialController.js';
import { getCoursesForUser } from '../../controllers/mobile/courseController.js';
import { getUpiDetails } from '../../controllers/mobile/upiController.js';

const router = express.Router();

// auth
// router.post('/auth/register', registerUser);
router.post('/auth/register/send-otp', sendRegisterOtp);
router.post('/auth/register/verify-otp', verifyRegisterOtp);

router.post('/auth/login', loginUser);
router.post('/auth/login-otp', verifyLoginOtp);

router.post('/auth/forgot-password/send-otp', sendResetPasswordOtp);
router.post('/auth/forgot-password/reset', resetPassword);

router.post('/auth/change-password', mobileAuth, changePassword);

// get profile
router.get('/auth/profile', mobileAuth, getUserProfile);
router.get('/home', mobileAuth, getHome);


// upi routes(upi id and qr code)
router.get('/upi/details', getUpiDetails)


// Buy RP 
router.get("/rp/plans", mobileAuth, getRPPlans);
router.get("/rp/plans/all", mobileAuth, getAllRPPlans);
router.post("/rp/buy", mobileAuth, createBuyRPRequest);
// router.post("/rp/buy", mobileAuth, buyRP);
router.get("/rp/buy/history", mobileAuth, getBuyRPHistory);


// Add bank details
router.post("/bank/add", mobileAuth, addBankAccount);
router.get("/bank/list", mobileAuth, getBankAccounts);
router.put("/bank/update/:id", mobileAuth, updateBankAccount);
router.delete("/bank/delete/:id", mobileAuth, deleteBankAccount);


// Sell RP
router.get("/rp/sell-page", mobileAuth, getSellPageData);
router.post("/rp/sell", mobileAuth, createSellRequest);
router.get("/rp/sell/history", mobileAuth, getSellRPHistory);


// Payment gateway
router.post("/create/payment", mobileAuth, createPayment);
router.post("/verify/payment", mobileAuth, verifyPayment);
router.get("/payment/status/:orderId", mobileAuth, getPaymentStatus);
router.post("/webhook", upiGatewayWebhook);


// Support
router.post("/support", mobileAuth, createSupport);


// Social Links
router.get("/social-links", getLinks);


// Courses
router.get("/courses", mobileAuth, getCoursesForUser);



export default router;
