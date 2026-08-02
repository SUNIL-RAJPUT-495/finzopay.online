import api from "../utils/axios";

// Get all banners
export const getBanners = () => {
    return api.get("/admin/banners");
};

// Add banner
export const addBanner = (data) => {
    return api.post("/admin/banners", data, {
        headers: {
            "Content-Type": "multipart/form-data",
        },
    });
};

// Delete banner
export const deleteBanner = (id) => {
    return api.delete(`/admin/banners/${id}`);
};
