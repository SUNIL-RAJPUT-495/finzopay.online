import api from "../utils/axios";

/**
 * ============================
 * GET ALL SUPPORT REQUESTS
 * ============================
 * GET /api/v1/admin/support
 */
export const getAllSupport = () => {
    return api.get("/admin/support");
};

/**
 * ============================
 * UPDATE SUPPORT STATUS
 * ============================
 * PUT /api/v1/admin/support/:id/status
 * body: { status: "Pending" | "In Progress" | "Resolved" }
 */
export const updateSupportStatus = (id, status) => {
    return api.put(`/admin/support/${id}/status`, {
        status,
    });
};

/**
 * ============================
 * DELETE SUPPORT REQUEST
 * ============================
 * DELETE /api/v1/admin/support/:id
 */
export const deleteSupport = (id) => {
    return api.delete(`/admin/support/${id}`);
};
