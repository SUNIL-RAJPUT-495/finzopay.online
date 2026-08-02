import jwt from 'jsonwebtoken';

// This one returns the token instead of setting cookies
const generateMobileToken = (userId) => {
  return jwt.sign({ id: userId }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE || '30d',
  });
};

export default generateMobileToken;
