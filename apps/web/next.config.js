/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  output: 'standalone',

  // Environment variables
  env: {
    API_URL: process.env.API_URL || 'http://localhost:3001',
  },

  // Image optimization
  images: {
    domains: ['localhost', 'darrtoexfebfbmzyubxf.supabase.co'],
    formats: ['image/avif', 'image/webp'],
  },
}

module.exports = nextConfig
