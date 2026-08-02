import { Button, Form, Input, Card, Typography, message, Spin } from "antd";
import { UserOutlined, LockOutlined } from "@ant-design/icons";
import { useNavigate } from "react-router-dom";
import { adminLogin } from "../../services/authService";
import { useState, useEffect } from "react";
import { useAdminAuth } from "../../context/AdminAuthContext";

const { Title, Text } = Typography;

function AdminLogin() {
    const navigate = useNavigate();
    const [loading, setLoading] = useState(false);
    const { isAuthenticated, loading: authLoading, checkAuth } = useAdminAuth();

    useEffect(() => {
        if (!authLoading && isAuthenticated) {
            navigate("/system/dashboard");
        }
    }, [isAuthenticated, authLoading, navigate]);

    const onFinish = async (values) => {
        try {
            setLoading(true);

            // API CALL
            const res = await adminLogin({
                email: values.username,   // backend expects email
                password: values.password
            });

            message.success("Login successful");

            // Refresh authentication state
            await checkAuth();

            // Cookie already set by backend
            // Just redirect
            navigate("/system/dashboard");

        } catch (err) {
            message.error(err.message || "Login failed");
        } finally {
            setLoading(false);
        }
    };

    if (authLoading) {
        return (
            <div className="min-h-screen flex items-center justify-center bg-gray-100">
                <div className="flex flex-col items-center gap-4 p-8 rounded-2xl bg-white shadow-lg border border-gray-100">
                    <Spin size="large" />
                    <Text type="secondary" className="font-medium animate-pulse">
                        Verifying session...
                    </Text>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen flex items-center justify-center bg-gray-100">
            <Card className="w-full max-w-md shadow-lg" bordered={false}>
                <div className="text-center mb-6">
                    <Title level={3}>Admin Login</Title>
                    <Text type="secondary">Login to FinzoPay Admin Panel</Text>
                </div>

                <Form layout="vertical" onFinish={onFinish}>
                    <Form.Item
                        label="Email"
                        name="username"
                        rules={[{ required: true, message: "Please enter email" }]}
                    >
                        <Input
                            prefix={<UserOutlined />}
                            placeholder="Enter email"
                        />
                    </Form.Item>

                    <Form.Item
                        label="Password"
                        name="password"
                        rules={[{ required: true, message: "Please enter password" }]}
                    >
                        <Input.Password
                            prefix={<LockOutlined />}
                            placeholder="Enter password"
                        />
                    </Form.Item>

                    <Button
                        type="primary"
                        htmlType="submit"
                        block
                        size="large"
                        loading={loading}
                    >
                        Login
                    </Button>
                </Form>
            </Card>
        </div>
    );
}

export default AdminLogin;
