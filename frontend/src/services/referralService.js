import api from "../utils/axios";

// Get all referrals
export const getReferrals = () => {
    return api.get("/admin/referral");
};

// Add referral
export const addReferral = (data) => {
    return api.post("/admin/referral", data);
};

// Update referral status
export const updateReferralStatus = (id, status) => {
    return api.patch(`/admin/referral/${id}`, { status });
};

// Delete referral
export const deleteReferral = (id) => {
    return api.delete(`/admin/referral/${id}`);
};
