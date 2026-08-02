import Course from "../../models/courseModel.js";

/**
 * GET COURSES FOR USER (BY TYPE)
 */
export const getCoursesForUser = async (req, res) => {
    try {
        const { type } = req.query;

        const filter = {
            status: "active"
        };

        if (type) {
            filter.type = type;
        }

        const courses = await Course.find(filter).sort({ createdAt: -1 });

        res.json({
            success: true,
            data: courses
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};
