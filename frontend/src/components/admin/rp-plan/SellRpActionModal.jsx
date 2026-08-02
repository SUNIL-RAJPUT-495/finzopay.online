import { Modal, Button, Tag, Divider, message } from "antd"
import { useState } from "react"
import { markSellAsPaid, rejectSellRequest } from "../../../services/rpService"

export default function SellRpActionModal({ open, onClose, data, onSuccess }) {
    const [loading, setLoading] = useState(false)

    if (!data) return null

    const handleApprove = async () => {
        try {
            setLoading(true)
            await markSellAsPaid(data._id)
            message.success("Sell request marked as paid")
            onSuccess()
        } catch (err) {
            message.error(err.message || "Failed to approve request")
        } finally {
            setLoading(false)
        }
    }

    const handleReject = async () => {
        try {
            setLoading(true)
            await rejectSellRequest(data._id, {
                admin_note: "Rejected by admin",
            })
            message.success("Sell request cancelled")
            onSuccess()
        } catch (err) {
            message.error(err.message || "Failed to reject request")
        } finally {
            setLoading(false)
        }
    }

    return (
        <Modal
            open={open}
            onCancel={onClose}
            footer={null}
            title={
                <span className="text-lg font-semibold text-[--color-brand-dark]">
                    Sell RP Request Details
                </span>
            }
        >
            {/* User Info */}
            <div className="space-y-3">
                <div className="grid grid-cols-2 gap-4">
                    <div>
                        <span className="text-sm text-gray-500">User</span>
                        <p className="font-medium">{data.user}</p>
                    </div>
                    <div>
                        <span className="text-sm text-gray-500">Phone Number</span>
                        <p className="font-medium">{data.phone}</p>
                    </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                    <div>
                        <span className="text-sm text-gray-500">RP Amount</span>
                        <p className="font-semibold">{data.rp_amount}</p>
                    </div>
                    <div>
                        <span className="text-sm text-gray-500">Money Amount</span>
                        <p className="font-semibold">₹{data.money_amount}</p>
                    </div>
                </div>

                <div>
                    <span className="text-sm text-gray-500">Status</span>
                    <div>
                        <Tag color="orange">{data.status.toUpperCase()}</Tag>
                    </div>
                </div>
            </div>

            <Divider />

            {/* Bank Details */}
            <div className="space-y-2">
                <h4 className="font-semibold text-[--color-brand-dark]">
                    Bank Account Details
                </h4>

                <div className="text-sm">
                    <p><b>Account Holder:</b> {data.bank.holder}</p>
                    <p><b>Account No:</b> {data.bank.account}</p>
                    <p><b>IFSC:</b> {data.bank.ifsc}</p>
                    <p><b>Bank:</b> {data.bank.name}</p>
                </div>
            </div>

            <Divider />

            {/* Actions */}
            <div className="flex justify-end gap-3">
                <Button onClick={onClose}>
                    Close
                </Button>

                <Button
                    danger
                    loading={loading}
                    onClick={handleReject}
                >
                    Cancel Sell
                </Button>

                <Button
                    type="primary"
                    loading={loading}
                    style={{ backgroundColor: "var(--color-brand)" }}
                    onClick={handleApprove}
                >
                    Mark as Selled
                </Button>
            </div>
        </Modal>
    )
}
