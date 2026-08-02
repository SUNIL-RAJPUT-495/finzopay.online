import { Layout } from "antd"

const { Footer } = Layout

export default function AdminFooter() {
    return (
        <Footer className="text-center text-gray-400 text-sm bg-transparent">
            © {new Date().getFullYear()} FinzoPay Admin Panel
        </Footer>
    )
}
