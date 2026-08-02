import api from "../utils/axios";

// Get all courses (admin)
export const getAllCourses = () => {
    return api.get("/system/course/list");
};

// Add new course
export const addCourse = (data) => {
    return api.post("/system/course/add", data);
};

// Update course
export const updateCourse = (id, data) => {
    return api.put(`/system/course/update/${id}`, data);
};

// Update course status (active / inactive)
export const updateCourseStatus = (id) => {
    return api.put(`/system/course/status/${id}`);
};

// Delete course
export const deleteCourse = (id) => {
    return api.delete(`/system/course/delete/${id}`);
};
