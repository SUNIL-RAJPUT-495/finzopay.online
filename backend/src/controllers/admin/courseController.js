import Course from "../../models/courseModel.js";


/**
 * ADD COURSE
 */
export const addCourse = async (req, res) => {
    try {
        const { title, video_link, type } = req.body;

        if (!title || !video_link || !type) {
            return res.status(400).json({
                success: false,
                message: "All fields are required"
            });
        }

        const course = await Course.create({
            title,
            video_link,
            type
        });

        res.status(201).json({
            success: true,
            message: "Course added successfully",
            data: course
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};

/**
 * GET ALL COURSES (ADMIN)
 */
export const getAllCourses = async (req, res) => {
    try {
        const courses = await Course.find().sort({ createdAt: -1 });

        res.json({
            success: true,
            data: courses
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};

/**
 * UPDATE COURSE
 */
export const updateCourse = async (req, res) => {
    try {
        const { id } = req.params;

        const course = await Course.findByIdAndUpdate(
            id,
            req.body,
            { new: true }
        );

        if (!course) {
            return res.status(404).json({
                success: false,
                message: "Course not found"
            });
        }

        res.json({
            success: true,
            message: "Course updated successfully",
            data: course
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};

/**
 * TOGGLE COURSE STATUS
 */
export const toggleCourseStatus = async (req, res) => {
    try {
        const { id } = req.params;

        const course = await Course.findById(id);
        if (!course) {
            return res.status(404).json({
                success: false,
                message: "Course not found"
            });
        }

        course.status = course.status === "active" ? "inactive" : "active";
        await course.save();

        res.json({
            success: true,
            message: "Course status updated",
            status: course.status
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};
