import mongoose from "mongoose";

const commissionSchema = new mongoose.Schema(
    {
        userId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User",
            required: true,
        },

        source: {
            type: String,
            enum: ["buy_rp", "referral", "manual"],
            required: true,
        },

        // 🎯 COMMISSION RP (ALWAYS INTEGER)
        rp_amount: {
            type: Number,
            required: true,
        },
    },
    { timestamps: true }
);

//
// 🔥 AUTO INTEGER NORMALIZATION (SAVE TIME)
//
commissionSchema.pre("save", function () {
    this.rp_amount = Math.trunc(this.rp_amount);
});

//
// 🔒 RESPONSE SAFETY (API / ADMIN / MOBILE)
//
commissionSchema.methods.toJSON = function () {
    const obj = this.toObject();
    obj.rp_amount = Math.trunc(obj.rp_amount);
    return obj;
};

const Commission = mongoose.model("Commission", commissionSchema);
export default Commission;
