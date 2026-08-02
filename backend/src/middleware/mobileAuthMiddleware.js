import jwt from 'jsonwebtoken';
import User from '../models/userModel.js';

// Protect mobile routes with Bearer token
export const mobileAuth = async (req, res, next) => {
    let token;

    if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
        try {
            token = req.headers.authorization.split(' ')[1];

            const decoded = jwt.verify(token, process.env.JWT_SECRET);

            const user = await User.findById(decoded.id).select('-password');

            if (!user) {
                return res.status(404).json({ message: 'User not found' });
            }

            // ✅ NEW: Block check
            if (user.isBlocked) {
                return res.status(403).json({
                    message: 'Your account is blocked. Please contact support.'
                });
            }

            req.user = user;

            next();
        } catch (error) {
            console.error(error);
            return res.status(401).json({ message: 'Not authorized, invalid token' });
        }
    } else {
        return res.status(401).json({ message: 'Not authorized, no token provided' });
    }
};