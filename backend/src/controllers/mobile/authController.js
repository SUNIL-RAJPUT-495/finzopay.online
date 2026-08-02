
import referralModel from "../../models/referralModel.js";
import User from "../../models/userModel.js";
import Wallet from "../../models/walletModel.js";
import generateMobileToken from "../../utils/generateMobileToken.js";
import sendSMS from "../../utils/sendSMS.js";






// send registration otp
// export const sendRegisterOtp = async (req, res) => {
//     try {
//         const { phone, inviteCode } = req.body;

//         if (!phone || !inviteCode) {
//             return res.status(400).json({
//                 success: false,
//                 message: "Phone and invite code are required",
//             });
//         }

//         const userExists = await User.findOne({ phone });
//         if (userExists) {
//             return res.status(409).json({
//                 success: false,
//                 message: "User already exists",
//             });
//         }

//         const referral = await referralModel.findOne({ code: inviteCode.toUpperCase() });
//         if (!referral || referral.status !== "ACTIVE" || referral.usageLimit <= 0) {
//             return res.status(400).json({
//                 success: false,
//                 message: "Invalid or inactive referral code",
//             });
//         }

//         const otp = Math.floor(1000 + Math.random() * 9000);

//         await User.findOneAndUpdate(
//             { phone },
//             {
//                 phone,
//                 inviteCode,
//                 otp,
//                 otpExpire: Date.now() + 5 * 60 * 1000,
//             },
//             { upsert: true }
//         );

//         await referralModel.updateOne({ code: inviteCode.toUpperCase() }, $set: {usageLimit: referral.usageLimit-1})

//         await sendSMS({ to: phone, otp });

//         res.json({
//             success: true,
//             message: "OTP sent for registration",
//         });
//     } catch (err) {
//         res.status(500).json({ success: false, message: "Server error" });
//     }
// };

// send registration otp
export const sendRegisterOtp = async (req, res) => {
    try {
        let { phone, inviteCode } = req.body;

        // ðŸ”¹ Basic validation
        if (!phone || !inviteCode) {
            return res.status(400).json({
                success: false,
                message: "Phone and invite code are required",
            });
        }

        // ðŸ”¹ Phone validation (India)
        if (!/^[6-9]\d{9}$/.test(phone)) {
            return res.status(400).json({
                success: false,
                message: "Invalid phone number",
            });
        }

        // ðŸ”¹ Normalize invite code
        inviteCode = inviteCode.toUpperCase();

        // ðŸ”¹ Check if user already exists (fully registered)
        const userExists = await User.findOne({ phone, isVerified: true });
        if (userExists) {
            return res.status(409).json({
                success: false,
                message: "User already exists",
            });
        }

        // ðŸ”¹ Check existing OTP cooldown
        const existingUser = await User.findOne({ phone });
        if (existingUser && existingUser.otpExpire > Date.now()) {
            return res.status(429).json({
                success: false,
                message: "OTP already sent. Please wait",
            });
        }

        // ðŸ”¹ Atomic referral update (prevents race condition)
        const referral = await referralModel.findOneAndUpdate(
            { code: inviteCode, status: "ACTIVE", usageLimit: { $gt: 0 } },
            { $inc: { usageLimit: -1 } },
            { new: true }
        );

        if (!referral) {
            return res.status(400).json({
                success: false,
                message: "Invalid or expired referral code",
            });
        }

        // ðŸ”¹ Secure OTP
        const otp = Math.floor(1000 + Math.random() * 9000);

        // ðŸ”¹ Save / update user OTP
        await User.findOneAndUpdate(
            { phone },
            {
                phone,
                inviteCode,
                otp,
                otpExpire: Date.now() + 5 * 60 * 1000, // 5 min
                isVerified: false,
            },
            { upsert: true, new: true }
        );

        // ðŸ”¹ Send SMS
        // await sendSMS({ to: phone, otp });
        // 🔹 Send SMS
        try {
            await sendSMS({ to: phone, otp });
        } catch (smsError) {
            console.error("SMS Send Error:", smsError);

            return res.status(500).json({
                success: false,
                message: "SMS not sent",
            });
        }

        return res.json({
            success: true,
            message: "OTP sent successfully",
        });

    } catch (err) {
        console.error("Send OTP Error:", err);
        return res.status(500).json({
            success: false,
            message: "Server error",
        });
    }
};


