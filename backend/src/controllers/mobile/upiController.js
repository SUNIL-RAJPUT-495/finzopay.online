import Admin from "../../models/adminModel.js";

export const getUpiDetails = async (req, res) => {
    try {

        let admin = await Admin.findOne({
            status: "active",
            upiId: { $ne: "", $exists: true }
        }).sort({ updatedAt: -1 }).select("upiId qrCode");

        if (!admin) {
            admin = await Admin.findOne({ status: "active" }).select("upiId qrCode");
        }

        if (!admin) {
            return res.status(404).json({
                message: "Admin not found"
            });
        }

        res.status(200).json({
            message: "UPI Details Fetch Successfully",
            upiId: admin.upiId || "",
            qrImage: admin.qrCode || ""
        });

    } catch (error) {
        console.log(error);
        res.status(500).json({
            message: "Server Error",
            error: error.message
        });
    }
};