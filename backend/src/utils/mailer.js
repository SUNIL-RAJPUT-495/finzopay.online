// utils/mailer.js
const nodemailer = require('nodemailer');
const { promisify } = require('util');

const {
    SMTP_HOST,
    SMTP_PORT,
    SMTP_SECURE,
    SMTP_USER,
    SMTP_PASS,
    EMAIL_FROM,
    APP_BASE_URL,
} = process.env;

if (!SMTP_HOST || !SMTP_USER || !SMTP_PASS) {
    console.warn('Mailer: missing SMTP env vars - emails will fail until configured.');
}

// create transporter with pooling for throughput & reuse
const transporter = nodemailer.createTransport({
    host: SMTP_HOST,
    port: Number(SMTP_PORT) || 465,
    secure: SMTP_SECURE === 'true' || SMTP_PORT === '465',
    auth: {
        user: SMTP_USER,
        pass: SMTP_PASS,
    },
    pool: true,
    maxConnections: 5,
    maxMessages: 100,
    // connection timeout etc:
    greetingTimeout: 30000,
    socketTimeout: 30000,
});

// promisified sendMail
const sendRaw = promisify(transporter.sendMail.bind(transporter));

// simple logger
function log(...args) { console.log('[mailer]', ...args); }
function errLog(...args) { console.error('[mailer ERROR]', ...args); }

/**
 * Templates: functions that accept `data` and return { subject, html, text }.
 * Add more templates as needed.
 */
const templates = {
    registration: (data) => ({
        subject: `Welcome to Novo Holidays, ${data.name || ''}!`,
        text: `Hi ${data.name || 'there'},\n\nThanks for registering with Novo Holidays.\n\nVisit: ${APP_BASE_URL}\n`,
        html: `
      <div style="font-family: sans-serif; line-height:1.4">
        <h2>Welcome${data.name ? `, ${data.name}` : ''}!</h2>
        <p>Thanks for registering with <strong>Novo Holidays</strong>.</p>
        <p>Need help? Reply to this email.</p>
        <hr/>
        <small>Visit: <a href="${APP_BASE_URL}">${APP_BASE_URL}</a></small>
      </div>
    `,
    }),

    orderSuccess: (data) => ({
        subject: `Order #${data.orderId} confirmed ✔`,
        text: `Your order ${data.orderId} is confirmed. Total: ${data.total}\n`,
        html: `
      <div style="font-family:sans-serif">
        <h3>Order Confirmed</h3>
        <p>Thanks ${data.name || ''}, your order <strong>#${data.orderId}</strong> has been received.</p>
        <p>Total: ${data.total}</p>
        <a href="${APP_BASE_URL}/orders/${data.orderId}">View order</a>
      </div>
    `,
    }),

    orderStatusChange: (data) => ({
        subject: `Order #${data.orderId} — status updated to ${data.status}`,
        text: `Order ${data.orderId} status is now ${data.status}`,
        html: `<p>Your order <strong>#${data.orderId}</strong> status: ${data.status}</p>`,
    }),

    newsletter: (data) => ({
        subject: data.subject || 'Latest offers from Novo Holidays',
        text: data.plainText || 'Check latest offers.',
        html: `
      <div>
        <h2>${data.title || 'Latest Offers'}</h2>
        <p>${data.lead || ''}</p>
        <a href="${data.link || APP_BASE_URL}">View offers</a>
      </div>
    `,
    }),

    forgotPassword: (data) => {
        const resetUrl = `${APP_BASE_URL}/auth/reset-password?token=${encodeURIComponent(data.token)}`;
        return {
            subject: 'Reset your password — Novo Holidays',
            text: `Use this link to reset your password: ${resetUrl}`,
            html: `
        <div style="font-family:sans-serif">
          <p>Hi ${data.name || ''},</p>
          <p>We received a request to reset your password. Click below to reset. This link is valid for ${data.expiresMinutes || 60} minutes.</p>
          <p><a href="${resetUrl}" style="padding: 10px 14px; background:#0077cc; color:white; text-decoration:none; border-radius:4px;">Reset password</a></p>
          <p>If you didn't request this, ignore this email.</p>
        </div>
      `,
        };
    },

    otpVerification: (data) => ({
        subject: 'Your verification code',
        text: `Your verification code is: ${data.otp}`,
        html: `<p>Your verification code is <strong>${data.otp}</strong>. It expires in ${data.expiresMinutes || 10} minutes.</p>`,
    }),

    // add other templates...
};

/**
 * sendMail core function with retries and exponential backoff.
 * options:
 *  - to, subject, html, text, cc, bcc, attachments
 *  - template: name of template in templates
 *  - data: passed into template
 */
async function sendMail(options = {}) {
    const {
        to,
        template,
        data,
        subject,
        html,
        text,
        cc,
        bcc,
        attachments,
        from = EMAIL_FROM,
        maxRetries = 3,
    } = options;

    if (!to) throw new Error('sendMail: "to" required.');

    // if template provided, build subject/html/text from template
    let built = {};
    if (template) {
        const tpl = templates[template];
        if (!tpl) throw new Error(`Unknown email template: ${template}`);
        built = tpl(data || {});
    }

    const mailOptions = {
        from,
        to,
        cc,
        bcc,
        subject: subject || built.subject,
        text: text || built.text,
        html: html || built.html,
        attachments,
    };

    let attempt = 0;
    const baseDelay = 500; // ms
    while (attempt <= maxRetries) {
        try {
            attempt += 1;
            const info = await sendRaw(mailOptions);
            log(`Email sent to ${to} (attempt ${attempt})`, info && info.messageId ? info.messageId : '');
            return info;
        } catch (err) {
            errLog(`Send attempt ${attempt} failed for ${to}:`, err.message || err);
            if (attempt > maxRetries) {
                errLog('Max retries reached — giving up.');
                throw err;
            }
            // exponential backoff (with jitter)
            const delay = baseDelay * (2 ** (attempt - 1)) + Math.floor(Math.random() * 200);
            await new Promise(res => setTimeout(res, delay));
        }
    }
}

/**
 * Convenience helper to send predefined event emails
 */
async function sendEventEmail(eventName, payload) {
    switch (eventName) {
        case 'registration':
            return sendMail({ to: payload.email, template: 'registration', data: payload });
        case 'orderSuccess':
            return sendMail({ to: payload.email, template: 'orderSuccess', data: payload });
        case 'orderStatusChange':
            return sendMail({ to: payload.email, template: 'orderStatusChange', data: payload });
        case 'newsletter':
            return sendMail({ to: payload.email, template: 'newsletter', data: payload });
        case 'forgotPassword':
            return sendMail({ to: payload.email, template: 'forgotPassword', data: payload });
        case 'otp':
            return sendMail({ to: payload.email, template: 'otpVerification', data: payload });
        default:
            return sendMail({ to: payload.email, subject: payload.subject || 'Message', html: payload.html, text: payload.text });
    }
}

module.exports = {
    transporter,
    sendMail,
    sendEventEmail,
    templates, // exported if you want to use them directly
};
