import { useEffect, useState } from "react";
import {
    Table,
    Input,
    Button,
    Switch,
    message,
    Modal,
} from "antd";
import { EyeOutlined, SearchOutlined } from "@ant-design/icons";
import UserDetailsDrawer from "../../components/admin/user/UserDetailsDrawer";
import { allUsers, toggleUserBlock } from "../../services/userService";

export default function Users() {
    const [open, setOpen] = useState(false);
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(false);
    const [selectedUserId, setSelectedUserId] = useState(null);
    const [search, setSearch] = useState("");
    const [togglingUserId, setTogglingUserId] = useState(null);

    useEffect(() => {
        fetchUsers();
        // eslint-disable-next-line
    }, []);

    /* ================= FETCH USERS ================= */
    const fetchUsers = async (searchValue = "") => {
        try {
            setLoading(true);
            const res = await allUsers(searchValue);
            setUsers(res.data);
        } catch (err) {
            message.error("Failed to load users");
        } finally {
            setLoading(false);
        }
    };

    /* ================= TOGGLE BLOCK ================= */
    const handleToggleBlock = (record) => {
        Modal.confirm({
            title: record.isBlocked ? "Unblock User?" : "Block User?",
            content: record.isBlocked
                ? "This user will be able to access the app again."
                : "This user will be blocked and cannot access the app.",
            okText: record.isBlocked ? "Unblock" : "Block",
            okType: record.isBlocked ? "primary" : "danger",
            cancelText: "Cancel",

            onOk: async () => {
                try {
                    setTogglingUserId(record._id);
                    await toggleUserBlock(record._id);

                    message.success(
                        record.isBlocked
                            ? "User unblocked successfully"
                            : "User blocked successfully"
                    );

                    fetchUsers(search);
                } catch (err) {
                    message.error("Failed to update user status");
                } finally {
                    setTogglingUserId(null);
                }
            },
        });
    };

    /* ================= TABLE COLUMNS ================= */
    const columns = [
        {
            title: "User",
            render: (_, record) => (
                <div>
                    <p className="font-medium text-[--color-brand-dark]">
                        {record.name || "User"}
                    </p>
                    <p className="text-xs text-[rgba(30,136,201,0.65)]">
                        {record.phone || record.email}
                    </p>
                </div>
            ),
        },
        {
            title: "Balance (₹)",
            dataIndex: "availableBalance",
        },
        {
            title: "Locked (₹)",
            dataIndex: "lockedBalance",
        },
        {
            title: "Total (₹)",
            dataIndex: "totalBalance",
        },
        {
            title: "Joined",
            dataIndex: "createdAt",
            render: (d) => new Date(d).toLocaleDateString(),
        },
        {
            title: "Status",
            render: (_, record) => (
                <Switch
                    checked={!record.isBlocked}
                    checkedChildren="Active"
                    unCheckedChildren="Blocked"
                    loading={togglingUserId === record._id}
                    disabled={togglingUserId === record._id}
                    onChange={() => handleToggleBlock(record)}
                />
            ),
        },
        {
            title: "Action",
            render: (_, record) => (
                <Button
                    icon={<EyeOutlined />}
                    onClick={() => {
                        setSelectedUserId(record._id);
                        setOpen(true);
                    }}
                >
                    View
                </Button>
            ),
        },
    ];

    return (
        <>
            {/* ================= HEADER ================= */}
            <div className="mb-6">
                <h2 className="text-2xl font-bold text-[--color-brand-dark]">
                    Users
                </h2>
                <p className="text-sm text-[rgba(30,136,201,0.65)]">
                    Manage application users
                </p>
            </div>

            {/* ================= FILTER ================= */}
            <div className="bg-white p-4 rounded-xl shadow-sm mb-6">
                <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <Input
                        placeholder="Search name / phone / email"
                        prefix={<SearchOutlined />}
                        value={search}
                        onChange={(e) => setSearch(e.target.value)}
                        onPressEnter={() => fetchUsers(search)}
                        allowClear
                    />

                    <Button
                        type="primary"
                        onClick={() => fetchUsers(search)}
                    >
                        Apply Filters
                    </Button>
                </div>
            </div>

            {/* ================= TABLE ================= */}
            <div className="bg-white rounded-xl shadow-sm">
                <Table
                    columns={columns}
                    dataSource={users}
                    rowKey="_id"
                    loading={loading}
                    pagination={{ pageSize: 10 }}
                />
            </div>

            {/* ================= USER DETAILS DRAWER ================= */}
            <UserDetailsDrawer
                open={open}
                onClose={() => setOpen(false)}
                userId={selectedUserId}
            />
        </>
    );
}
