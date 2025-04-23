import Layout from "@/components/Layout";
import { cn } from "@/lib/utils";
import type { Metadata } from "next";
import { JetBrains_Mono } from "next/font/google";
import "./globals.css";

const jetBrains = JetBrains_Mono({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "GovQuests",
  description: "Your Odyssey Into the Future of Optimism Governance.",
  openGraph: {
    title: "GovQuests",
    description: "Your Odyssey Into the Future of Optimism Governance.",
    type: "website",
    locale: "en_US",
    url: "https://govquests.vercel.app/",
    siteName: "GovQuests",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      className={cn(
        "bg-background text-foreground h-full dark",
        jetBrains.className,
      )}
      lang="en"
    >
      <body className="min-h-screen flex flex-col">
        <Layout>{children}</Layout>
      </body>
    </html>
  );
}