// Verify OTP & Complete Registration
export const verifyRegisterOtp = async (req, res) => {
    try {
        const { phone, otp, password, email } = req.body;

        if (!phone || !otp || !password) {
            return res.status(400).json({
                success: false,
                message: "Phone, OTP and password required",
            });
        }

        const user = await User.findOne({
            phone,
            otp,
            otpExpire: { $gt: Date.now() },
        });

        if (!user) {
            return res.status(401).json({
                success: false,
                message: "Invalid or expired OTP",
            });
        }

        user.password = password;
        user.email = email || null;
        user.isVerified = true;
        user.otp = undefined;
        user.otpExpire = undefined;

        await user.save();

        res.status(201).json({
            success: true,
            message: "Registration successful",
            token: generateMobileToken(user._id),
        });
    } catch (err) {
        res.status(500).json({ success: false, message: "Server error" });
    }
};


// send login otp
export const loginUser = async (req, res) => {
    try {
        const { phone, password } = req.body;

        if (!phone || !password) {
            return res.status(400).json({
                success: false,
                message: "Phone and password are required",
            });
        }

        const user = await User.findOne({ phone }).select("+password");

        if (!user) {
            return res.status(401).json({
                success: false,
                message: "Invalid phone or password",
            });
        }

        if (user.isBlocked) {
            return res.status(401).json({
                success: false,
                message: "Your account is blocked",
            });
        }

        const isMatch = await user.comparePassword(password);
        if (!isMatch) {
            return res.status(401).json({
                success: false,
                message: "Invalid phone or password",
            });
        }

        // âœ… Generate OTP
        const otp = Math.floor(1000 + Math.random() * 9000);

        user.otp = otp;
        user.otpExpire = Date.now() + 5 * 60 * 1000; // 5 min
        await user.save();

        // âœ… Send SMS
        try {
            await sendSMS({ to: phone, otp });
        } catch (smsError) {
            console.error("SMS Send Error:", smsError);

            return res.status(500).json({
                success: false,
                message: "SMS not sent",
            });
        }

        res.status(200).json({
            success: true,
            message: "OTP sent to your mobile number",
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Server error",
            error: error.message,
        });
    }
};


// Verify OTP & Complete Login
export const verifyLoginOtp = async (req, res) => {
    try {
        const { phone, otp } = req.body;

        if (!phone || !otp) {
            return res.status(400).json({
                success: false,
                message: "Phone and OTP are required",
            });
        }

        const user = await User.findOne({
            phone,
            otp,
            otpExpire: { $gt: Date.now() },
        });

        if (!user) {
            return res.status(401).json({
                success: false,
                message: "Invalid or expired OTP",
            });
        }

        // âœ… Clear OTP
        user.otp = undefined;
        user.otpExpire = undefined;
        await user.save();

        res.status(200).json({
            success: true,
            message: "Login successful",
            data: {
                id: user._id,
                email: user.email,
                phone: user.phone,
                role: user.role,
                token: generateMobileToken(user._id),
            },
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Server error",
            error: error.message,
        });
    }
};


// Forgot / Reset Password
export const sendResetPasswordOtp = async (req, res) => {
    try {
        const { phone } = req.body;

        const user = await User.findOne({ phone });
        if (!user) {
            return res.status(404).json({
                success: false,
                message: "User not found",
            });
        }

        const otp = Math.floor(1000 + Math.random() * 9000);

        user.otp = otp;
        user.otpExpire = Date.now() + 5 * 60 * 1000;
        await user.save();

        try {
            await sendSMS({ to: phone, otp });
        } catch (smsError) {
            console.error("SMS Send Error:", smsError);

            return res.status(500).json({
                success: false,
                message: "SMS not sent",
            });
        }

        res.json({
            success: true,
            message: "OTP sent for password reset",
        });
    } catch (err) {
        res.status(500).json({ success: false, message: "Server error" });
    }
};


