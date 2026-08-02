import { useEffect, useState } from "react"
import {
    Button,
    Table,
    Switch,
    Space,
    Tag,
    Skeleton,
    message,
} from "antd"
import { PlusOutlined, EditOutlined } from "@ant-design/icons"
import RpPlanModal from "../../components/admin/rp-plan/RpPlanModal"
import { getRPPlans, updateRPPlan } from "../../services/rpService"

export default function RpPlans() {
    const [open, setOpen] = useState(false)
    const [editData, setEditData] = useState(null)
    const [data, setData] = useState([])
    const [loading, setLoading] = useState(true)

    // 🔹 Load RP Plans
    const fetchPlans = async () => {
        try {
            setLoading(true)
            const res = await getRPPlans()
            setData(
                res.data.map((item) => ({
                    ...item,
                    key: item._id,
                }))
            )
        } catch (err) {
            message.error(err.message || "Failed to load RP plans")
        } finally {
            setLoading(false)
        }
    }

    useEffect(() => {
        fetchPlans()
    }, [])

    // 🔹 Toggle Status
    const toggleStatus = async (record) => {
        try {
            await updateRPPlan(record._id, {
                status: !record.status,
            })
            message.success("Status updated")
            fetchPlans()
        } catch (err) {
            message.error("Failed to update status")
        }
    }

    const columns = [
        {
            title: "Plan",
            dataIndex: "title",
            render: (text) => (
                <span className="font-medium text-[--color-brand-dark]">
                    {text} RP
                </span>
            ),
        },
        {
            title: "RP Amount",
            dataIndex: "rp_amount",
        },
        {
            title: "Price (₹)",
            dataIndex: "price",
        },
        {
            title: "Commission %",
            dataIndex: "commission_percent",
            render: (value) => <Tag color="blue">{value}%</Tag>,
        },
        {
            title: "Status",
            dataIndex: "status",
            render: (_, record) => (
                <Switch
                    checked={record.status}
                    onChange={() => toggleStatus(record)}
                />
            ),
        },
        {
            title: "Actions",
            render: (_, record) => (
                <Space>
                    <Button
                        icon={<EditOutlined />}
                        onClick={() => {
                            setEditData(record)
                            setOpen(true)
                        }}
                    />
                </Space>
            ),
        },
    ]

    return (
        <>
            {/* Header */}
            <div className="flex items-center justify-between mb-6">
                <div>
                    <h2 className="text-2xl font-bold text-[--color-brand-dark]">
                        RP Plans
                    </h2>
                    <p className="text-sm text-[rgba(30,136,201,0.65)]">
                        Manage RP purchase plans
                    </p>
                </div>

                <Button
                    type="primary"
                    icon={<PlusOutlined />}
                    style={{ backgroundColor: "var(--color-brand)" }}
                    onClick={() => {
                        setEditData(null)
                        setOpen(true)
                    }}
                >
                    Add New Plan
                </Button>
            </div>

            {/* Table */}
            <div className="bg-white rounded-xl shadow-sm p-2">
                {loading ? (
                    <Skeleton
                        active
                        paragraph={{ rows: 6 }}
                        title={{ width: "30%" }}
                    />
                ) : (
                    <Table
                        columns={columns}
                        dataSource={data}
                        pagination={false}
                    />
                )}
            </div>

            {/* Modal */}
            <RpPlanModal
                open={open}
                onClose={() => setOpen(false)}
                editData={editData}
                onSuccess={fetchPlans}
            />
        </>
    )
}
