export default function Hero() {
    return (
        <section
            id="home"
            className="relative pt-32 pb-20 bg-gradient-to-br from-blue-50 to-white overflow-hidden"
        >
            <div className="absolute -top-24 -left-24 w-96 h-96 bg-brand/20 rounded-full blur-3xl"></div>

            <div className="relative max-w-7xl mx-auto px-6 grid md:grid-cols-2 gap-12 items-center">
                <div className="space-y-6">
                    <span className="inline-block px-4 py-1 rounded-full bg-brand/10 text-brand text-sm">
                        Smart • Secure • Fast
                    </span>

                    <h1 className="text-4xl md:text-5xl font-extrabold">
                        Simplify Your <br />
                        <span className="text-brand">Digital Payments</span> <br />
                        With FinzoPay
                    </h1>

                    <p className="text-gray-600 max-w-lg">
                        Manage transactions, commissions, and payments seamlessly.
                    </p>

                    <div className="flex gap-4 flex-wrap">
                        <a
                            href="finzopay.apk"
                            download
                            className="bg-brand text-white px-8 py-3 rounded-full shadow-lg flex items-center gap-3"
                        >
                            <i className="fa-brands fa-android text-xl"></i>
                            Download Android App
                        </a>

                        <a
                            href="#features"
                            className="px-8 py-3 rounded-full border border-brand text-brand"
                        >
                            Learn More
                        </a>
                    </div>
                </div>

                <div className="flex justify-center">
                    <div className="w-64 rounded-3xl bg-white shadow-xl p-4">
                        <img src="/images/home.jpeg" className="rounded-2xl" />
                    </div>
                </div>
            </div>
        </section>
    )
}
