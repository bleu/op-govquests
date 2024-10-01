/** @type {import('next').NextConfig} */
// TODO: DOMAIN JUST FOR TESTING, SHOUDL BE REMOVED OP-298
const nextConfig = {
  reactStrictMode: true,
  images: {
    domains: ["file.coinexstatic.com"],
  },
};
export default nextConfig;
