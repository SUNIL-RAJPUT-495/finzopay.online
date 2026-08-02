import dotenv from 'dotenv';
import app from './src/app.js';
import connectDatabase from './src/config/database.js';

dotenv.config({ path: 'config.env' });
// Load environment variables

// Connect to the database
connectDatabase();

const PORT = process.env.PORT || 5000;

app.get("/", (req, res) => {
    res.send("Node App Live 🚀 (ESM)");
});

app.get("/api/test2", (req, res) => {
    res.json({ message: "API Working with ESM" });
});

app.listen(PORT, () => {
    console.log(`🚀 Server is running on http://localhost:${PORT}`);
});