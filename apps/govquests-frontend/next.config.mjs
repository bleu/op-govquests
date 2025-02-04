/** @type {import('next').NextConfig} */
const nextConfig = {
  typescript: {
    ignoreBuildErrors: true,
  },
  async rewrites() {
    const destination =
      process.env.NEXT_PUBLIC_API_URL || "http://localhost:3001/graphql";

    return [
      {
        source: "/graphql",
        destination,
      },
    ];
  },
};
export default nextConfig;
