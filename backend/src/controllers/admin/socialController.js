import Social from "../../models/socialLinkModel.js";

// Admin update links
export const updateLinks = async (req, res) => {
    try {

        const {
            supportTelegram,
            supportWhatsapp,
            officialTelegram,
            officialWhatsapp
        } = req.body;

        let links = await Social.findOne();

        if (!links) {
            links = await Social.create({
                supportTelegram,
                supportWhatsapp,
                officialTelegram,
                officialWhatsapp
            });
        } else {
            links.supportTelegram = supportTelegram;
            links.supportWhatsapp = supportWhatsapp;
            links.officialTelegram = officialTelegram;
            links.officialWhatsapp = officialWhatsapp;
            await links.save();
        }

        res.json({ success: true });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};


// Mobile get links
export const getLinks = async (req, res) => {
    const links = await Social.findOne();
    res.json({ success: true, data: links });
};
