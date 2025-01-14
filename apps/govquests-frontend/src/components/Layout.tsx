"use client";

import { config, getSiweConfig } from "@/wagmi";
import {
  RainbowKitAuthenticationProvider,
  RainbowKitProvider,
} from "@rainbow-me/rainbowkit";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import Image from "next/image";
import { useEffect, useState } from "react";
import { WagmiProvider } from "wagmi";
import Header from "./Header";
import { Toaster } from "./ui/toaster";

export const queryClient = new QueryClient();

const Providers = ({ children }: Readonly<{ children: React.ReactNode }>) => {
  const [authStatus, setAuthStatus] = useState("loading");

  useEffect(() => {
    // Check initial authentication status
    fetch("/api/siwe/me").then((response) => {
      setAuthStatus(response.ok ? "authenticated" : "unauthenticated");
    });
  }, []);

  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <RainbowKitAuthenticationProvider
          adapter={getSiweConfig()}
          status={authStatus as any}
        >
          <RainbowKitProvider>
            <Header />
            <div className="h-full">{children}</div>
          </RainbowKitProvider>
        </RainbowKitAuthenticationProvider>
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
