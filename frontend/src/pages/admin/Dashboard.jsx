import { useEffect, useState } from "react";
import { getHomeData } from "../../services/homeService";

function Dashboard() {
    const [loading, setLoading] = useState(true);
    const [stats, setStats] = useState(null);

    useEffect(() => {
        fetchDashboard();
    }, []);

    const fetchDashboard = async () => {
        try {
            const res = await getHomeData();
            setStats(res.data);
        } catch (err) {
            console.error("Dashboard API Error", err);
        } finally {
            setLoading(false);
        }
    };

    if (loading) {
        return <p className="text-center mt-20">Loading dashboard...</p>;
    }

    const { today, overall } = stats;

    return (
        <>
            {/* ===== PAGE HEADER ===== */}
            <div className="mb-8">
                <h2 className="text-3xl font-bold text-[--color-brand-dark]">
                    Dashboard
                </h2>
                <p className="text-[rgba(30,136,201,0.65)]">
                    Overview of today’s performance and overall system stats
                </p>
            </div>

            {/* ================= TODAY STATS ================= */}
            <div className="mb-10">
                <h3 className="text-lg font-semibold text-[--color-brand-dark] mb-4">
                    Today
                </h3>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div className="p-6 rounded-2xl bg-[--color-brand]/10">
                        <p className="text-sm text-[rgba(30,136,201,0.7)]">
                            Today Transactions
                        </p>
                        <p className="text-3xl font-bold text-[--color-brand] mt-1">
                            ₹{today.transactions.toLocaleString()}
                        </p>
                    </div>

                    <div className="p-6 rounded-2xl bg-[--color-brand]/10">
                        <p className="text-sm text-[rgba(30,136,201,0.7)]">
                            Today Commission
                        </p>
                        <p className="text-3xl font-bold text-[--color-brand] mt-1">
                            ₹{today.commission.toLocaleString()}
                        </p>
                    </div>

                    <div className="p-6 rounded-2xl bg-[--color-brand]/10">
                        <p className="text-sm text-[rgba(30,136,201,0.7)]">
                            New Users Today
                        </p>
                        <p className="text-3xl font-bold text-[--color-brand] mt-1">
                            {today.newUsers}
                        </p>
                    </div>
                </div>
            </div>

            {/* ================= OVERALL STATS ================= */}
            <div>
                <h3 className="text-lg font-semibold text-[--color-brand-dark] mb-4">
                    Overall
                </h3>

                <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
                    <div className="p-6 rounded-2xl bg-white border border-[rgba(59,181,242,0.15)]">
                        <p className="text-sm text-[rgba(30,136,201,0.7)]">
                            Total Users
                        </p>
                        <p className="text-3xl font-bold text-[--color-brand-dark] mt-1">
                            {overall.totalUsers}
                        </p>
                    </div>

                    <div className="p-6 rounded-2xl bg-white border border-[rgba(59,181,242,0.15)]">
                        <p className="text-sm text-[rgba(30,136,201,0.7)]">
                            Total Transactions
                        </p>
                        <p className="text-3xl font-bold text-[--color-brand-dark] mt-1">
                            ₹{overall.totalTransactions.toLocaleString()}
                        </p>
                    </div>

                    <div className="p-6 rounded-2xl bg-white border border-[rgba(59,181,242,0.15)]">
                        <p className="text-sm text-[rgba(30,136,201,0.7)]">
                            Total RP Sold
                        </p>
                        <p className="text-3xl font-bold text-[--color-brand-dark] mt-1">
                            {overall.totalRpSold.toLocaleString()}
                        </p>
                    </div>

                    <div className="p-6 rounded-2xl bg-white border border-[rgba(59,181,242,0.15)]">
                        <p className="text-sm text-[rgba(30,136,201,0.7)]">
                            Total Commission
                        </p>
                        <p className="text-3xl font-bold text-[--color-brand-dark] mt-1">
                            ₹{overall.totalCommission.toLocaleString()}
                        </p>
                    </div>
                </div>
            </div>
        </>
    );
}

export default Dashboard;
