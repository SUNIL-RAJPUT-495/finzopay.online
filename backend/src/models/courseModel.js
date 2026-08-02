import mongoose from "mongoose";

const courseSchema = new mongoose.Schema(
    {
        title: {
            type: String,
            required: true,
            trim: true
        },

        video_link: {
            type: String,
            required: true
        },

        type: {
            type: String,
            enum: ["purchase", "selling", "security"],
            required: true
        },

        status: {
            type: String,
            enum: ["active", "inactive"],
            default: "active"
        }
    },
    { timestamps: true }
);

export default mongoose.model("Course", courseSchema);
