import jwt from 'jsonwebtoken';

const generateToken = (res, userId) => {
    // Create the token with the user's ID as the payload
    const token = jwt.sign({ id: userId }, process.env.JWT_SECRET, {
        expiresIn: process.env.JWT_EXPIRE,
    });

    // Set the token in an HTTP-Only cookie for security
    res.cookie('token', token, {
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production', 
        sameSite: process.env.NODE_ENV === 'production' ? 'none' : 'lax',
        maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
    });
};

export default generateToken;