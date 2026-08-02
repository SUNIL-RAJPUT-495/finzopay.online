import React from "react";
import { Navigate, Outlet } from "react-router-dom";
import { useAdminAuth } from "../../context/AdminAuthContext";
import { Spin } from "antd";

export default function ProtectedRoute({ children }) {
    const { isAuthenticated, loading } = useAdminAuth();

    if (loading) {
        return (
            <div className="min-h-screen flex flex-col items-center justify-center bg-gray-50">
                <div className="flex flex-col items-center gap-4 p-8 rounded-2xl bg-white/80 backdrop-blur-md shadow-sm border border-gray-100">
                    <Spin size="large" />
                    <span className="text-gray-500 font-medium text-sm animate-pulse">
                        Verifying admin session...
                    </span>
                </div>
            </div>
        );
    }

    if (!isAuthenticated) {
        return <Navigate to="/system/login" replace />;
    }

    return children ? children : <Outlet />;
}
