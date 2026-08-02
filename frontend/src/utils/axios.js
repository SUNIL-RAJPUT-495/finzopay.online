import axios from "axios";

const api = axios.create({
    baseURL: "http://localhost:8000/api/v1",
    // baseURL: "https://api.finzopay.online/api/v1",
    withCredentials: true,
    headers: {
        "Content-Type": "application/json"
    }
});

/* =========================
   RESPONSE INTERCEPTOR
========================= */
api.interceptors.response.use(
    (response) => response.data,
    (error) => {
        if (
            error.response?.status === 401 &&
            window.location.pathname.startsWith("/system") &&
            window.location.pathname !== "/system/login"
        ) {
            window.location.href = "/system/login";
        }
        return Promise.reject(error.response?.data || error.message);
    }
);

export default api;
