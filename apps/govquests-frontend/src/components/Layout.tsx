"use client";

import { WagmiProvider } from "wagmi";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { ConnectKitProvider, SIWEProvider } from "connectkit";
import { config, siweConfig } from "@/wagmi";
import Header from "./Header";
import { Toaster } from "./ui/toaster";
import { useNotificationProcessor } from "@/domains/notifications/hooks/useNotificationProcessor";

export const queryClient = new QueryClient();

const Providers = ({ children }: Readonly<{ children: React.ReactNode }>) => {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <SIWEProvider {...siweConfig}>
          <ConnectKitProvider>
            <Header />
            <div className="h-full">{children}</div>
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
  useNotificationProcessor();

  return (
    <Providers>
      <div className="h-full">{children}</div>
      <Toaster />
    </Providers>
  );
}
