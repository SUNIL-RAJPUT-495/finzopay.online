import User from '../../models/userModel.js';
import generateToken from '../../utils/generateToken.js';
import sendEmail from '../../utils/sendEmail.js';
import sendSMS from '../../utils/sendSMS.js';


// register user
// export const registerUser = async (req, res) => {
//     try {
//         const { email, phone, password } = req.body;

//         if (!email || !password) {
//             return res.status(400).json({ message: 'Please provide all required fields' });
//         }

//         const userExists = await User.findOne({ email });

//         if (userExists) {
//             console.log("User exists")
//             return res.status(400).json({ message: 'User with this email already exists' });
//         }

//         const user = await User.create({
//             phone,
//             email,
//             password,
//         });

//         if (user) {
//             res.status(201).json({
//                 _id: user._id,
//                 name: user.name,
//                 email: user.email,
//                 role: user.role,
//                 message: 'User registered successfully!',
//             });
//         } else {
//             res.status(400).json({ message: 'Invalid user data' });
//         }
//     } catch (error) {
//         console.log(error)
//         res.status(500).json({ message: 'Server Error', error: error.message });
//     }
// };

// Step 1: Register (send OTP)

export const registerUser = async (req, res) => {
    try {
        const { name, email, phone, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ message: 'Please provide all required fields' });
        }

        // Check if user already exists
        let user = await User.findOne({ email });

        if (user && user.isVerified) {
            return res.status(400).json({ message: 'User with this email already exists' });
        }

        // Generate OTP
        const otp = Math.floor(100000 + Math.random() * 900000).toString();

        if (!user) {
            // Create new user but keep it unverified until OTP check
            user = await User.create({
                name,
                phone,
                email,
                password,
                otp,
                otpExpire: Date.now() + 15 * 60 * 1000, // 15 minutes
                isVerified: false
            });
        } else {
            // Update OTP if user exists but not verified
            user.phone = phone;
            user.password = password;
            user.otp = otp;
            user.otpExpire = Date.now() + 15 * 60 * 1000;
            await user.save();
        }

        let emailSent = false;
        let smsSent = false;

        // Send OTP email
        if (email) {
            try {
                await sendEmail({
                    to: email,
                    subject: "Verify your account",
                    text: `Your OTP is ${otp}. It will expire in 15 minutes.`,
                    html: `<p>Your OTP is <b>${otp}</b></p><p>Valid for 15 minutes only.</p>`
                });
                emailSent = true;
            } catch (err) {
                console.log("Email sending error:", err.message);
            }
        }

        // Send OTP to phone
        if (phone) {
            try {
                await sendSMS({
                    to: `+91${phone}`,
                    body: `Your OTP is ${otp}. It will expire in 15 minutes.`,
                });
                smsSent = true;
            } catch (err) {
                console.log("SMS sending error:", err.message);
            }
        }

        // Prepare message
        let message = "";
        if (emailSent && smsSent) {
            message = "OTP sent to your email and phone.";
        } else if (emailSent) {
            message = "OTP sent to your email.";
        } else if (smsSent) {
            message = "OTP sent to your phone.";
        } else {
            return res.status(500).json({ message: "Failed to send OTP via email or phone." });
        }

        res.status(200).json({ message });

    } catch (error) {
        console.log(error);
        res.status(500).json({ message: 'Server Error', error: error.message });
    }
};

// Step 2: Verify OTP
export const verifyRegistrationOtp = async (req, res) => {
    try {
        const { email, otp } = req.body;

        const user = await User.findOne({
            email,
            otp,
            otpExpire: { $gt: Date.now() }
        });

        if (!user) {
            return res.status(400).json({ message: 'Invalid or expired OTP' });
        }

        user.isVerified = true;
        user.otp = undefined;
        user.otpExpire = undefined;
        await user.save();

        // Generate token after successful verification
        generateToken(res, user._id);

        res.status(200).json({
            _id: user._id,
            name: user.name,
            email: user.email,
            role: user.role,
            message: "Registration successful and account verified!"
        });

    } catch (error) {
        res.status(500).json({ message: 'Server Error', error: error.message });
    }
};


