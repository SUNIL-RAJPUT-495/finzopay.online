import { Modal, Button, Tag, Divider, message } from "antd"
import { useState } from "react"
import { approveBuyRequest, rejectBuyRequest } from "../../../services/rpService"


export default function BuyRpActionModal({ open, onClose, data, onSuccess }) {
    const [loading, setLoading] = useState(false)

    if (!data) return null

    const handleApprove = async () => {
        try {
            setLoading(true)
            await approveBuyRequest(data._id)
            message.success("Buy request approved & RP credited")
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
            await rejectBuyRequest(data._id)
            message.success("Buy request rejected")
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
                    Buy RP Request Details
                </span>
            }
        >
            {/* User Info */}
            <div className="space-y-3">
                <div>
                    <span className="text-sm text-gray-500">User</span>
                    <p className="font-medium">{data.user}</p>
                </div>

                <div className="grid grid-cols-2 gap-4">
                    <div>
                        <span className="text-sm text-gray-500">Amount Paid</span>
                        <p className="font-semibold">₹{data.amount}</p>
                    </div>

                    <div>
                        <span className="text-sm text-gray-500">Payment ID</span>
                        <p className="font-semibold">{data.payment_id}</p>
                    </div>
                </div>

                <div>
                    <span className="text-sm text-gray-500">Status</span>
                    <div>
                        <Tag
                            color={
                                data.status === "pending"
                                    ? "orange"
                                    : data.status === "approved"
                                        ? "green"
                                        : "red"
                            }
                        >
                            {data.status.toUpperCase()}
                        </Tag>
                    </div>
                </div>

                <div>
                    <span className="text-sm text-gray-500">Requested On</span>
                    <p>{data.date}</p>
                </div>
            </div>

            <Divider />

            {/* Payment Info */}
            <div className="space-y-2">
                <h4 className="font-semibold text-[--color-brand-dark]">
                    Payment Verification
                </h4>

                <div className="text-sm">
                    <p><b>Payment ID:</b> {data.payment_id}</p>
                    <p><b>Amount:</b> ₹{data.amount}</p>
                    <p className="text-gray-500">
                        Verify this transaction manually from UPI / bank before approval.
                    </p>
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
                    Reject
                </Button>

                <Button
                    type="primary"
                    loading={loading}
                    style={{ backgroundColor: "var(--color-brand)" }}
                    onClick={handleApprove}
                >
                    Approve & Credit RP
                </Button>
            </div>
        </Modal>
    )
}