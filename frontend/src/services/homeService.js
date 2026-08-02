import api from "../utils/axios";

// Get all banners
export const getHomeData = () => {
    return api.get("/system/dashboard");
};