// login user
export const loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ message: 'Please provide email and password' });
        }

        const user = await User.findOne({ email, role: "user" }).select('+password');

        // Check if user exists and if passwords match
        if (user && (await user.comparePassword(password))) {
            generateToken(res, user._id);

            res.status(200).json({
                _id: user._id,
                name: user.name,
                email: user.email,
                role: user.role,
            });
        } else {
            res.status(401).json({ message: 'Invalid email or password' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Server Error', error: error.message });
    }
};

// google auth
export const googleAuthCallback = (req, res) => {
    generateToken(res, req.user._id);
    res.redirect(`${process.env.FRONTEND_URL}/auth/callback`);
    // res.redirect(`${process.env.FRONTEND_URL}/profile/orders`);
};

// facebook auth
export const facebookAuthCallback = (req, res) => {
    generateToken(res, req.user._id);
    res.redirect(`${process.env.FRONTEND_URL}/auth/callback`);
    // res.redirect(`${process.env.FRONTEND_URL}/profile/orders`);
};

// forgot password
export const forgotPassword = async (req, res) => {
    try {
        const { email } = req.body;
        if (!email) return res.status(400).json({ message: "Email is required" });

        const user = await User.findOne({ email });
        if (!user) return res.status(404).json({ message: "User not found" });

        // Generate 6-digit OTP
        const otp = Math.floor(100000 + Math.random() * 900000).toString();

        user.otp = otp;
        user.otpExpire = Date.now() + 15 * 60 * 1000; // 15 minutes
        await user.save();

        // Send email
        await sendEmail({
            to: user.email,
            subject: "Password Reset OTP",
            text: `Your OTP for password reset is ${otp}. It is valid for 15 minutes.`,
            html: `<p>Your OTP for password reset is <b>${otp}</b></p><p>Valid for 15 minutes only.</p>`,
        });

        res.status(200).json({ message: "OTP sent successfully to your email" });
    } catch (error) {
        res.status(500).json({ message: "Server Error", error: error.message });
    }
};

// verify otp
export const verifyOtp = async (req, res) => {
    try {
        const { email, otp } = req.body;

        const user = await User.findOne({
            email,
            otp,
            otpExpire: { $gt: Date.now() },
        });

        if (!user) {
            return res.status(400).json({ message: "Invalid or expired OTP" });
        }

        res.status(200).json({ message: "OTP verified successfully" });
    } catch (error) {
        res.status(500).json({ message: "Server Error", error: error.message });
    }
};

// reset password
export const resetPassword = async (req, res) => {
    try {
        const { email, otp, newPassword } = req.body;

        const user = await User.findOne({
            email,
            otp,
            otpExpire: { $gt: Date.now() },
        });

        if (!user) {
            return res.status(400).json({ message: "Invalid or expired OTP" });
        }

        user.password = newPassword;
        user.otp = undefined;
        user.otpExpire = undefined;
        await user.save();

        res.status(200).json({ message: "Password reset successful!" });
    } catch (error) {
        res.status(500).json({ message: "Server Error", error: error.message });
    }
};

// get user profile
export const getUserProfile = (req, res) => {
    res.status(200).json(req.user);
};

// update profile
export const updateProfile = async (req, res) => {
    const { name, phone } = req.body;
    const user = await User.findById(req.user._id);

    if (!user) return res.status(404).json({ message: 'User not found' });

    user.name = name || user.name;
    user.phone = phone || user.phone;

    await user.save();

    res.status(200).json({ message: 'Profile updated successfully', user });
};

// change password from profile change password page
export const changePassword = async (req, res) => {
    const { currentPassword, newPassword } = req.body;
    const user = await User.findById(req.user._id).select('+password');

    if (!(await user.comparePassword(currentPassword))) {
        return res.status(400).json({ message: 'Current password is incorrect' });
    }

    user.password = newPassword;
    await user.save();

    res.status(200).json({ message: 'Password changed successfully' });
};

// Logout user
export const logoutUser = (req, res) => {
    res.cookie('token', '', {
        httpOnly: true,
        expires: new Date(0), // Set expiry to a past date
    });
    res.status(200).json({ message: 'Logged out successfully' });
};