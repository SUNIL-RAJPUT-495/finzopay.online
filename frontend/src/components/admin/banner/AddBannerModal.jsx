import { Modal, Form, Upload, Button, message } from "antd";
import { UploadOutlined } from "@ant-design/icons";
import { useState } from "react";

export default function AddBannerModal({
    open,
    onClose,
    onSubmit,
    loading,
}) {
    const [form] = Form.useForm();
    const [fileList, setFileList] = useState([]);

    const handleFinish = () => {
        if (fileList.length === 0) {
            message.error("Please select an image");
            return;
        }

        const formData = new FormData();
        formData.append("image", fileList[0].originFileObj);

        onSubmit(formData, () => {
            form.resetFields();
            setFileList([]);
        });
    };

    return (
        <Modal
            title="Add New Banner"
            open={open}
            onCancel={() => {
                onClose();
                setFileList([]);
            }}
            footer={null}
        >
            <Form form={form} layout="vertical" onFinish={handleFinish}>
                <Form.Item label="Banner Image">
                    <Upload
                        listType="picture"
                        maxCount={1}
                        fileList={fileList}
                        beforeUpload={() => false} // ❗ prevent auto upload
                        onChange={({ fileList }) => setFileList(fileList)}
                    >
                        <Button icon={<UploadOutlined />}>
                            Select Image
                        </Button>
                    </Upload>
                </Form.Item>

                <Button
                    type="primary"
                    htmlType="submit"
                    loading={loading}
                    block
                >
                    Add Banner
                </Button>
            </Form>
        </Modal>
    );
}
