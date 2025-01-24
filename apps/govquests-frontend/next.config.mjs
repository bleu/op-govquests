/** @type {import('next').NextConfig} */
const nextConfig = {
  typescript: {
    ignoreBuildErrors: true,
  },
  experimental: {
    serverExternalPackages: ["pino", "pino-pretty"],
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
