import React, { useEffect, useState } from "react"
import {
    Table,
    Button,
    Modal,
    Form,
    DatePicker,
    Input,
    InputNumber,
    Tag,
    Popconfirm,
    message
} from "antd"
import dayjs from "dayjs"

import {
    getReferrals,
    addReferral,
    updateReferralStatus,
    deleteReferral
} from "../../services/referralService"

export default function Referral() {

    const [list, setList] = useState([])
    const [loading, setLoading] = useState(false)
    const [open, setOpen] = useState(false)

    const [form] = Form.useForm()

    // 🔥 Auto generate code
    const generateCode = () => {
        const code = Math.random().toString(36).substring(2, 8).toUpperCase()
        form.setFieldsValue({ code })
    }

    const loadData = async () => {
        try {
            setLoading(true)
            const res = await getReferrals()
            setList(res)
        } catch {
            message.error("Failed to load referrals")
        } finally {
            setLoading(false)
        }
    }

    useEffect(() => {
        loadData()
    }, [])

    const handleAdd = async () => {
        try {
            const values = await form.validateFields()

            await addReferral({
                code: values.code.toUpperCase(),
                validFrom: values.validFrom,
                validTill: values.validTill,
                usageLimit: values.usageLimit
            })

            message.success("Referral created")
            setOpen(false)
            form.resetFields()
            loadData()

        } catch { }
    }

    const toggleStatus = async (row) => {
        await updateReferralStatus(row._id, row.status === "ACTIVE" ? "DISABLED" : "ACTIVE")
        message.success("Status updated")
        loadData()
    }

    const handleDelete = async (id) => {
        await deleteReferral(id)
        message.success("Deleted")
        loadData()
    }

    const getStatus = (r) => {
        if (r.status === "DISABLED") return <Tag color="red">Disabled</Tag>
        if (r.usedCount >= r.usageLimit) return <Tag color="orange">Used Up</Tag>
        if (new Date() > new Date(r.validTill)) return <Tag>Expired</Tag>
        return <Tag color="green">Active</Tag>
    }

    const columns = [
        { title: "Code", dataIndex: "code" },
        {
            title: "Validity",
            render: (_, r) =>
                `${dayjs(r.validFrom).format("DD MMM YYYY")} - ${dayjs(r.validTill).format("DD MMM YYYY")}`
        },
        {
            title: "Usage",
            render: (_, r) => `${r.usedCount}/${r.usageLimit}`
        },
        {
            title: "Status",
            render: (_, r) => getStatus(r)
        },
        {
            title: "Action",
            render: (_, r) => (
                <>
                    <Button size="small" onClick={() => toggleStatus(r)}>
                        {r.status === "ACTIVE" ? "Disable" : "Enable"}
                    </Button>

                    <Popconfirm title="Delete referral?" onConfirm={() => handleDelete(r._id)}>
                        <Button danger size="small" style={{ marginLeft: 8 }}>
                            Delete
                        </Button>
                    </Popconfirm>
                </>
            )
        }
    ]

    return (
        <>
            <Button type="primary" onClick={() => setOpen(true)}>
                Add Referral
            </Button>

            <Table
                rowKey="_id"
                columns={columns}
                dataSource={list}
                loading={loading}
                style={{ marginTop: 20 }}
            />

            <Modal
                title="Add Referral"
                open={open}
                onCancel={() => setOpen(false)}
                onOk={handleAdd}
            >
                <Form form={form} layout="vertical">

                    {/* Referral Code */}
                    <Form.Item
                        label="Referral Code"
                        name="code"
                        rules={[
                            { required: true },
                            { min: 6, message: "Minimum 6 characters" }
                        ]}
                    >
                        <Input
                            placeholder="Enter code"
                            addonAfter={<Button size="small" onClick={generateCode}>Generate</Button>}
                        />
                    </Form.Item>

                    <Form.Item
                        label="Valid From"
                        name="validFrom"
                        rules={[{ required: true }]}
                    >
                        <DatePicker style={{ width: "100%" }} />
                    </Form.Item>

                    <Form.Item
                        label="Valid Till"
                        name="validTill"
                        rules={[{ required: true }]}
                    >
                        <DatePicker style={{ width: "100%" }} />
                    </Form.Item>

                    <Form.Item
                        label="Usage Limit"
                        name="usageLimit"
                        rules={[{ required: true }]}
                    >
                        <InputNumber style={{ width: "100%" }} />
                    </Form.Item>

                </Form>
            </Modal>
        </>
    )
}
