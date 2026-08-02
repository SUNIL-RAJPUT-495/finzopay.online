import api from "../utils/axios";

export const sendPushNotification = (data) => {
    return api.post("/admin/notification/send", data);
};
