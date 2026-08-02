import { Layout } from "antd"
import AdminHeader from "./Header"
import AdminSidebar from "./Sidebar"
import AdminFooter from "./Footer"
import { Outlet } from "react-router-dom"

const { Content } = Layout

export default function AdminLayout({ children }) {
    return (
        <Layout className="min-h-screen bg-gray-100">
            <AdminSidebar />

            <Layout className="bg-gray-100">
                <AdminHeader />

                <Content className="m-6 p-6 bg-white rounded-2xl shadow-sm">
                    <Outlet />
                </Content>

                <AdminFooter />
            </Layout>
        </Layout>
    )
}
