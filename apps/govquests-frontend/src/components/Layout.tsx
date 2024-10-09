"use client";
import "@rainbow-me/rainbowkit/styles.css";
import { authenticationAdapter } from "@/auth";
import { config } from "@/wagmi";
import {
  RainbowKitAuthenticationProvider,
  RainbowKitProvider,
  lightTheme,
} from "@rainbow-me/rainbowkit";
import { RainbowKitSiweNextAuthProvider } from "@rainbow-me/rainbowkit-siwe-next-auth";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { WagmiProvider } from "wagmi";
import Header from "./Header";

const queryClient = new QueryClient();

// const getSiweMessageOptions: GetSiweMessageOptions = () => ({
//   statement: "Connect wallet",
// });

const Providers = ({ children }: Readonly<{ children: React.ReactNode }>) => {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <RainbowKitAuthenticationProvider
          adapter={authenticationAdapter}
          status="unauthenticated"
        >
          <RainbowKitProvider
            theme={lightTheme({
              accentColor: "#FF0421",
              borderRadius: "medium",
            })}
          >
            {children}
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
      <Header />
      <div className="h-full">{children}</div>
    </Providers>
  );
}
