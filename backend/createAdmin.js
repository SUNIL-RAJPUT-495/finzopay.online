import dotenv from "dotenv";
import mongoose from "mongoose";
import bcrypt from "bcryptjs";
import connectDatabase from "./src/config/database.js";
import Admin from "./src/models/adminModel.js";

dotenv.config({ path: "config.env" });

async function createAdminUser() {
    try {
        await connectDatabase();
        
        const email = "admin@gmail.com";
        const password = "admin123";
        const name = "Admin";
        
        const existingAdmin = await Admin.findOne({ email });
        if (existingAdmin) {
            console.log("Admin with email admin@gmail.com already exists. Updating password...");
            const hashedPassword = await bcrypt.hash(password, 10);
            existingAdmin.password = hashedPassword;
            await existingAdmin.save();
            console.log("Password updated successfully!");
        } else {
            const hashedPassword = await bcrypt.hash(password, 10);
            await Admin.create({
                name,
                email,
                password: hashedPassword,
                role: "super_admin"
            });
            console.log("New admin created successfully with email admin@gmail.com!");
        }
        
        await mongoose.connection.close();
        console.log("Database connection closed.");
    } catch (error) {
        console.error("Error creating admin:", error);
    }
}

createAdminUser();
