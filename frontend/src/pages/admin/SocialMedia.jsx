import React, { useEffect, useState } from "react";
import {
    getSocialLinks,
    updateSocialLinks,
} from "../../services/socialService";
import { message } from "antd";

function SocialMedia() {
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);

    const [form, setForm] = useState({
        supportTelegram: "",
        supportWhatsapp: "",
        officialTelegram: "",
        officialWhatsapp: "",
    });

    // ================= LOAD LINKS =================
    const loadLinks = async () => {
        try {
            setLoading(true);
            const res = await getSocialLinks();
            if (res.data) {
                setForm(res.data);
            }
        } catch (err) {
            message.error("Failed to load social links");
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadLinks();
    }, []);

    // ================= HANDLE CHANGE =================
    const handleChange = (e) => {
        setForm({ ...form, [e.target.name]: e.target.value });
    };

    // ================= SAVE =================
    const handleSubmit = async () => {
        try {
            setSaving(true);
            await updateSocialLinks(form);
            message.success("Social links updated successfully");
        } catch (err) {
            message.success("Failed to update links")
        } finally {
            setSaving(false);
        }
    };

    // ================= UI =================
    return (
        <div style={{ padding: 20, maxWidth: 600 }}>
            <h2 style={{ marginBottom: 20 }}>Social Media Links</h2>

            {loading ? (
                <p>Loading...</p>
            ) : (
                <>
                    <Input
                        label="Support Telegram"
                        name="supportTelegram"
                        value={form.supportTelegram}
                        onChange={handleChange}
                    />

                    <Input
                        label="Support WhatsApp"
                        name="supportWhatsapp"
                        value={form.supportWhatsapp}
                        onChange={handleChange}
                    />

                    <Input
                        label="Official Telegram"
                        name="officialTelegram"
                        value={form.officialTelegram}
                        onChange={handleChange}
                    />

                    <Input
                        label="Official WhatsApp"
                        name="officialWhatsapp"
                        value={form.officialWhatsapp}
                        onChange={handleChange}
                    />

                    <button
                        onClick={handleSubmit}
                        disabled={saving}
                        style={{
                            marginTop: 20,
                            background: "#6A11CB",
                            color: "#fff",
                            border: "none",
                            padding: "10px 18px",
                            borderRadius: 8,
                            cursor: "pointer",
                        }}
                    >
                        {saving ? "Saving..." : "Save Changes"}
                    </button>
                </>
            )}
        </div>
    );
}

// ================= INPUT COMPONENT =================
function Input({ label, ...props }) {
    return (
        <div style={{ marginBottom: 14 }}>
            <label style={{ fontSize: 13, fontWeight: 600 }}>{label}</label>
            <input
                {...props}
                style={{
                    width: "100%",
                    marginTop: 6,
                    padding: "10px 12px",
                    borderRadius: 8,
                    border: "1px solid #ddd",
                    fontSize: 14,
                }}
            />
        </div>
    );
}

export default SocialMedia;
