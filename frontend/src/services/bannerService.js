import api from "../utils/axios";

// Get all banners
export const getBanners = () => {
    return api.get("/system/banners");
};

// Add banner
export const addBanner = (data) => {
    return api.post("/system/banners", data, {
        headers: {
            "Content-Type": "multipart/form-data",
        },
    });
};

// Delete banner
export const deleteBanner = (id) => {
    return api.delete(`/system/banners/${id}`);
};
