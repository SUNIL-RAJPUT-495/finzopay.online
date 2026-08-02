import mongoose from "mongoose";

const supportSchema = new mongoose.Schema(
    {
        userId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User"
        },

        name: String,
        phone: String,
        email: String,

        message: {
            type: String,
            required: true
        },

        status: {
            type: String,
            enum: ["open", "resolved"],
            default: "open"
        }

    },
    { timestamps: true });

export default mongoose.model("Support", supportSchema);
