import mongoose from "mongoose";
import bcrypt from "bcryptjs";

const deviceSchema = new mongoose.Schema(
    {
        deviceId: { type: String, default: "" },
        deviceToken: { type: String, default: "" },
        deviceType: {
            type: String,
            enum: ["android", "ios", "web"],
            default: "android",
        },
    },
    { _id: false }
);

const userSchema = new mongoose.Schema(
    {
        name: { type: String, trim: true, default: "" },

        email: {
            type: String,
            lowercase: true,
            trim: true,
        },

        phone: { type: String, trim: true, default: "" },

        password: {
            type: String,
            required: true,
            minlength: 6,
            select: false,
        },

        role: {
            type: String,
            enum: ["user", "admin"],
            default: "user",
        },

        avatar: { type: String, default: "" },

        /* -------- Invite System -------- */
        inviteCode: {
            type: String,
        },

        invitedBy: {
            type: String,
            default: null,
        },

        /* -------- Status -------- */
        isVerified: { type: Boolean, default: false },
        isBlocked: { type: Boolean, default: false },

        /* -------- OTP -------- */
        otp: String,
        otpExpire: Date,

        /* -------- Devices -------- */
        devices: [deviceSchema],

        /* -------- Password Reset -------- */
        resetPasswordToken: String,
        resetPasswordExpire: Date,
    },
    { timestamps: true }
);

/* =======================
   Pre Save Middleware
======================= */
userSchema.pre("save", async function () {
    // generate invite code
    if (!this.inviteCode) {
        this.inviteCode = `INV-${Math.random()
            .toString(36)
            .substring(2, 8)
            .toUpperCase()}`;
    }

    // hash password
    if (!this.isModified("password")) return;
    this.password = await bcrypt.hash(this.password, 10);
});

/* =======================
   Compare Password
======================= */
userSchema.methods.comparePassword = function (enteredPassword) {
    return bcrypt.compare(enteredPassword, this.password);
};


userSchema.index({ name: 1, phone: 1, email: 1 });

const User = mongoose.model("User", userSchema);
export default User;
