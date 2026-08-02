import api from "../utils/axios";


export const adminLogin = (data) => {
    return api.post("/admin/login", data);
};

export const adminSignup = (data) => {
    return api.post("/admin/signup", data);
};

export const getAdminProfile = () => {
    return api.get("/admin/profile");
};

export const updateAdminProfile = (data) => {
    return api.put("/admin/update", data, {
        headers: {
            "Content-Type": "multipart/form-data"
        }
    });
};

export const adminLogout = () => {
    return api.post("/admin/logout");
};
