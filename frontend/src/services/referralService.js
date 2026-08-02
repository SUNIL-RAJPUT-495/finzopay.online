import api from "../utils/axios";

// Get all referrals
export const getReferrals = () => {
    return api.get("/system/referral");
};

// Add referral
export const addReferral = (data) => {
    return api.post("/system/referral", data);
};

// Update referral status
export const updateReferralStatus = (id, status) => {
    return api.patch(`/system/referral/${id}`, { status });
};

// Delete referral
export const deleteReferral = (id) => {
    return api.delete(`/system/referral/${id}`);
};
