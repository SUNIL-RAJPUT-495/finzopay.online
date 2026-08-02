import React, { useEffect, useState } from "react";
import {
    getAllSupport,
    updateSupportStatus,
    deleteSupport,
} from "../../services/supportService";

function Support() {
    const [tickets, setTickets] = useState([]);
    const [loading, setLoading] = useState(true);

    // ================= FETCH SUPPORT LIST =================
    const loadSupport = async () => {
        try {
            setLoading(true);
            const res = await getAllSupport();
            setTickets(res.data || []);
        } catch (err) {
            alert("Failed to load support requests");
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadSupport();
    }, []);

    // ================= CHANGE STATUS =================
    const changeStatus = async (id, newStatus) => {
        try {
            // optimistic UI
            setTickets((prev) =>
                prev.map((t) =>
                    t._id === id ? { ...t, status: newStatus } : t
                )
            );

            await updateSupportStatus(id, newStatus);
        } catch (err) {
            alert("Failed to update status");
            loadSupport(); // rollback
        }
    };

    // ================= DELETE =================
    const handleDelete = async (id) => {
        if (!window.confirm("Are you sure you want to delete this ticket?")) return;

        try {
            // optimistic UI
            setTickets((prev) => prev.filter((t) => t._id !== id));
            await deleteSupport(id);
        } catch (err) {
            alert("Failed to delete ticket");
            loadSupport(); // rollback
        }
    };

    const statusColor = (status) => {
        switch (status) {
            case "open":
                return "orange";
            case "resolved":
                return "green";
            case "In Progress":
                return "blue";
            default:
                return "gray";
        }
    };

    // ================= UI =================
    return (
        <div style={{ padding: 20 }}>
            <h2 style={{ marginBottom: 20 }}>Support Requests</h2>

            {loading ? (
                <p>Loading...</p>
            ) : (
                <table style={{ width: "100%", borderCollapse: "collapse" }}>
                    <thead>
                        <tr style={{ background: "#f4f6f8", textAlign: "left" }}>
                            <th style={th}>Name</th>
                            <th style={th}>Email</th>
                            <th style={th}>Message</th>
                            <th style={th}>Status</th>
                            <th style={th}>Change Status</th>
                            <th style={th}>Action</th>
                        </tr>
                    </thead>

                    <tbody>
                        {tickets.map((ticket) => (
                            <tr key={ticket._id} style={{ borderBottom: "1px solid #eee" }}>
                                <td style={td}>{ticket.name}</td>
                                <td style={td}>{ticket.email}</td>
                                <td style={td}>{ticket.message}</td>

                                <td style={td}>
                                    <span
                                        style={{
                                            padding: "4px 10px",
                                            borderRadius: 12,
                                            fontSize: 12,
                                            color: "#fff",
                                            background: statusColor(ticket.status),
                                        }}
                                    >
                                        {ticket.status}
                                    </span>
                                </td>

                                <td style={td}>
                                    <select
                                        value={ticket.status}
                                        onChange={(e) =>
                                            changeStatus(ticket._id, e.target.value)
                                        }
                                    >
                                        <option value="open">Open</option>
                                        <option value="resolved">Resolved</option>
                                    </select>
                                </td>

                                <td style={td}>
                                    <button
                                        onClick={() => handleDelete(ticket._id)}
                                        style={{
                                            background: "#ff4d4f",
                                            color: "#fff",
                                            border: "none",
                                            padding: "6px 12px",
                                            borderRadius: 6,
                                            cursor: "pointer",
                                        }}
                                    >
                                        Delete
                                    </button>
                                </td>
                            </tr>
                        ))}

                        {tickets.length === 0 && (
                            <tr>
                                <td colSpan="6" style={{ textAlign: "center", padding: 20 }}>
                                    No support tickets found
                                </td>
                            </tr>
                        )}
                    </tbody>
                </table>
            )}
        </div>
    );
}

const th = {
    padding: "12px 10px",
    fontWeight: 600,
    fontSize: 14,
};

const td = {
    padding: "12px 10px",
    fontSize: 14,
};

export default Support;
