import React, { useEffect, useState } from "react";
import { Input, Button, Upload, message } from "antd";
import { UploadOutlined } from "@ant-design/icons";
import { getAdminProfile, updateAdminProfile } from "../../services/authService";

function Profile() {
    const [formData, setFormData] = useState({
        name: "",
        email: "",
        password: "",
        upiId: "",
        qrCode: ""
    });

    const [originalData, setOriginalData] = useState({});
    const [qrPreview, setQrPreview] = useState("");
    const [file, setFile] = useState(null);
    const [loading, setLoading] = useState(false);

    const fetchProfile = async () => {
        try {
            const res = await getAdminProfile();
            const data = res?.data;

            setFormData({
                name: data?.name || "",
                email: data?.email || "",
                password: "",
                upiId: data?.upiId || "",
                qrCode: data?.qrCode || ""
            });

            setOriginalData({
                name: data?.name || "",
                email: data?.email || "",
                upiId: data?.upiId || "",
                qrCode: data?.qrCode || ""
            });

            setQrPreview(data?.qrCode || "");

        } catch (err) {
            message.error(err?.response?.data?.message || "Failed to load profile");
        }
    };

    useEffect(() => {
        fetchProfile();
    }, []);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData((prev) => ({ ...prev, [name]: value }));
    };

    const handleUpload = ({ file }) => {
        setFile(file);

        const reader = new FileReader();
        reader.onload = () => {
            setQrPreview(reader.result);
        };
        reader.readAsDataURL(file);
    };

    const isChanged = () => {
        return (
            formData.name !== originalData.name ||
            formData.email !== originalData.email ||
            formData.upiId !== originalData.upiId ||
            file !== null ||
            formData.password.trim() !== ""
        );
    };

    const handleUpdate = async () => {
        try {
            setLoading(true);

            const form = new FormData();
            form.append("name", formData.name);
            form.append("email", formData.email);
            form.append("upiId", formData.upiId);

            if (formData.password.trim()) {
                form.append("password", formData.password);
            }

            if (file) {
                form.append("qrCode", file);
            }

            const res = await updateAdminProfile(form);

            if (res.success) {
                message.success("Profile updated successfully");
                setFile(null);
                setFormData((prev) => ({ ...prev, password: "" }));
                fetchProfile();
            } else {
                message.error(res.data.message);
            }

        } catch (err) {
            message.error(err?.response?.data?.message || "Update failed");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="min-h-screen bg-gray-100 flex justify-center items-center p-6">
            <div className="w-full max-w-3xl bg-white rounded-3xl shadow-xl p-8">

                {/* HEADER */}
                <div className="flex items-center justify-between mb-8">
                    <div>
                        <h2 className="text-3xl font-bold text-gray-800">Profile Settings</h2>
                        <p className="text-gray-500 text-sm">Manage your admin account details</p>
                    </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">

                    {/* LEFT SIDE */}
                    <div className="space-y-5">

                        <div>
                            <label className="text-sm text-gray-600 mb-1 block">Full Name</label>
                            <Input
                                name="name"
                                value={formData.name}
                                onChange={handleChange}
                                size="large"
                            />
                        </div>

                        <div>
                            <label className="text-sm text-gray-600 mb-1 block">Email Address</label>
                            <Input
                                name="email"
                                value={formData.email}
                                onChange={handleChange}
                                size="large"
                            />
                        </div>

                        <div>
                            <label className="text-sm text-gray-600 mb-1 block">New Password</label>
                            <Input.Password
                                name="password"
                                value={formData.password}
                                onChange={handleChange}
                                size="large"
                                placeholder="Leave blank to keep same"
                            />
                        </div>

                        <div>
                            <label className="text-sm text-gray-600 mb-1 block">UPI ID</label>
                            <Input
                                name="upiId"
                                value={formData.upiId}
                                onChange={handleChange}
                                size="large"
                            />
                        </div>
                    </div>

                    {/* RIGHT SIDE (QR) */}
                    <div className="flex flex-col items-center justify-center border rounded-2xl p-6 bg-gray-50">

                        <p className="text-sm text-gray-600 mb-3">QR Code</p>

                        {qrPreview ? (
                            <img
                                src={qrPreview}
                                alt="QR"
                                className="w-44 h-44 object-contain rounded-xl border mb-4"
                            />
                        ) : (
                            <div className="w-44 h-44 flex items-center justify-center border rounded-xl text-gray-400 mb-4">
                                No QR Uploaded
                            </div>
                        )}

                        <Upload
                            beforeUpload={() => false}
                            showUploadList={false}
                            onChange={handleUpload}
                        >
                            <Button icon={<UploadOutlined />} size="middle">
                                Change QR
                            </Button>
                        </Upload>

                    </div>
                </div>

                {/* FOOTER BUTTON */}
                <div className="mt-8">
                    <Button
                        type="primary"
                        size="large"
                        className="w-full h-12 text-base font-medium"
                        onClick={handleUpdate}
                        disabled={!isChanged()}
                        loading={loading}
                    >
                        Update Profile
                    </Button>
                </div>

            </div>
        </div>
    );
}

export default Profile;