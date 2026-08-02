import mongoose from "mongoose";

const bankAccountSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User"
    },

    account_holder: String,
    account_number: String,
    ifsc: String,
    bank_name: String,

    is_default: {
        type: Boolean,
        default: false
    }

}, { timestamps: true });

const BankAccount = mongoose.model("BankAccount", bankAccountSchema);
export default BankAccount;