import mongoose from "mongoose";

const walletSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        unique: true
    },

    total_rp: {
        type: Number,
        default: 0
    },

    locked_rp: {
        type: Number,
        default: 0
    }

}, { timestamps: true });

//
// 🧠 AUTO-NORMALIZE BEFORE SAVE
//
walletSchema.pre("save", function () {
    this.total_rp = Math.trunc(this.total_rp);
    this.locked_rp = Math.trunc(this.locked_rp);

    // safety: locked > total not allowed
    if (this.locked_rp > this.total_rp) {
        this.locked_rp = this.total_rp;
    }
});

//
// 📤 SAFE JSON OUTPUT (NO DECIMALS EVER)
//
walletSchema.methods.toJSON = function () {
    const obj = this.toObject();

    obj.total_rp = Math.trunc(obj.total_rp);
    obj.locked_rp = Math.trunc(obj.locked_rp);
    obj.available_rp = Math.trunc(obj.total_rp - obj.locked_rp);

    return obj;
};

//
// 🔧 HELPER VIRTUAL (OPTIONAL BUT CLEAN)
//
walletSchema.virtual("available_rp").get(function () {
    return Math.trunc(this.total_rp - this.locked_rp);
});

const Wallet = mongoose.model("Wallet", walletSchema);
export default Wallet;
