import api from "../utils/axios";

// GET social links
export const getSocialLinks = () => {
    return api.get("/system/social-links");
};

// UPDATE social links
export const updateSocialLinks = (data) => {
    return api.post("/system/social-links", data);
};
