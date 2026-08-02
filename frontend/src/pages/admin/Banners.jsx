import { useEffect, useState } from "react";
import {
    Table,
    Button,
    Popconfirm,
    message,
} from "antd";
import { PlusOutlined, DeleteOutlined } from "@ant-design/icons";
import {
    getBanners,
    addBanner,
    deleteBanner,
} from "../../services/bannerService";
import AddBannerModal from "../../components/admin/banner/AddBannerModal";

export default function Banners() {
    const [banners, setBanners] = useState([]);
    const [loading, setLoading] = useState(false);
    const [open, setOpen] = useState(false);
    const [adding, setAdding] = useState(false);

    useEffect(() => {
        fetchBanners();
    }, []);

    const fetchBanners = async () => {
        try {
            setLoading(true);
            const res = await getBanners();
            setBanners(res);
        } catch (err) {
            message.error("Failed to load banners");
        } finally {
            setLoading(false);
        }
    };

    const handleAddBanner = async (values, reset) => {
        try {
            setAdding(true);
            await addBanner(values);
            message.success("Banner added");
            setOpen(false);
            reset();
            fetchBanners();
        } catch (err) {
            message.error("Failed to add banner");
        } finally {
            setAdding(false);
        }
    };

    const handleDelete = async (id) => {
        try {
            await deleteBanner(id);
            message.success("Banner deleted");
            fetchBanners();
        } catch (err) {
            message.error("Failed to delete banner");
        }
    };

    const columns = [
        {
            title: "Banner",
            dataIndex: "imageUrl",
            render: (imageUrl) => (
                <img
                    src={imageUrl}
                    alt="banner"
                    className="w-[180px] h-[90px] object-cover rounded"
                />
            ),
        },
        {
            title: "Created",
            dataIndex: "createdAt",
            render: (d) => new Date(d).toLocaleDateString(),
        },
        {
            title: "Action",
            render: (_, record) => (
                <Popconfirm
                    title="Delete this banner?"
                    onConfirm={() => handleDelete(record._id)}
                >
                    <Button
                        danger
                        icon={<DeleteOutlined />}
                    />
                </Popconfirm>
            ),
        },
    ];

    return (
        <>
            {/* HEADER */}
            <div className="flex justify-between items-center mb-6">
                <div>
                    <h2 className="text-2xl font-bold text-[--color-brand-dark]">
                        Banners
                    </h2>
                    <p className="text-sm text-[rgba(30,136,201,0.65)]">
                        Manage homepage banners
                    </p>
                </div>

                <Button
                    type="primary"
                    icon={<PlusOutlined />}
                    onClick={() => setOpen(true)}
                >
                    Add Banner
                </Button>
            </div>

            {/* TABLE */}
            <div className="bg-white rounded-xl shadow-sm">
                <Table
                    columns={columns}
                    dataSource={banners}
                    rowKey="_id"
                    loading={loading}
                    pagination={false}
                />
            </div>

            {/* ADD MODAL */}
            <AddBannerModal
                open={open}
                onClose={() => setOpen(false)}
                onSubmit={handleAddBanner}
                loading={adding}
            />
        </>
    );
}
