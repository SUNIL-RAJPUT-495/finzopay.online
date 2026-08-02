import nodemailer from 'nodemailer';

const sendEmail = async ({ to, subject, text, html }) => {
    try {
        const transporter = nodemailer.createTransport({
            host: process.env.SMTP_HOST,
            port: process.env.SMTP_PORT,
            secure: process.env.SMTP_SECURE, // true for 465, false for other ports
            auth: {
                user: process.env.SMTP_USER,
                pass: process.env.SMTP_PASS,
            },
        });

        const mailOptions = {
            from: `"${process.env.SMTP_FROM_NAME}" <${process.env.SMTP_FROM_EMAIL}>`,
            to,
            subject,
            text,
            html,
        };

        await transporter.sendMail(mailOptions);
        console.log("✅ Email sent to:", to);
    } catch (error) {
        console.log(error)
        console.error("❌ Email sending error:", error.message);
        throw new Error("Email not sent, try again later.");
    }
};

export default sendEmail;
