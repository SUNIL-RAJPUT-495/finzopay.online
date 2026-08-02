import React from 'react'
import Navbar from '../../components/web/home/Navbar'
import Hero from '../../components/web/home/Hero'
import Features from '../../components/web/home/Features'
import HowItWorks from '../../components/web/home/HowItWorks'
import Download from '../../components/web/home/Download'
import Footer from '../../components/web/home/Footer'

function Home() {
    return (
        <>
            <Navbar />
            <Hero />
            <Features />
            <HowItWorks />
            <Download />
            <Footer />
        </>
    )
}

export default Home
