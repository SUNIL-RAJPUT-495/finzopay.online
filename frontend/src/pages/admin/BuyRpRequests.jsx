import { useEffect, useState } from "react"
import {
    Table,
    Button,
    Tag,
    Skeleton,
    message,
    Tabs
} from "antd"
import { EyeOutlined } from "@ant-design/icons"
import { getBuyRequests } from "../../services/rpService"
import BuyRpActionModal from "../../components/admin/rp-plan/BuyRpActionModal"


export default function BuyRpRequests() {
    const [open, setOpen] = useState(false)
    const [selected, setSelected] = useState(null)
    const [data, setData] = useState([])
    const [loading, setLoading] = useState(true)
    const [activeTab, setActiveTab] = useState("pending")

    // 🔹 Fetch requests based on tab
    const fetchRequests = async (status) => {
        try {
            setLoading(true)

            const res = await getBuyRequests(status)

            const formatted = res.data.map((item) => ({
                key: item._id,
                _id: item._id,
                user: item.userId?.name || "N/A",
                phone: item.userId?.phone || "N/A",
                amount: item.amount_paid,
                payment_id: item.payment_id,
                status: item.status,
                date: new Date(item.createdAt).toLocaleDateString(),
            }))

            setData(formatted)
        } catch (err) {
            message.error(err.message || "Failed to load requests")
        } finally {
            setLoading(false)
        }
    }

    useEffect(() => {
        fetchRequests(activeTab)
    }, [activeTab])

    // 🔹 Table Columns
    const columns = [
        {
            title: "User",
            dataIndex: "user",
            render: (text) => (
                <span className="font-medium text-[--color-brand-dark]">
                    {text}
                </span>
            ),
        },
        {
            title: "Mobile No",
            dataIndex: "phone",
        },
        {
            title: "Amount (₹)",
            dataIndex: "amount",
        },
        {
            title: "Payment ID",
            dataIndex: "payment_id",
        },
        {
            title: "Status",
            dataIndex: "status",
            render: (status) => {
                let color = "default"

                if (status === "pending") color = "orange"
                if (status === "success") color = "green"
                if (status === "failed") color = "red"

                return <Tag color={color}>{status.toUpperCase()}</Tag>
            },
        },
        {
            title: "Requested On",
            dataIndex: "date",
        },
        {
            title: "Action",
            render: (_, record) => (
                <Button
                    icon={<EyeOutlined />}
                    onClick={() => {
                        setSelected(record)
                        setOpen(true)
                    }}
                >
                    View
                </Button>
            ),
        },
    ]

    return (
        <>
            {/* ================= HEADER ================= */}
            <div className="flex justify-between items-center mb-6">
                <div>
                    <h2 className="text-2xl font-bold text-[--color-brand-dark]">
                        Buy RP Requests
                    </h2>
                    <p className="text-sm text-[rgba(30,136,201,0.65)]">
                        Review and verify buy RP requests
                    </p>
                </div>
            </div>

            {/* ================= TABS ================= */}
            <Tabs
                activeKey={activeTab}
                onChange={(key) => setActiveTab(key)}
                className="mb-4"
                items={[
                    { label: "Pending", key: "pending" },
                    { label: "Success", key: "success" },
                    { label: "Failed", key: "failed" },
                ]}
            />

            {/* ================= TABLE ================= */}
            <div className="bg-white rounded-xl shadow-sm p-2">
                {loading ? (
                    <Skeleton active paragraph={{ rows: 6 }} />
                ) : (
                    <Table
                        columns={columns}
                        dataSource={data}
                        pagination={{ pageSize: 10 }}
                    />
                )}
            </div>

            {/* ================= MODAL ================= */}
            <BuyRpActionModal
                open={open}
                onClose={() => setOpen(false)}
                data={selected}
                onSuccess={() => {
                    setOpen(false)
                    fetchRequests(activeTab)
                }}
            />
        </>
    )
}