// Verify OTP & Update Password
export const resetPassword = async (req, res) => {
    try {
        const { phone, otp, newPassword } = req.body;

        const user = await User.findOne({
            phone,
            otp,
            otpExpire: { $gt: Date.now() },
        });

        if (!user) {
            return res.status(401).json({
                success: false,
                message: "Invalid or expired OTP",
            });
        }

        user.password = newPassword;
        user.otp = undefined;
        user.otpExpire = undefined;

        await user.save();

        res.json({
            success: true,
            message: "Password reset successful",
        });
    } catch (err) {
        res.status(500).json({ success: false, message: "Server error" });
    }
};


// Change Password (User Logged In)
export const changePassword = async (req, res) => {
    try {
        const { currentPassword, newPassword, confirmPassword } = req.body;

        if (newPassword !== confirmPassword) {
            return res.status(400).json({
                success: false,
                message: "Passwords do not match",
            });
        }

        const user = await User.findById(req.user.id).select("+password");

        const isMatch = await user.comparePassword(currentPassword);
        if (!isMatch) {
            return res.status(401).json({
                success: false,
                message: "Current password incorrect",
            });
        }

        user.password = newPassword;
        await user.save();

        res.json({
            success: true,
            message: "Password changed successfully",
        });
    } catch (err) {
        res.status(500).json({ success: false, message: "Server error" });
    }
};






// export const registerUser = async (req, res) => {
//     try {
//         const { email, phone, password, inviteCode } = req.body;

//         // âœ… Required field validation
//         if (!phone || !password || !inviteCode) {
//             return res.status(400).json({
//                 success: false,
//                 message: "Phone number, password and invite code are required",
//             });
//         }

//         // âœ… Check existing user by phone
//         const userExists = await User.findOne({ phone });
//         if (userExists) {
//             return res.status(409).json({
//                 success: false,
//                 message: "User already exists with this phone number",
//             });
//         }

//         // ðŸ”¥ Validate referral
//         const referral = await referralModel.findOne({ code: inviteCode.toUpperCase() });

//         if (!referral) {
//             return res.status(400).json({
//                 success: false,
//                 message: "Invalid referral code",
//             });
//         }

//         if (referral.status !== "ACTIVE") {
//             return res.status(400).json({
//                 success: false,
//                 message: "Referral disabled",
//             });
//         }

//         const now = new Date();

//         if (now < referral.validFrom || now > referral.validTill) {
//             return res.status(400).json({
//                 success: false,
//                 message: "Referral expired",
//             });
//         }

//         if (referral.usedCount >= referral.usageLimit) {
//             return res.status(400).json({
//                 success: false,
//                 message: "Referral limit reached",
//             });
//         }

//         // âœ… Create user (email optional)
//         const user = await User.create({
//             email: email || null,
//             phone,
//             password,
//             inviteCode,
//         });

//         return res.status(201).json({
//             success: true,
//             message: "User registered successfully",
//             data: {
//                 id: user._id,
//                 email: user.email,
//                 role: user.role,
//                 token: generateMobileToken(user._id),
//             },
//         });
//     } catch (error) {
//         console.error("Register Error:", error);

//         return res.status(500).json({
//             success: false,
//             message: "Server error",
//         });
//     }
// };








export const getUserProfile = async (req, res) => {
    try {
        const user = await User.findById(req.user.id);

        if (!user) {
            return res.status(404).json({
                success: false,
                message: "User not found",
            });
        }

        /* =====================
           WALLET
        ===================== */
        let wallet = await Wallet.findOne({ userId: user });
        if (!wallet) {
            wallet = await Wallet.create({
                user,
                total_rp: 0,
                locked_rp: 0
            });
        }

        res.json({
            success: true,
            data: {
                id: user._id,
                name: user.name,
                email: user.email,
                phone: user.phone,
                role: user.role,
                balance: wallet.total_rp
            },
        });
    } catch (error) {
        console.log(error)
        res.status(500).json({
            success: false,
            message: "Server error",
        });
    }
};
