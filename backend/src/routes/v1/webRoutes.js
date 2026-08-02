import express from 'express';
import { changePassword, forgotPassword, getUserProfile, loginUser, logoutUser, registerUser, resetPassword, updateProfile, verifyOtp, verifyRegistrationOtp } from '../../controllers/web/authController.js';
import { authentication } from '../../middleware/authMiddleware.js';

const router = express.Router();

// auth routes
router.post('/register', registerUser);
router.post('/verify-register', verifyRegistrationOtp);
router.post('/login', loginUser);
router.post('/update-profile', authentication, updateProfile);
router.post('/change-password', authentication, changePassword);
router.post("/forgot-password", forgotPassword);
router.post("/verify-otp", verifyOtp);
router.post("/reset-password", resetPassword);
router.post('/logout', logoutUser);

// router.post("/check/email", async (req, res) => {
//     try {
//         await sendEmail({
//             to: "akonline2842003@gmail.com",
//             subject: "Password Reset OTP",
//             text: `Your OTP for password reset is 123456. It is valid for 15 minutes.`,
//             html: `<p>Your OTP for password reset is <b>123456</b></p><p>Valid for 15 minutes only.</p>`,
//         });
//     } catch (error) {
//         console.log(error)
//     }
// })


// profile routes
router.get('/me', authentication, getUserProfile)


// --- Home page routes ---
// router.get('/announcements', getWebAnnouncement);
// router.get('/banners', getWebBanner);
// router.get('/categories', getWebCategories);
// router.get('/products', getAllProducts);
// router.get('/products/:slug', getProductBySlug);
// router.get('/offers', getWebOffer);
// router.get('/testimonials', getWebTestimonial);
// router.get('/blogs', getWebBlog);
// router.get('/blog/:slug', getBlogBySlug);


// address routes
// router.post('/addresses', authentication, createAddress);
// router.get('/addresses', authentication, getUserAddresses);
// router.get('/addresses/:id', authentication, getAddressById);
// router.put('/addresses/:id', authentication, updateAddress);
// router.delete('/addresses/:id', authentication, deleteAddress);


// cart routes
// router.post('/cart/merge', authentication, mergeCart);
// router.get('/cart', getCart);
// router.post('/cart', addItemToCart);
// router.delete('/cart/item/:productId', removeItemFromCart);
// router.post('/cart/merge', authentication, mergeCart); // only for logged in users
// router.get('/cart', authentication, getCart); // only user carts now
// router.post('/cart', authentication, addItemToCart);
// router.delete('/cart/item/:productId', authentication, removeItemFromCart);


// wishlist routes
// router.get('/wishlist', authentication, getWishlist);
// router.post('/wishlist', authentication, addToWishlist);
// router.delete('/wishlist/:productId', authentication, removeFromWishlist);


// payment routes
// router.post('/payments/orders', authentication, createRazorpayOrder);
// router.post("/payments/callback", callbackVerifyAndCreateOrder);
// router.post("/payments/verify", authentication, verifyFromFrontend);
// router.post("/payments/webhook", webhook);

// order routes
// router.post('/orders', authentication, createCODOrder);
// router.get('/orders', authentication, getMyOrders);
// router.get('/orders/:id', authentication, getOrderById);




export default router;