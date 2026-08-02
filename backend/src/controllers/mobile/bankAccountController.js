import BankAccount from "../../models/bankAccountModel.js";

/**
 * ADD BANK ACCOUNT
 */
export const addBankAccount = async (req, res) => {
    try {
        const userId = req.user.id;
        const {
            account_holder,
            account_number,
            ifsc,
            bank_name,
            is_default
        } = req.body;

        if (!account_holder || !account_number || !ifsc || !bank_name) {
            return res.status(400).json({
                success: false,
                message: "All fields are required"
            });
        }

        // If setting default, unset previous default
        if (is_default) {
            await BankAccount.updateMany(
                { userId },
                { $set: { is_default: false } }
            );
        }

        const bankAccount = await BankAccount.create({
            userId,
            account_holder,
            account_number,
            ifsc,
            bank_name,
            is_default: is_default || false
        });

        res.status(201).json({
            success: true,
            message: "Bank account added successfully",
            data: bankAccount
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};

/**
 * GET ALL BANK ACCOUNTS (USER)
 */
export const getBankAccounts = async (req, res) => {
    try {
        const userId = req.user.id;

        const accounts = await BankAccount.find({ userId }).sort({
            is_default: -1,
            createdAt: -1
        });

        res.json({
            success: true,
            data: accounts
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};

/**
 * UPDATE BANK ACCOUNT
 */
export const updateBankAccount = async (req, res) => {
    try {
        const userId = req.user.id;
        const { id } = req.params;
        const updateData = req.body;

        const account = await BankAccount.findOne({ _id: id, userId });
        if (!account) {
            return res.status(404).json({
                success: false,
                message: "Bank account not found"
            });
        }

        // If setting default, unset others
        if (updateData.is_default) {
            await BankAccount.updateMany(
                { userId },
                { $set: { is_default: false } }
            );
        }

        const updatedAccount = await BankAccount.findByIdAndUpdate(
            id,
            updateData,
            { new: true }
        );

        res.json({
            success: true,
            message: "Bank account updated successfully",
            data: updatedAccount
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};

/**
 * DELETE BANK ACCOUNT
 */
export const deleteBankAccount = async (req, res) => {
    try {
        const userId = req.user.id;
        const { id } = req.params;

        const account = await BankAccount.findOne({ _id: id, userId });
        if (!account) {
            return res.status(404).json({
                success: false,
                message: "Bank account not found"
            });
        }

        await BankAccount.findByIdAndDelete(id);

        res.json({
            success: true,
            message: "Bank account deleted successfully"
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};
