import api from "../utils/axios";


// Get all users
export const allUsers = (search = "") => {
    return api.get("/system/users", {
        params: { search },
    });
};

// Get Users Details
export const userDetails = (userId) => {
    return api.get(`/system/users/${userId}`);
};

// ✅ TOGGLE USER BLOCK / UNBLOCK
export const toggleUserBlock = (userId) => {
    return api.put(`/system/users/toggle-block/${userId}`);
};