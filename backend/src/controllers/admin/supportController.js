import Support from "../../models/supportModel.js";

/**
 * =========================
 * GET ALL SUPPORT QUERIES
 * =========================
 * Admin only
 */
export const getAllSupport = async (req, res) => {
    try {
        const supports = await Support.find()
            .sort({ createdAt: -1 })
            .populate("userId", "name phone email");

        res.json({
            success: true,
            data: supports,
        });
    } catch (err) {
        res.status(500).json({
            success: false,
            message: err.message,
        });
    }
};

/**
 * =========================
 * UPDATE SUPPORT STATUS
 * =========================
 * Admin only
 */
export const updateSupportStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const { status } = req.body;

        const allowedStatus = ["open", "resolved"];

        if (!allowedStatus.includes(status)) {
            return res.status(400).json({
                success: false,
                message: "Invalid status value",
            });
        }

        const support = await Support.findById(id);
        if (!support) {
            return res.status(404).json({
                success: false,
                message: "Support query not found",
            });
        }

        support.status = status;
        await support.save();

        res.json({
            success: true,
            message: "Status updated successfully",
        });
    } catch (err) {
        res.status(500).json({
            success: false,
            message: err.message,
        });
    }
};

/**
 * =========================
 * DELETE SUPPORT QUERY
 * =========================
 * Admin only
 */
export const deleteSupport = async (req, res) => {
    try {
        const { id } = req.params;

        const support = await Support.findById(id);
        if (!support) {
            return res.status(404).json({
                success: false,
                message: "Support query not found",
            });
        }

        await support.deleteOne();

        res.json({
            success: true,
            message: "Support query deleted",
        });
    } catch (err) {
        res.status(500).json({
            success: false,
            message: err.message,
        });
    }
};
