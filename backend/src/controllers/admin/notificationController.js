import admin from "../../utils/firebase.js";
import User from "../../models/userModel.js";

/**
 * SEND PUSH NOTIFICATION (ADMIN)
 */
export const sendPushNotification = async (req, res) => {
    try {
        const { title, message } = req.body;

        if (!title || !message) {
            return res.status(400).json({
                success: false,
                message: "Title and message are required"
            });
        }

        // 🔹 Get all users who have device token
        const users = await User.find({
            device_token: { $exists: true, $ne: null }
        }).select("device_token");

        if (!users.length) {
            return res.status(404).json({
                success: false,
                message: "No device tokens found"
            });
        }

        const tokens = users.map(u => u.device_token);

        // 🔹 FCM payload
        const payload = {
            notification: {
                title,
                body: message
            },
            data: {
                click_action: "FLUTTER_NOTIFICATION_CLICK"
            }
        };

        // 🔹 Send notification
        const response = await admin.messaging().sendEachForMulticast({
            tokens,
            ...payload
        });

        res.json({
            success: true,
            message: "Push notification sent successfully",
            successCount: response.successCount,
            failureCount: response.failureCount
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({
            success: false,
            message: err.message
        });
    }
};
