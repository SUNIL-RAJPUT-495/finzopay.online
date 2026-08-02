import api from "../utils/axios";

export const sendPushNotification = (data) => {
    return api.post("/system/notification/send", data);
};
