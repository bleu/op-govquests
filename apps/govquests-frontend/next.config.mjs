/** @type {import('next').NextConfig} */
const nextConfig = {
  typescript: {
    ignoreBuildErrors: true,
  },
  async rewrites() {
    return [
      {
        source: "/graphql",
        destination: "http://localhost:3001/graphql",
      },
    ];
  },
};
export default nextConfig;
