import React from 'react'

function Features() {
    return (
        <>
            <section id="features" class="py-24 bg-white">
                <div class="max-w-7xl mx-auto px-6">

                    <div class="text-center mb-16">
                        <span class="inline-block px-4 py-1 rounded-full bg-brand/10 text-brand font-medium text-sm">
                            Why FinzoPay
                        </span>

                        <h2 class="mt-4 text-4xl font-bold text-gray-900">
                            Powerful Features for <br />
                            <span class="text-brand">Smart Payments</span>
                        </h2>

                        <p class="mt-4 text-gray-600 max-w-2xl mx-auto">
                            FinzoPay is designed to make digital transactions faster, safer,
                            and easier for everyone.
                        </p>
                    </div>

                    <div class="grid gap-8 sm:grid-cols-2 lg:grid-cols-4">

                        <div class="group bg-blue-50 rounded-2xl p-8 transition hover:-translate-y-2 hover:shadow-xl">
                            <div
                                class="w-14 h-14 rounded-xl bg-brand flex items-center justify-center text-white text-2xl mb-6">
                                ⚡
                            </div>
                            <h3 class="text-lg font-semibold text-gray-900 mb-2">
                                Fast Transactions
                            </h3>
                            <p class="text-gray-600 text-sm">
                                Experience lightning-fast payment processing with zero hassle.
                            </p>
                        </div>

                        <div class="group bg-blue-50 rounded-2xl p-8 transition hover:-translate-y-2 hover:shadow-xl">
                            <div
                                class="w-14 h-14 rounded-xl bg-brand flex items-center justify-center text-white text-2xl mb-6">
                                🔒
                            </div>
                            <h3 class="text-lg font-semibold text-gray-900 mb-2">
                                Secure & Reliable
                            </h3>
                            <p class="text-gray-600 text-sm">
                                Your data and payments are protected with advanced security.
                            </p>
                        </div>

                        <div class="group bg-blue-50 rounded-2xl p-8 transition hover:-translate-y-2 hover:shadow-xl">
                            <div
                                class="w-14 h-14 rounded-xl bg-brand flex items-center justify-center text-white text-2xl mb-6">
                                📊
                            </div>
                            <h3 class="text-lg font-semibold text-gray-900 mb-2">
                                Commission Tracking
                            </h3>
                            <p class="text-gray-600 text-sm">
                                Track earnings and commissions in real time with clarity.
                            </p>
                        </div>

                        <div class="group bg-blue-50 rounded-2xl p-8 transition hover:-translate-y-2 hover:shadow-xl">
                            <div
                                class="w-14 h-14 rounded-xl bg-brand flex items-center justify-center text-white text-2xl mb-6">
                                📱
                            </div>
                            <h3 class="text-lg font-semibold text-gray-900 mb-2">
                                Easy to Use
                            </h3>
                            <p class="text-gray-600 text-sm">
                                Simple, intuitive interface designed for smooth user experience.
                            </p>
                        </div>

                    </div>
                </div>
            </section>
        </>
    )
}

export default Features
