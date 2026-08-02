import api from "../utils/axios";


/**
 * ADD RP PLAN (ADMIN)
 * POST /api/v1/admin/rpplan/add
 */
export const addRPPlan = (data) => {
    return api.post("/system/rpplan/add", data);
};

/**
 * GET ALL RP PLANS (ADMIN)
 * GET /api/v1/admin/rpplan/list
 */
export const getRPPlans = () => {
    return api.get("/system/rpplan/list");
};

/**
 * UPDATE RP PLAN (ADMIN)
 * PUT /api/v1/admin/rpplan/update/:id
 */
export const updateRPPlan = (id, data) => {
    return api.put(`/system/rpplan/update/${id}`, data);
};


/* =========================
   BUY RP (ADMIN)
========================= */

/**
 * GET BUY REQUESTS (BY STATUS)
 * GET /api/v1/admin/buy-requests?status=pending/approved/rejected
 */
export const getBuyRequests = (status) => {
    return api.get(`/system/rpplan/buyed/list?status=${status}`);
};


/**
 * APPROVE BUY REQUEST
 * POST /api/v1/admin/buyrp/approve/:id
 */
export const approveBuyRequest = (id) => {
    return api.post(`/system/rpplan/buyed/verify/${id}`, { status: "success" });
};


/**
 * REJECT BUY REQUEST
 * POST /api/v1/admin/buyrp/reject/:id
 */
export const rejectBuyRequest = (id, data = {}) => {
    // optional: { admin_note: "reason" }
    return api.post(`/system/rpplan/buyed/verify/${id}`, { status: "failed" });
};




/* =========================
   SELL RP (ADMIN)
========================= */

/**
 * GET ALL PENDING SELL REQUESTS
 * GET /api/v1/admin/sellrp/pending
 */
export const getPendingSellRequests = () => {
    return api.get("/system/sellrp/pending");
};

/**
 * MARK SELL REQUEST AS PAID
 * POST /api/v1/admin/sellrp/paid/:id
 */
export const markSellAsPaid = (id) => {
    return api.post(`/system/sellrp/paid/${id}`);
};

/**
 * REJECT SELL REQUEST
 * POST /api/v1/admin/sellrp/reject/:id
 */
export const rejectSellRequest = (id, data = {}) => {
    // data optional: { admin_note: "reason" }
    return api.post(`/system/sellrp/reject/${id}`, data);
};