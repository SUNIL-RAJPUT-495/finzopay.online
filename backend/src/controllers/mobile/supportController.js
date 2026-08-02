import Support from "../../models/supportModel.js";

export const createSupport = async (req, res) => {
    try {

        const userId = req.user.id;
        const { name, phone, email, message } = req.body;

        if (!message) {
            return res.status(400).json({ success: false, message: "Message required" });
        }

        await Support.create({
            userId,
            name,
            phone,
            email,
            message
        });

        res.json({
            success: true,
            message: "Query submitted"
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};
