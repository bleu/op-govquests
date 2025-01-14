"use client";

import { WagmiProvider } from "wagmi";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { ConnectKitProvider, SIWEProvider } from "connectkit";
import { config, siweConfig } from "@/wagmi";
import Header from "./Header";
import { Toaster } from "./ui/toaster";
import { useNotificationProcessor } from "@/domains/notifications/hooks/useNotificationProcessor";
import Image from "next/image";
import Footer from "./Footer";

export const queryClient = new QueryClient();

const Providers = ({ children }: Readonly<{ children: React.ReactNode }>) => {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <SIWEProvider {...siweConfig}>
          <ConnectKitProvider>
            <Header />
            <div className="h-full">{children}</div>
            <Footer />
          </ConnectKitProvider>
        </SIWEProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
};

export default function Layout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <Providers>
      <div className="h-full relative">
        <Image
          src="/backgrounds/first_tier.svg"
          width={1000}
          height={1000}
          className="object-cover fixed size-full"
          alt="background_tier"
        />
        <div className="fixed object-cover size-full z-[1] bg-gradient-to-b from-[#1A1B1F] via-[rgba(26,27,31,0.9)] via-[rgba(26,27,31,0.8)] via-[rgba(26,27,31,0.7)] to-[rgba(26,27,31,0.6)]" />
        <div className="relative z-10">{children}</div>
      </div>
      <Toaster />
    </Providers>
  );
}
