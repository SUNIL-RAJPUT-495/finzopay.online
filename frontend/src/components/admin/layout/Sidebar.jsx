import { Layout, Menu, message } from "antd"
import {
    DashboardOutlined,
    UserOutlined,
    TransactionOutlined,
    SettingOutlined,
    PlaySquareOutlined,
    LogoutOutlined,
    PicCenterOutlined,
    NotificationFilled,
} from "@ant-design/icons"
import { useNavigate, useLocation } from "react-router-dom"
import { adminLogout } from "../../../services/authService"

const { Sider } = Layout

export default function AdminSidebar() {
    const navigate = useNavigate()
    const location = useLocation()

    const selectedKey = location.pathname.split("/")[2] || "dashboard"

    const handleLogout = async () => {
        try {
            await adminLogout();
            message.success("Logged out successfully");
            navigate("/system/login");
        } catch (err) {
            message.error(err.message || "Logout failed");
        }
    };

    return (
        <Sider
            width={250}
            theme="light"
            className="min-h-screen bg-white border-r border-gray-100"
        >
            {/* Logo */}
            <div className="h-16 flex items-center justify-center border-b border-gray-100">
                <div className="flex items-center gap-2">
                    <div className="w-9 h-9 rounded-lg bg-[--color-brand] text-white flex items-center justify-center font-bold">
                        F
                    </div>
                    <span className="text-lg font-semibold text-gray-800">
                        FinzoPay
                    </span>
                </div>
            </div>

            {/* Menu */}
            <Menu
                mode="inline"
                selectedKeys={[selectedKey]}
                className=" border-r-0 px-2 pt-4 admin-menu "
                onClick={({ key }) => navigate(`/system/${key}`)}
                items={[
                    {
                        key: "dashboard",
                        icon: <DashboardOutlined />,
                        label: "Dashboard",
                    },
                    {
                        key: "banners",
                        icon: <PicCenterOutlined />,
                        label: "Banners",
                    },
                    {
                        key: "rp-plans",
                        icon: <PlaySquareOutlined />,
                        label: "Plans",
                    },
                    {
                        key: "rp-buy-request",
                        icon: <PlaySquareOutlined />,
                        label: "Buy Requests",
                    },
                    {
                        key: "rp-sell-request",
                        icon: <PlaySquareOutlined />,
                        label: "Sell Requests",
                    },
                    {
                        key: "referral",
                        icon: <PlaySquareOutlined />,
                        label: "Referral",
                    },
                    {
                        key: "support",
                        icon: <PlaySquareOutlined />,
                        label: "Support",
                    },
                    {
                        key: "users",
                        icon: <UserOutlined />,
                        label: "Users",
                    },
                    {
                        key: "courses",
                        icon: <TransactionOutlined />,
                        label: "Courses",
                    },
                    // {
                    //     key: "notification",
                    //     icon: <NotificationFilled />,
                    //     label: "Send Notification",
                    // },
                    {
                        key: "social-media",
                        icon: <UserOutlined />,
                        label: "Social Media",
                    },
                    // {
                    //     key: "transactions",
                    //     icon: <TransactionOutlined />,
                    //     label: "Transactions",
                    // },
                    {
                        key: "profile",
                        icon: <SettingOutlined />,
                        label: "Settings",
                    },
                    {
                        type: "divider",
                    },
                    {
                        key: "logout",
                        icon: <LogoutOutlined />,
                        label: "Logout",
                        onClick: handleLogout,
                        danger: true,
                    },
                ]}
            />
        </Sider>
    )
}
