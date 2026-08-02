import { useEffect, useState } from "react"
import {
    Table,
    Button,
    Tag,
    Input,
    DatePicker,
    InputNumber,
    Skeleton,
    message,
} from "antd"
import { EyeOutlined, SearchOutlined } from "@ant-design/icons"
import SellRpActionModal from "../../components/admin/rp-plan/SellRpActionModal"
import { getPendingSellRequests } from "../../services/rpService"

const { RangePicker } = DatePicker

export default function SellRpRequests() {
    const [open, setOpen] = useState(false)
    const [selected, setSelected] = useState(null)
    const [data, setData] = useState([])
    const [loading, setLoading] = useState(true)

    // 🔹 Fetch pending sell requests
    const fetchSellRequests = async () => {
        try {
            setLoading(true)
            const res = await getPendingSellRequests()

            const formatted = res.data.map((item) => ({
                key: item._id,
                _id: item._id,
                user: item.userId?.name || "N/A",
                phone: item.userId?.phone || "N/A",
                rp_amount: item.rp_amount,
                money_amount: item.money_amount,
                bank: {
                    holder: item.bankAccountId?.account_holder,
                    account: item.bankAccountId?.account_number,
                    ifsc: item.bankAccountId?.ifsc,
                    name: item.bankAccountId?.bank_name,
                },
                status: item.status,
                date: new Date(item.createdAt).toLocaleDateString(),
            }))

            setData(formatted)
        } catch (err) {
            message.error(err.message || "Failed to load sell requests")
        } finally {
            setLoading(false)
        }
    }

    useEffect(() => {
        fetchSellRequests()
    }, [])

    const columns = [
        {
            title: "User",
            dataIndex: "user",
            render: (text) => (
                <span className="font-medium text-[--color-brand-dark]">{text}</span>
            ),
        },
        {
            title: "Mobile No",
            dataIndex: "phone",
        },
        {
            title: "RP",
            dataIndex: "rp_amount",
        },
        {
            title: "Amount (₹)",
            dataIndex: "money_amount",
        },
        {
            title: "Status",
            dataIndex: "status",
            render: (status) => (
                <Tag color={status === "pending" ? "orange" : "green"}>
                    {status.toUpperCase()}
                </Tag>
            ),
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
                        Sell RP Requests
                    </h2>
                    <p className="text-sm text-[rgba(30,136,201,0.65)]">
                        Review and process sell RP requests
                    </p>
                </div>
            </div>

            {/* ================= FILTER BAR ================= */}
            {/* <div className="bg-white rounded-xl shadow-sm p-4 mb-6">
                <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <Input
                        placeholder="Search by user name"
                        prefix={<SearchOutlined />}
                    />
                    <RangePicker className="w-full" />
                    <InputNumber className="w-full" placeholder="Amount (₹)" />
                    <Button
                        type="primary"
                        style={{ backgroundColor: "var(--color-brand)" }}
                    >
                        Apply Filters
                    </Button>
                </div>
            </div> */}

            {/* ================= TABLE ================= */}
            <div className="bg-white rounded-xl shadow-sm p-2">
                {loading ? (
                    <Skeleton active paragraph={{ rows: 6 }} />
                ) : (
                    <Table
                        columns={columns}
                        dataSource={data}
                        pagination={false}
                    />
                )}
            </div>

            {/* ================= MODAL ================= */}
            <SellRpActionModal
                open={open}
                onClose={() => setOpen(false)}
                data={selected}
                onSuccess={() => {
                    setOpen(false)
                    fetchSellRequests()
                }}
            />
        </>
    )
}
