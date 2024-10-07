"use client";
import { useSignMessage, WagmiProvider } from "wagmi";
import { config } from "@/wagmi";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import Header from "./Header";

const queryClient = new QueryClient();

const Providers = ({ children }: Readonly<{ children: React.ReactNode }>) => {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        {children}{" "}
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
