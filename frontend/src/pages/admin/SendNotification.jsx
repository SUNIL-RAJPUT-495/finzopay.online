import { Card, Form, Input, Button, message } from "antd";
import { useState } from "react";
import { sendPushNotification } from "../../services/notificationService";

const { TextArea } = Input;

export default function SendNotification() {
    const [loading, setLoading] = useState(false);
    const [form] = Form.useForm();

    const onFinish = async (values) => {
        try {
            setLoading(true);
            await sendPushNotification(values);
            message.success("Notification sent successfully");
            form.resetFields();
        } catch (err) {
            message.error(err.message || "Failed to send notification");
        } finally {
            setLoading(false);
        }
    };

    return (
        <Card
            className="max-w-xl rounded-xl shadow-sm"
            title="Send Push Notification"
        >
            <Form layout="vertical" form={form} onFinish={onFinish}>
                <Form.Item
                    label="Notification Title"
                    name="title"
                    rules={[{ required: true }]}
                >
                    <Input placeholder="Enter notification title" />
                </Form.Item>

                <Form.Item
                    label="Message"
                    name="message"
                    rules={[{ required: true }]}
                >
                    <TextArea rows={4} placeholder="Enter notification message" />
                </Form.Item>

                <div className="flex justify-end">
                    <Button
                        type="primary"
                        htmlType="submit"
                        loading={loading}
                        style={{ backgroundColor: "var(--color-brand)" }}
                    >
                        Send Notification
                    </Button>
                </div>
            </Form>
        </Card>
    );
}
