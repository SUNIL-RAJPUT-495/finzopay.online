import api from "../utils/axios";

// Get all courses (admin)
export const getAllCourses = () => {
    return api.get("/admin/course/list");
};

// Add new course
export const addCourse = (data) => {
    return api.post("/admin/course/add", data);
};

// Update course
export const updateCourse = (id, data) => {
    return api.put(`/admin/course/update/${id}`, data);
};

// Update course status (active / inactive)
export const updateCourseStatus = (id) => {
    return api.put(`/admin/course/status/${id}`);
};

// Delete course
export const deleteCourse = (id) => {
    return api.delete(`/admin/course/delete/${id}`);
};
