import api from "../utils/axios";

// GET social links
export const getSocialLinks = () => {
    return api.get("/admin/social-links");
};

// UPDATE social links
export const updateSocialLinks = (data) => {
    return api.post("/admin/social-links", data);
};
