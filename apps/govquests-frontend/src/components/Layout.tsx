"use client";
import "@rainbow-me/rainbowkit/styles.css";

import { config } from "@/wagmi";
import { RainbowKitProvider, lightTheme } from "@rainbow-me/rainbowkit";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { SessionProvider } from "next-auth/react";
import { WagmiProvider } from "wagmi";
import Header from "./Header";

const queryClient = new QueryClient();

// const getSiweMessageOptions: GetSiweMessageOptions = () => ({
//   statement: "Connect wallet",
// });

const Providers = ({ children }: Readonly<{ children: React.ReactNode }>) => {
  return (
    <WagmiProvider config={config}>
      <SessionProvider refetchInterval={0}>
        <QueryClientProvider client={queryClient}>
          <RainbowKitProvider
            theme={lightTheme({
              accentColor: "#FF0421",
              borderRadius: "medium",
            })}
          >
            {children}
          </RainbowKitProvider>
        </QueryClientProvider>
      </SessionProvider>
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
      <Header />
      <div className="h-full">{children}</div>
    </Providers>
  );
}
