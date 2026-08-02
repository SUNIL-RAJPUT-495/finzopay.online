import { useEffect, useState } from "react";
import { Drawer, Tag, Divider, Spin, Empty, Tabs, Badge } from "antd";
import { userDetails } from "../../../services/userService";

export default function UserDetailsDrawer({ open, onClose, userId }) {
    const [loading, setLoading] = useState(false);
    const [data, setData] = useState(null);

    useEffect(() => {
        if (open && userId) {
            fetchDetails();
        } else {
            setData(null); // reset on close
        }
    }, [open, userId]);

    const fetchDetails = async () => {
        try {
            setLoading(true);
            const res = await userDetails(userId);

            // ✅ backend sends { success, data }
            setData(res.data);
        } catch (err) {
            console.error("User detail error", err);
        } finally {
            setLoading(false);
        }
    };

    return (
        <Drawer
            title="User Details"
            placement="right"
            width={420}
            onClose={onClose}
            open={open}
        >
            {loading ? (
                <Spin />
            ) : !data ? (
                <Empty description="No data found" />
            ) : (
                <>
                    {/* ================= BASIC ================= */}
                    <div className="space-y-2">
                        <p><b>ID:</b> {data.user._id}</p>
                        <p><b>Name:</b> {data.user.name || "User"}</p>
                        <p><b>Phone:</b> {data.user.phone}</p>
                        <p>
                            <b>Role:</b>{" "}
                            <Tag color="blue">{data.user.role}</Tag>
                        </p>
                    </div>

                    <Divider />

                    {/* ================= WALLET ================= */}
                    <div className="space-y-2">
                        <p><b>Total:</b> ₹{data.wallet.totalBalance}</p>
                        <p><b>Locked:</b> ₹{data.wallet.lockedBalance}</p>
                        <p><b>Available:</b> ₹{data.wallet.availableBalance}</p>
                    </div>

                    <Divider />

                    <Tabs
                        defaultActiveKey="buy"
                        items={[
                            {
                                key: "buy",
                                label: (
                                    <Badge count={data.buyHistory.length} offset={[8, 0]}>
                                        <span>Buy RP</span>
                                    </Badge>
                                ),
                                children: (
                                    <div className="space-y-2">
                                        {data.buyHistory.length === 0 ? (
                                            <p className="text-sm text-gray-500">
                                                No buy history
                                            </p>
                                        ) : (
                                            data.buyHistory.map((b) => (
                                                <div
                                                    key={b.id}
                                                    className="flex justify-between items-center bg-gray-50 p-2 rounded-md"
                                                >
                                                    <div>
                                                        <p className="font-medium">
                                                            ₹{b.amount_paid} → {b.total_rp_credit} RP
                                                        </p>
                                                        <p className="text-xs text-gray-500">
                                                            {new Date(b.createdAt).toLocaleString()}
                                                        </p>
                                                    </div>

                                                    <Tag color="green">
                                                        RECEIVED
                                                    </Tag>
                                                </div>
                                            ))
                                        )}
                                    </div>
                                ),
                            },

                            {
                                key: "sell",
                                label: (
                                    <Badge count={data.sellHistory.length} offset={[8, 0]}>
                                        <span>Sell RP</span>
                                    </Badge>
                                ),
                                children: (
                                    <div className="space-y-2">
                                        {data.sellHistory.length === 0 ? (
                                            <p className="text-sm text-gray-500">
                                                No sell history
                                            </p>
                                        ) : (
                                            data.sellHistory.map((s) => {
                                                let color = "blue";
                                                let label = s.status.toUpperCase();

                                                if (s.status === "paid") color = "green";
                                                if (s.status === "rejected") color = "red";
                                                if (s.status === "pending") color = "orange";

                                                return (
                                                    <div
                                                        key={s.id}
                                                        className="flex justify-between items-center bg-gray-50 p-2 rounded-md"
                                                    >
                                                        <div>
                                                            <p className="font-medium">
                                                                {s.rp_sold} RP → ₹{s.amount}
                                                            </p>
                                                            <p className="text-xs text-gray-500">
                                                                {/* {new Date(s.requestedAt).toLocaleString()} */}
                                                                {new Date(s.createdAt).toLocaleString()}
                                                            </p>
                                                        </div>

                                                        <Tag color={color}>
                                                            {label}
                                                        </Tag>
                                                    </div>
                                                );
                                            })
                                        )}
                                    </div>
                                ),
                            },
                        ]}
                    />

                </>
            )}
        </Drawer>
    );
}
