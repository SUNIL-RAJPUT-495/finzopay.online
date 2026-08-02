import { Layout, Dropdown, Avatar, message } from "antd";
import { UserOutlined, LogoutOutlined } from "@ant-design/icons";
import { useNavigate } from "react-router-dom";
import { adminLogout } from "../../../services/authService";

const { Header } = Layout;

export default function AdminHeader() {
    const navigate = useNavigate();

    const handleLogout = async () => {
        try {
            await adminLogout();
            message.success("Logged out successfully");
            navigate("/system/login");
        } catch (err) {
            message.error(err.message || "Logout failed");
        }
    };

    const items = [
        {
            key: "logout",
            icon: <LogoutOutlined />,
            label: "Logout",
            onClick: handleLogout,
        },
    ];

    return (
        <Header
            style={{
                background: "#ffffff",
                padding: "0 24px",
                height: "64px",
                borderBottom: "1px solid rgba(59,181,242,0.15)",
            }}
            className="flex items-center justify-between"
        >
            {/* Left */}
            <h1 className="text-lg font-semibold text-[--color-brand-dark] tracking-tight">
                Admin Dashboard
            </h1>

            {/* Right */}
            <Dropdown menu={{ items }} placement="bottomRight" trigger={["click"]}>
                <div
                    className="
            flex items-center gap-3
            px-3 py-2
            rounded-xl cursor-pointer
            hover:bg-[rgba(59,181,242,0.06)]
            transition
          "
                >
                    <Avatar
                        size={36}
                        style={{ backgroundColor: "var(--color-brand)" }}
                        icon={<UserOutlined />}
                    />

                    <div className="hidden sm:flex flex-col leading-tight">
                        <span className="text-sm font-medium text-[--color-brand-dark]">
                            Admin
                        </span>
                        <span className="text-xs text-[rgba(30,136,201,0.65)]">
                            Super Admin
                        </span>
                    </div>
                </div>
            </Dropdown>
        </Header>
    );
}
