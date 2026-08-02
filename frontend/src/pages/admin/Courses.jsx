import { useEffect, useState } from "react";
import {
    Tabs,
    Card,
    Form,
    Input,
    Button,
    Select,
    List,
    Tag,
    Skeleton,
    Switch,
    message,
} from "antd";
import { addCourse, getAllCourses, updateCourseStatus } from "../../services/courseService";



const { TabPane } = Tabs;
const { Option } = Select;

export default function Courses() {
    const [form] = Form.useForm();
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);

    const fetchCourses = async () => {
        try {
            setLoading(true);
            const res = await getAllCourses();
            setCourses(res.data);
        } catch (err) {
            message.error("Failed to load courses");
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchCourses();
    }, []);

    const onFinish = async (values) => {
        try {
            setSubmitting(true);
            await addCourse(values);
            message.success("Course added successfully");
            form.resetFields();
            fetchCourses();
        } catch (err) {
            message.error(err.message || "Failed to add course");
        } finally {
            setSubmitting(false);
        }
    };

    const toggleStatus = async (id) => {
        try {
            await updateCourseStatus(id);
            fetchCourses();
        } catch {
            message.error("Failed to update status");
        }
    };

    const renderCoursesByType = (type) => {
        const filtered = courses.filter((c) => c.type === type);

        if (loading) {
            return <Skeleton active paragraph={{ rows: 4 }} />;
        }

        if (!filtered.length) {
            return <p className="text-gray-500">No courses added yet</p>;
        }

        return (
            <List
                grid={{ gutter: 16, column: 2 }}
                dataSource={filtered}
                renderItem={(item) => (
                    <List.Item>
                        <Card
                            className="rounded-xl shadow-sm"
                            title={item.title}
                            extra={
                                <Switch
                                    checked={item.status === "active"}
                                    onChange={() => toggleStatus(item._id)}
                                />
                            }
                        >
                            <p className="text-sm text-gray-500 mb-2">
                                Type: <Tag color="blue">{item.type}</Tag>
                            </p>

                            <a
                                href={item.video_link}
                                target="_blank"
                                rel="noreferrer"
                                className="text-[--color-brand]"
                            >
                                Watch on YouTube
                            </a>
                        </Card>
                    </List.Item>
                )}
            />
        );
    };

    return (
        <div className="space-y-8">
            {/* ADD COURSE */}
            <Card className="rounded-xl shadow-sm" title="Add New Course">
                <Form form={form} layout="vertical" onFinish={onFinish}>
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <Form.Item label="Course Title" name="title" rules={[{ required: true }]}>
                            <Input placeholder="Enter course title" />
                        </Form.Item>

                        <Form.Item label="YouTube Link" name="video_link" rules={[{ required: true }]}>
                            <Input placeholder="https://youtube.com/..." />
                        </Form.Item>

                        <Form.Item label="Course Type" name="type" rules={[{ required: true }]}>
                            <Select placeholder="Select type">
                                <Option value="purchase">Purchase</Option>
                                <Option value="selling">Selling</Option>
                                <Option value="security">Security Tips</Option>
                            </Select>
                        </Form.Item>
                    </div>

                    <div className="flex justify-end">
                        <Button
                            type="primary"
                            htmlType="submit"
                            loading={submitting}
                            style={{ backgroundColor: "var(--color-brand)" }}
                        >
                            Add Course
                        </Button>
                    </div>
                </Form>
            </Card>

            {/* COURSES TABS */}
            <Card className="rounded-xl shadow-sm">
                <Tabs defaultActiveKey="purchase">
                    <TabPane tab="Purchase Courses" key="purchase">
                        {renderCoursesByType("purchase")}
                    </TabPane>
                    <TabPane tab="Selling Courses" key="selling">
                        {renderCoursesByType("selling")}
                    </TabPane>
                    <TabPane tab="Security Tips" key="security">
                        {renderCoursesByType("security")}
                    </TabPane>
                </Tabs>
            </Card>
        </div>
    );
}
