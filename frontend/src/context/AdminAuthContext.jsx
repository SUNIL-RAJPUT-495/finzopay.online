import React, { createContext, useContext, useState, useEffect } from "react";
import { getAdminProfile, adminLogout } from "../services/authService";
import { Outlet } from "react-router-dom";

const AdminAuthContext = createContext(null);

export const AdminAuthProvider = ({ children }) => {
    const [admin, setAdmin] = useState(null);
    const [loading, setLoading] = useState(true);

    const checkAuth = async () => {
        try {
            const res = await getAdminProfile();
            if (res?.success && res?.data) {
                setAdmin(res.data);
            } else {
                setAdmin(null);
            }
        } catch (err) {
            setAdmin(null);
        } finally {
            setLoading(false);
        }
    };

    const logout = async () => {
        try {
            await adminLogout();
        } catch (err) {
            console.error("Logout error:", err);
        } finally {
            // Clear local session state regardless of backend response
            setAdmin(null);
        }
    };

    useEffect(() => {
        checkAuth();
    }, []);

    return (
        <AdminAuthContext.Provider value={{ admin, loading, checkAuth, logout, isAuthenticated: !!admin }}>
            {children || <Outlet />}
        </AdminAuthContext.Provider>
    );
};

export const useAdminAuth = () => {
    const context = useContext(AdminAuthContext);
    if (!context) {
        throw new Error("useAdminAuth must be used within an AdminAuthProvider");
    }
    return context;
};
