import React from 'react'

function Footer() {
    return (
        <>
            <footer class="bg-gray-950 text-gray-300 pt-20">
                <div class="max-w-7xl mx-auto px-6 grid gap-12 md:grid-cols-4">

                    <div>
                        <div class="flex items-center gap-2 mb-4">
                            <div class="w-10 h-10 rounded-lg bg-brand flex items-center justify-center text-white font-bold">
                                F
                            </div>
                            <span class="text-2xl font-bold text-white">
                                Finzo<span class="text-brand">Pay</span>
                            </span>
                        </div>

                        <p class="text-sm text-gray-400">
                            FinzoPay is a smart digital payment platform designed to simplify
                            transactions and commission management securely.
                        </p>
                    </div>

                    <div>
                        <h4 class="text-white font-semibold mb-4">Quick Links</h4>
                        <ul class="space-y-3 text-sm">
                            <li><a href="#home" class="hover:text-brand">Home</a></li>
                            <li><a href="#features" class="hover:text-brand">Features</a></li>
                            <li><a href="#how-it-works" class="hover:text-brand">How It Works</a></li>
                            <li><a href="#download" class="hover:text-brand">Download App</a></li>
                        </ul>
                    </div>

                    <div>
                        <h4 class="text-white font-semibold mb-4">Get the App</h4>
                        <div class="space-y-3">
                            <a href="finzopay.apk" download
                                class="block bg-brand text-white text-center py-2 rounded-lg hover:bg-brandDark transition">
                                Download APK
                            </a>
                        </div>
                    </div>

                    <div>
                        <h4 class="text-white font-semibold mb-4">Why FinzoPay?</h4>
                        <ul class="space-y-3 text-sm text-gray-400">
                            <li>✔ Secure Payments</li>
                            <li>✔ Fast Transactions</li>
                            <li>✔ Real-Time Commission</li>
                            <li>✔ User-Friendly App</li>
                        </ul>
                    </div>

                </div>

                <div class="mt-16 border-t border-gray-800">
                    <div
                        class="max-w-7xl mx-auto px-6 py-6 flex flex-col md:flex-row items-center justify-between text-sm text-gray-500">
                        <p>© 2026 FinzoPay. All rights reserved.</p>
                        <p class="mt-2 md:mt-0">
                            Designed for secure digital payments
                        </p>
                    </div>
                </div>
            </footer>
        </>
    )
}

export default Footer
