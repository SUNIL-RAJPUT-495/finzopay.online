import Referral from "../../models/referralModel.js";

export const createReferral = async (req, res) => {
    const { code, validFrom, validTill, usageLimit } = req.body;

    // const code = "FINZO" + Math.floor(100000 + Math.random() * 900000);

    const referral = await Referral.create({
        code,
        validFrom,
        validTill,
        usageLimit
    });

    res.json(referral);
};

export const getReferrals = async (req, res) => {
    const referrals = await Referral.find().sort({ createdAt: -1 });
    res.json(referrals);
};

export const updateReferralStatus = async (req, res) => {
    const { id } = req.params;
    const { status } = req.body;

    await Referral.findByIdAndUpdate(id, { status });

    res.json({ message: "Updated" });
};

export const deleteReferral = async (req, res) => {
    await Referral.findByIdAndDelete(req.params.id);
    res.json({ message: "Deleted" });
};
