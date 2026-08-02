import { useState, useEffect } from "react"

export default function Navbar() {
    const [open, setOpen] = useState(false)
    const [active, setActive] = useState("home")

    useEffect(() => {
        const sections = document.querySelectorAll("section[id]")

        const onScroll = () => {
            let current = ""
            sections.forEach(section => {
                if (window.scrollY >= section.offsetTop - 120) {
                    current = section.id
                }
            })
            setActive(current)
        }

        window.addEventListener("scroll", onScroll)
        return () => window.removeEventListener("scroll", onScroll)
    }, [])

    const linkClass = id =>
        `hover:text-brand transition ${active === id ? "text-brand font-semibold" : ""
        }`

    return (
        <header className="fixed top-0 left-0 w-full bg-white/80 backdrop-blur-md z-50 shadow-sm">
            <nav className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
                {/* Logo */}
                <a href="#home" className="flex items-center gap-2">
                    <div className="w-9 h-9 rounded-lg bg-brand flex items-center justify-center text-white font-bold">
                        F
                    </div>
                    <span className="text-xl font-bold text-gray-900">
                        Finzo<span className="text-brand">Pay</span>
                    </span>
                </a>

                {/* Desktop Menu */}
                <ul className="hidden md:flex items-center gap-8 font-medium">
                    <li><a href="#home" className={linkClass("home")}>Home</a></li>
                    <li><a href="#features" className={linkClass("features")}>Features</a></li>
                    <li><a href="#how-it-works" className={linkClass("how-it-works")}>How It Works</a></li>
                    <li><a href="#download" className={linkClass("download")}>Download</a></li>
                </ul>

                {/* CTA */}
                <a
                    href="finzopay.apk"
                    download
                    className="hidden md:inline-block bg-brand hover:bg-brandDark text-white px-6 py-2 rounded-full shadow-md"
                >
                    Get App
                </a>

                {/* Mobile Button */}
                <button
                    className="md:hidden text-2xl"
                    onClick={() => setOpen(!open)}
                >
                    ☰
                </button>
            </nav>

            {/* Mobile Menu */}
            {open && (
                <div className="md:hidden bg-white border-t">
                    <ul className="flex flex-col p-6 gap-4 font-medium">
                        <li><a href="#home">Home</a></li>
                        <li><a href="#features">Features</a></li>
                        <li><a href="#how-it-works">How It Works</a></li>
                        <li><a href="#download">Download</a></li>
                    </ul>
                </div>
            )}
        </header>
    )
}
