import mongoose from "mongoose";

const adminSchema = new mongoose.Schema(
    {
        name: {
            type: String,
            required: true
        },

        email: {
            type: String,
            required: true,
            unique: true
        },

        password: {
            type: String,
            required: true
        },

        // ✅ NEW FIELD: UPI ID
        upiId: {
            type: String,
            trim: true,
            default: ""
        },

        // ✅ NEW FIELD: QR CODE (image URL / path)
        qrCode: {
            type: String,
            trim: true,
            default: ""
        },

        role: {
            type: String,
            enum: ["admin", "super_admin"],
            default: "admin"
        },

        status: {
            type: String,
            enum: ["active", "blocked"],
            default: "active"
        }
    },
    { timestamps: true }
);

export default mongoose.model("Admin", adminSchema);
