import React from 'react'

function HowItWorks() {
    return (
        <>
            <section id="how-it-works" class="py-24 bg-gradient-to-b from-blue-50 to-white">
                <div class="max-w-7xl mx-auto px-6">

                    <div class="text-center mb-20">
                        <span class="inline-block px-4 py-1 rounded-full bg-brand/10 text-brand font-medium text-sm">
                            How It Works
                        </span>

                        <h2 class="mt-4 text-4xl font-bold text-gray-900">
                            Simple Steps to Use <br />
                            <span class="text-brand">FinzoPay</span>
                        </h2>

                        <p class="mt-4 text-gray-600 max-w-2xl mx-auto">
                            Get started with FinzoPay in just a few easy steps and manage all
                            your transactions effortlessly.
                        </p>
                    </div>

                    <div class="grid md:grid-cols-2 gap-12 items-center mb-20">
                        <div>
                            <span class="text-brand font-bold text-lg">Step 01</span>
                            <h3 class="mt-2 text-2xl font-semibold text-gray-900">
                                Download & Register
                            </h3>
                            <p class="mt-4 text-gray-600">
                                Download the FinzoPay Android app and register using your mobile
                                number to get started instantly.
                            </p>
                        </div>

                        <div class="flex justify-center">
                            <div class="w-64 rounded-3xl bg-white shadow-xl p-4">
                                <img src="/images/register.jpeg" alt="FinzoPay Login Screen" class="rounded-2xl" />
                            </div>
                        </div>
                    </div>

                    <div class="grid md:grid-cols-2 gap-12 items-center mb-20 md:flex-row-reverse">
                        <div class="md:order-2">
                            <span class="text-brand font-bold text-lg">Step 02</span>
                            <h3 class="mt-2 text-2xl font-semibold text-gray-900">
                                Access Dashboard
                            </h3>
                            <p class="mt-4 text-gray-600">
                                View total balance, available funds, and today’s commission all
                                in one clean dashboard.
                            </p>
                        </div>

                        <div class="flex justify-center md:order-1">
                            <div class="w-64 rounded-3xl bg-white shadow-xl p-4">
                                <img src="/images/home.jpeg" alt="FinzoPay Dashboard" class="rounded-2xl" />
                            </div>
                        </div>
                    </div>

                    <div class="grid md:grid-cols-2 gap-12 items-center mb-20">
                        <div>
                            <span class="text-brand font-bold text-lg">Step 03</span>
                            <h3 class="mt-2 text-2xl font-semibold text-gray-900">
                                Make Transactions
                            </h3>
                            <p class="mt-4 text-gray-600">
                                Perform fast and secure transactions directly from the app with
                                complete transparency.
                            </p>
                        </div>

                        <div class="flex justify-center">
                            <div class="w-64 rounded-3xl bg-white shadow-xl p-4">
                                <img src="/images/sellRP.jpeg" alt="FinzoPay Transactions" class="rounded-2xl" />
                            </div>
                        </div>
                    </div>

                    <div class="grid md:grid-cols-2 gap-12 items-center">
                        <div class="md:order-2">
                            <span class="text-brand font-bold text-lg">Step 04</span>
                            <h3 class="mt-2 text-2xl font-semibold text-gray-900">
                                Track Earnings
                            </h3>
                            <p class="mt-4 text-gray-600">
                                Monitor commissions and earnings in real time with detailed
                                insights.
                            </p>
                        </div>

                        <div class="flex justify-center md:order-1">
                            <div class="w-64 rounded-3xl bg-white shadow-xl p-4">
                                <img src="/images/buyRP.jpeg" alt="FinzoPay Commission Screen" class="rounded-2xl" />
                            </div>
                        </div>
                    </div>

                </div>
            </section>
        </>
    )
}

export default HowItWorks
