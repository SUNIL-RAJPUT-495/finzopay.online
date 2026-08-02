import React from 'react'

function Download() {
    return (
        <>
            <section id="download" class="py-24 bg-gradient-to-br from-brand to-brandDark text-white relative overflow-hidden">
                <div class="absolute -top-20 -left-20 w-96 h-96 bg-white/10 rounded-full blur-3xl"></div>
                <div class="absolute bottom-0 -right-20 w-96 h-96 bg-white/10 rounded-full blur-3xl"></div>

                <div class="relative max-w-7xl mx-auto px-6 grid md:grid-cols-2 gap-12 items-center">

                    <div>
                        <span class="inline-block px-4 py-1 rounded-full bg-white/20 text-white text-sm font-medium">
                            Get Started Today
                        </span>

                        <h2 class="mt-4 text-4xl font-extrabold leading-tight">
                            Download the <br />
                            <span class="text-white">FinzoPay Android App</span>
                        </h2>

                        <p class="mt-4 text-white/80 max-w-lg">
                            Manage payments, track commissions, and grow your business
                            effortlessly with FinzoPay.
                        </p>

                        <div class="mt-8 flex flex-wrap gap-4">
                            <a href="finzopay.apk" download="finzopay.apk"
                                class="flex items-center gap-3 bg-white text-brand px-6 py-3 rounded-xl font-semibold shadow-lg transition hover:scale-105">
                                <i class="fa-solid fa-download text-lg"></i>
                                <span>Download APK</span>
                            </a>
                        </div>

                        <p class="mt-6 text-sm text-white">
                            ✔ Secure payments • ✔ Fast onboarding • ✔ Trusted platform
                        </p>
                    </div>

                    <div class="flex justify-center md:justify-end">
                        <div
                            class="relative w-fit h-[480px] rounded-3xl bg-white/90 backdrop-blur-xl shadow-2xl p-4 animate-float">
                            <img src="/images/splash.jpeg" alt="FinzoPay App Preview" class="rounded-2xl h-full object-cover" />
                        </div>
                    </div>

                </div>
            </section>
        </>
    )
}

export default Download
