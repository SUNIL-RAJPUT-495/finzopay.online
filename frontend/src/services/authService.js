import api from "../utils/axios";


export const adminLogin = (data) => {
    return api.post("/system/login", data);
};

export const adminSignup = (data) => {
    return api.post("/system/signup", data);
};

export const getAdminProfile = () => {
    return api.get("/system/profile");
};

export const updateAdminProfile = (data) => {
    return api.put("/system/update", data, {
        headers: {
            "Content-Type": "multipart/form-data"
        }
    });
};

export const adminLogout = () => {
    return api.post("/system/logout");
};
