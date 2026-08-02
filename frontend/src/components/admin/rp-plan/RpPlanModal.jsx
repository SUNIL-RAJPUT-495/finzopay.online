import { Modal, Form, Input, InputNumber, Button, message } from "antd"
import { useEffect, useState } from "react"
import { addRPPlan, updateRPPlan } from "../../../services/rpService"

export default function RpPlanModal({ open, onClose, editData, onSuccess }) {
    const [form] = Form.useForm()
    const [loading, setLoading] = useState(false)

    useEffect(() => {
        if (editData) {
            form.setFieldsValue(editData)
        } else {
            form.resetFields()
        }
    }, [editData, form])

    const onFinish = async (values) => {
        try {
            setLoading(true)

            if (editData) {
                await updateRPPlan(editData._id, values)
                message.success("RP Plan updated successfully")
            } else {
                await addRPPlan(values)
                message.success("RP Plan created successfully")
            }

            onClose()
            onSuccess()
            form.resetFields()
        } catch (err) {
            message.error(err.message || "Operation failed")
        } finally {
            setLoading(false)
        }
    }

    return (
        <Modal
            open={open}
            onCancel={onClose}
            footer={null}
            destroyOnClose
            title={
                <span className="text-lg font-semibold text-[--color-brand-dark]">
                    {editData ? "Edit RP Plan" : "Add RP Plan"}
                </span>
            }
        >
            <Form
                layout="vertical"
                form={form}
                onFinish={onFinish}
                initialValues={{
                    title: "",
                    rp_amount: null,
                    price: null,
                    commission_percent: null,
                }}
            >
                <Form.Item
                    label="Plan Title"
                    name="title"
                    rules={[{ required: true, message: "Title required" }]}
                >
                    <Input placeholder="Ex: 600" />
                </Form.Item>

                <Form.Item
                    label="RP Amount"
                    name="rp_amount"
                    rules={[{ required: true }]}
                >
                    <InputNumber className="w-full" placeholder="Ex: 600" />
                </Form.Item>

                <Form.Item
                    label="Price (₹)"
                    name="price"
                    rules={[{ required: true }]}
                >
                    <InputNumber className="w-full" placeholder="Ex: 600" />
                </Form.Item>

                <Form.Item
                    label="Commission (%)"
                    name="commission_percent"
                    rules={[{ required: true }]}
                >
                    <InputNumber className="w-full" placeholder="Ex: 10" />
                </Form.Item>

                <div className="flex justify-end gap-3 mt-6">
                    <Button onClick={onClose}>Cancel</Button>
                    <Button
                        type="primary"
                        htmlType="submit"
                        loading={loading}
                        style={{ backgroundColor: "var(--color-brand)" }}
                    >
                        {editData ? "Update Plan" : "Create Plan"}
                    </Button>
                </div>
            </Form>
        </Modal>
    )
}
