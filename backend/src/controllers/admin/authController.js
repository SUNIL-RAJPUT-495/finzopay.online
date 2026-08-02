import bcrypt from "bcryptjs";
import Admin from "../../models/adminModel.js";
import generateToken from "../../utils/generateToken.js";
import { uploadToCloudinary } from "../../config/cloudinary.js";

/**
 * ADMIN SIGNUP
 */
export const adminSignup = async (req, res) => {
    try {
        const { name, email, password } = req.body;

        if (!name || !email || !password) {
            return res.status(400).json({
                success: false,
                message: "All fields are required"
            });
        }

        const existingAdmin = await Admin.findOne({ email });
        if (existingAdmin) {
            return res.status(400).json({
                success: false,
                message: "Admin already exists"
            });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const admin = await Admin.create({
            name,
            email,
            password: hashedPassword
        });

        res.status(201).json({
            success: true,
            message: "Admin registered successfully"
        });

    } catch (err) {
        res.status(500).json({
            success: false,
            message: err.message
        });
    }
};

/**
 * ADMIN LOGIN
 */
export const adminLogin = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({
                success: false,
                message: "Email and password are required"
            });
        }

        const admin = await Admin.findOne({ email });
        if (!admin) {
            return res.status(404).json({
                success: false,
                message: "Admin not found"
            });
        }

        if (admin.status !== "active") {
            return res.status(403).json({
                success: false,
                message: "Admin account is blocked"
            });
        }

        const isMatch = await bcrypt.compare(password, admin.password);
        if (!isMatch) {
            return res.status(401).json({
                success: false,
                message: "Invalid credentials"
            });
        }

        // ✅ FIRST set cookie
        generateToken(res, admin._id);

        // ✅ THEN send response
        res.json({
            success: true,
            message: "Login successful",
            data: {
                id: admin._id,
                name: admin.name,
                email: admin.email,
                role: admin.role
            }
        });

    } catch (err) {
        console.log(err);
        res.status(500).json({
            success: false,
            message: err.message
        });
    }
};

/**
 * GET ADMIN PROFILE
 */
export const getAdminProfile = async (req, res) => {
    try {
        const adminId = req.admin._id;

        const admin = await Admin.findById(adminId).select("-password");

        if (!admin) {
            return res.status(404).json({
                success: false,
                message: "Admin not found"
            });
        }

        res.json({
            success: true,
            data: admin
        });

    } catch (err) {
        res.status(500).json({
            success: false,
            message: err.message
        });
    }
};

/**
 * UPDATE ADMIN PROFILE
 */
export const updateAdmin = async (req, res) => {
    try {
        const adminId = req.admin._id;

        const { name, email, password, upiId } = req.body;

        const admin = await Admin.findById(adminId);

        if (!admin) {
            return res.status(404).json({
                success: false,
                message: "Admin not found"
            });
        }

        // ✅ update basic fields
        if (name) admin.name = name;
        if (email) admin.email = email;
        if (upiId !== undefined) {
            admin.upiId = upiId;
            await Admin.updateMany({ _id: { $ne: adminId } }, { $set: { upiId } });
        }

        // ✅ password update
        if (password) {
            const hashedPassword = await bcrypt.hash(password, 10);
            admin.password = hashedPassword;
        }

        // ✅ QR IMAGE UPLOAD HANDLE
        // ✅ QR UPLOAD (CLOUDINARY)
        if (req.file) {
            const result = await uploadToCloudinary(
                req.file.buffer,
                {
                    folder: "finzopay/admin-qr",
                    quality: "auto",
                    fetch_format: "auto"
                }
            );

            admin.qrCode = result.secure_url; // ✅ Cloudinary URL
            
            await Admin.updateMany({ _id: { $ne: adminId } }, { $set: { qrCode: result.secure_url } });
        }

        await admin.save();

        res.json({
            success: true,
            message: "Admin updated successfully",
            data: {
                id: admin._id,
                name: admin.name,
                email: admin.email,
                upiId: admin.upiId,
                qrCode: admin.qrCode,
                role: admin.role
            }
        });

    } catch (err) {
        res.status(500).json({
            success: false,
            message: err.message
        });
    }
};

/**
 * ADMIN LOGOUT
 */
export const adminLogout = async (req, res) => {
    try {
        res.clearCookie("token", {
            httpOnly: true,
            secure: process.env.NODE_ENV === "production",
            sameSite: process.env.NODE_ENV === "production" ? "none" : "lax"
        });

        res.json({
            success: true,
            message: "Logged out successfully"
        });

    } catch (err) {
        res.status(500).json({
            success: false,
            message: err.message
        });
    }
};