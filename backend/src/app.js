import express from 'express';
import cors from 'cors';
import cookieParser from 'cookie-parser';

import webRoutes from './routes/v1/webRoutes.js';
import adminRoutes from './routes/v1/adminRoutes.js';
import mobileRoutes from './routes/v1/mobileRoutes.js';
import morgan from 'morgan';

const allowedOrigins = [
    "http://localhost:51354",        // Flutter Web
    "http://localhost:3000",         // Optional local
    "https://finzopay.online",
    "https://www.finzopay.online",
    "http://localhost:5173"
];

const app = express();
// --- Core Middleware ---
app.use(cors({ origin: true, credentials: true }));

app.use(cookieParser());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan("dev"));

// --- Routes ---
app.get('/api/test', (req, res) => {
    res.send('Hello from the Backend!');
});

// Razorpay webhook route
// app.post("/api/v1/payments/webhook", express.raw({ type: "application/json" }), (req, res, next) => {
//     next();
// });

// All routes
// app.use('/api/v1/web', webRoutes);
app.use('/api/v1/system', adminRoutes);
app.use('/api/v1/mobile', mobileRoutes);



export default app;