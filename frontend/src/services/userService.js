import api from "../utils/axios";


// Get all users
export const allUsers = (search = "") => {
    return api.get("/admin/users", {
        params: { search },
    });
};

// Get Users Details
export const userDetails = (userId) => {
    return api.get(`/admin/users/${userId}`);
};

// ✅ TOGGLE USER BLOCK / UNBLOCK
export const toggleUserBlock = (userId) => {
    return api.put(`/admin/users/toggle-block/${userId}`);
};