import jwt from 'jsonwebtoken';
import User from '../models/userModel.js';
import Admin from '../models/adminModel.js';

// Middleware to protect routes
export const authentication = async (req, res, next) => {
    let token;

    token = req.cookies.token;

    if (token) {
        try {
            const decoded = jwt.verify(token, process.env.JWT_SECRET);
            // ✅ First try Admin
            let admin = await Admin.findById(decoded.id).select('-password');

            if (admin) {
                req.admin = admin;
                req.role = "admin";
                return next();
            }

            // ✅ Then try User
            let user = await User.findById(decoded.id).select('-password');

            if (user) {
                req.user = user;
                req.role = "user";
                return next();
            }

            next();

        } catch (error) {
            console.error(error);
            res.status(401).json({ message: 'Not authorized, token failed' });
        }
    } else {
        res.status(401).json({ message: 'Not authorized, no token' });
    }
};

// Middleware to authorize roles (e.g., 'admin')
export const authorizeRoles = (...roles) => {
    return (req, res, next) => {
        const role = req.admin?.role || req.user?.role;

        if (!roles.includes(role)) {
            return res.status(403).json({
                message: `Role: ${role} is not authorized`
            });
        }

        next();
    };
};